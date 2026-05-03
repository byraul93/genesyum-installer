#requires -version 5
# Genereaza icon.ico multi-size (16, 32, 48, 64, 128, 256) pentru Genesyum-Install.exe
# Foloseste System.Drawing - nicio dependenta externa

Add-Type -AssemblyName System.Drawing

$outputIco = Join-Path $PSScriptRoot 'icon.ico'
$sizes = @(16, 32, 48, 64, 128, 256)
$pngs = @()

function New-IconBitmap {
    param([int]$Size)

    $bmp = New-Object System.Drawing.Bitmap $Size, $Size, ([System.Drawing.Imaging.PixelFormat]::Format32bppArgb)
    $g   = [System.Drawing.Graphics]::FromImage($bmp)
    $g.SmoothingMode     = [System.Drawing.Drawing2D.SmoothingMode]::AntiAlias
    $g.TextRenderingHint = [System.Drawing.Text.TextRenderingHint]::ClearTypeGridFit
    $g.Clear([System.Drawing.Color]::Transparent)

    # Background — rounded rect cu gradient simulat (linear)
    $rectF = New-Object System.Drawing.RectangleF 0, 0, $Size, $Size
    $radius = [Math]::Max(2, [int]($Size * 0.18))

    $path = New-Object System.Drawing.Drawing2D.GraphicsPath
    $path.AddArc($rectF.X, $rectF.Y, $radius * 2, $radius * 2, 180, 90)
    $path.AddArc($rectF.Right - $radius * 2, $rectF.Y, $radius * 2, $radius * 2, 270, 90)
    $path.AddArc($rectF.Right - $radius * 2, $rectF.Bottom - $radius * 2, $radius * 2, $radius * 2, 0, 90)
    $path.AddArc($rectF.X, $rectF.Bottom - $radius * 2, $radius * 2, $radius * 2, 90, 90)
    $path.CloseFigure()

    $bgBrush = New-Object System.Drawing.Drawing2D.LinearGradientBrush(
        $rectF,
        [System.Drawing.Color]::FromArgb(255, 15, 23, 42),
        [System.Drawing.Color]::FromArgb(255, 30, 64, 175),
        [System.Drawing.Drawing2D.LinearGradientMode]::ForwardDiagonal
    )
    $g.FillPath($bgBrush, $path)

    # Cerc accent
    if ($Size -ge 32) {
        $ringPen = New-Object System.Drawing.Pen ([System.Drawing.Color]::FromArgb(255, 56, 189, 248)), ([Math]::Max(1, $Size * 0.055))
        $cx = $Size / 2.0
        $cy = $Size / 2.0
        $r  = $Size * 0.32
        $g.DrawEllipse($ringPen, [float]($cx - $r), [float]($cy - $r), [float]($r * 2), [float]($r * 2))
        $ringPen.Dispose()
    }

    # Litera G
    $fontSize = [Math]::Max(6, [int]($Size * 0.55))
    $font = New-Object System.Drawing.Font ('Segoe UI', $fontSize, [System.Drawing.FontStyle]::Bold, [System.Drawing.GraphicsUnit]::Pixel)
    $sf = New-Object System.Drawing.StringFormat
    $sf.Alignment     = [System.Drawing.StringAlignment]::Center
    $sf.LineAlignment = [System.Drawing.StringAlignment]::Center
    $textBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 248, 250, 252))
    $g.DrawString('G', $font, $textBrush, $rectF, $sf)

    # Punct verde status (doar pe size-uri mari)
    if ($Size -ge 48) {
        $dotR = $Size * 0.07
        $dotBrush = New-Object System.Drawing.SolidBrush ([System.Drawing.Color]::FromArgb(255, 34, 197, 94))
        $g.FillEllipse($dotBrush, [float]($Size * 0.78 - $dotR), [float]($Size * 0.78 - $dotR), [float]($dotR * 2), [float]($dotR * 2))
        $dotBrush.Dispose()
    }

    $g.Dispose()
    $bgBrush.Dispose()
    $textBrush.Dispose()
    $font.Dispose()
    $path.Dispose()

    return $bmp
}

# Generam PNG-uri in memorie + scriem ICO multi-size
$ms = New-Object System.IO.MemoryStream
$bw = New-Object System.IO.BinaryWriter $ms

# ICONDIR header (6 bytes)
$bw.Write([uint16]0)               # reserved
$bw.Write([uint16]1)               # type = 1 (ICO)
$bw.Write([uint16]$sizes.Count)    # count

$entryHeaderSize = 16
$dataOffset = 6 + ($entryHeaderSize * $sizes.Count)

$bitmaps = @()
$pngBytes = @()

foreach ($size in $sizes) {
    $bmp = New-IconBitmap -Size $size
    $bitmaps += $bmp
    $pngStream = New-Object System.IO.MemoryStream
    $bmp.Save($pngStream, [System.Drawing.Imaging.ImageFormat]::Png)
    $pngBytes += , $pngStream.ToArray()
    $pngStream.Dispose()
}

# ICONDIRENTRY entries
for ($i = 0; $i -lt $sizes.Count; $i++) {
    $size = $sizes[$i]
    $bytes = $pngBytes[$i]
    $w = if ($size -ge 256) { 0 } else { $size }
    $h = if ($size -ge 256) { 0 } else { $size }
    $bw.Write([byte]$w)             # width
    $bw.Write([byte]$h)             # height
    $bw.Write([byte]0)              # color count
    $bw.Write([byte]0)              # reserved
    $bw.Write([uint16]1)            # planes
    $bw.Write([uint16]32)           # bpp
    $bw.Write([uint32]$bytes.Length) # size in bytes
    $bw.Write([uint32]$dataOffset)   # offset
    $dataOffset += $bytes.Length
}

# PNG data
foreach ($bytes in $pngBytes) { $bw.Write($bytes) }

$bw.Flush()
[System.IO.File]::WriteAllBytes($outputIco, $ms.ToArray())
$bw.Dispose()
$ms.Dispose()
foreach ($bmp in $bitmaps) { $bmp.Dispose() }

Write-Host "Icon generated: $outputIco ($((Get-Item $outputIco).Length) bytes)" -ForegroundColor Green
