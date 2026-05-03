# Genesyum AI Installer

**One-click installer pentru studenții Genesyum** — configurează Claude Code + 8 plugins + bot Telegram opțional.

## Install Genesyum (Windows) — 2 click-uri

1. **Descarcă** [`Genesyum-Install.exe`](https://github.com/byraul93/genesyum-installer/raw/main/Genesyum-Install.exe) (51 KB)
2. **Dublu-click** pe fișier → confirmă "Yes" la prompt-ul Windows (UAC) → installer pornește automat

✅ **Niciun PowerShell, niciun copy-paste, nicio comandă.**

Wizard-ul te ghidează prin:
1. **Token Genesyum** — primit prin email/Telegram de la support
2. **Setup Telegram (opțional)** — bot creat via @BotFather
3. **VS Code (opțional)** — auto-install dacă lipsește

După instalare:
- **Genesyum Terminal** pe Desktop → CLI chat
- **Genesyum VS Code** pe Desktop → IDE chat (dacă e instalat VS Code)
- **Genesyum Telegram** pe Desktop → bot activ pentru DM telefon

---

## Pentru utilizatori avansați — instalare via PowerShell

Dacă preferi linia de comandă, deschide **PowerShell ca Administrator** și rulează:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force; $i="$env:TEMP\genesyum-install.ps1"; irm "https://raw.githubusercontent.com/byraul93/genesyum-installer/main/install.ps1" -OutFile $i; & $i
```

---

## Ce se instalează

- Node.js 18+ LTS (dacă lipsește)
- Bun runtime (pentru bot Telegram)
- Claude Code CLI
- Shopify CLI
- 3 plugins Genesyum (core, nisa, build-ops)
- 5 plugins dependențe (telegram, shopify-ai-toolkit, playwright, frontend-design, context7)

## Avertizare Windows SmartScreen

La prima rulare e posibil ca Windows să afișeze "Windows protected your PC" (SmartScreen). Asta e normal pentru un fișier nou nesemnat:

1. Click **More info**
2. Click **Run anyway**

Acest mesaj dispare automat după ce mai mulți studenți rulează exe-ul (reputație SmartScreen).

## Suport

- Email: support@genesyum.com
- Probleme cu token: contact support pentru token nou

## Licență

© 2026 Raul Paclisan / Genesyum — Uz exclusiv studenți activi.
