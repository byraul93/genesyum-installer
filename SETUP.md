# Genesyum AI — Setup Instructions for Claude

**Audience:** Claude (running in student's Claude Desktop or VS Code session).
**Purpose:** This file tells you, Claude, how to set up the Genesyum mentor system on the student's machine. Read carefully and execute step by step.

---

## What you are installing

**Genesyum AI Mentor** — a 3-plugin Claude Code system for dropshipping (Shopify + Google Shopping) on Big 5 markets (UK, US, CA, AU, NZ).

You will install:
- `genesyum-core@genesyum-dev` — onboarding, status, help
- `genesyum-nisa@genesyum-dev` — niche research workflow
- `genesyum-build-ops@genesyum-dev` — store, ads, ops, scaling
- 5 dependency plugins from `claude-plugins-official`: telegram, shopify-ai-toolkit, playwright, frontend-design, context7

---

## Prerequisites — verify first

```bash
git --version       # any version
node --version      # >= v18
claude --version    # any version (you're running inside it)
```

If `git` is missing → ask student to install Git for Windows from https://git-scm.com/download/win, then re-run setup.
If `node` is missing → ask student to install Node.js LTS from https://nodejs.org, then re-run setup.

---

## Step 1 — Verify GitHub access

The Genesyum plugins repo is **private**. The student must have already been **invited as a collaborator** by Raul (admin) and **accepted** the invitation via the email/notification GitHub sent them.

Check that git is authenticated with the student's GitHub account:

```bash
git config --global user.email
git config --global user.name
```

If both are empty, ask the student:
> "Trebuie să fii logat cu contul GitHub care a primit invitația la repo-ul Genesyum. Ai instalată aplicația **GitHub Desktop** sau ai folosit **VS Code → Sign in with GitHub**? Dacă nu, ruleaza în terminal: `gh auth login` (necesită GitHub CLI). Sau loghează-te din GitHub Desktop și redeschide Claude."

Test access to the private repo:

```bash
git ls-remote https://github.com/byraul93/genesyum-plugins HEAD
```

- ✅ If output is a SHA hash → access OK, continue.
- ❌ If error `Authentication failed` or `Repository not found`:
  - Tell student: *"Nu am access la repo-ul Genesyum cu contul tău GitHub. Asigură-te că ai acceptat invitația primită pe email de la Raul/Genesyum. Verifică la https://github.com/byraul93/genesyum-plugins/invitations. Dacă nu ai primit invitație, contactează `support@genesyum.com` cu username-ul GitHub."*
  - **STOP** — do not continue setup.

---

## Step 2 — Install Bun runtime (for Telegram bot bridge)

```bash
bun --version
```

If missing, install via winget (Windows):
```bash
winget install --id Oven-sh.Bun -e --silent --accept-source-agreements --accept-package-agreements
```

Mac/Linux:
```bash
curl -fsSL https://bun.sh/install | bash
```

After install, verify `bun --version`. If still failing, tell student to restart their terminal and re-run setup.

---

## Step 3 — Add the Genesyum marketplace

```bash
claude plugin marketplace add byraul93/genesyum-plugins
```

If git was authenticated correctly (Step 1), this works without any extra auth. If it fails with `Failed to clone marketplace repository`, the student's git auth is broken — re-run Step 1 verification and ask them to fix GitHub login.

Verify:
```bash
claude plugin marketplace list
```

Should show `genesyum-dev`.

---

## Step 4 — Install the 3 Genesyum plugins

```bash
claude plugin install genesyum-core@genesyum-dev --scope user
claude plugin install genesyum-nisa@genesyum-dev --scope user
claude plugin install genesyum-build-ops@genesyum-dev --scope user
```

If any fails, capture the error output and report it to the student before continuing — do NOT silently skip.

---

## Step 5 — Install the 5 dependency plugins (public, no auth)

```bash
claude plugin marketplace add anthropics/claude-plugins-official
claude plugin install telegram@claude-plugins-official --scope user
claude plugin install shopify-ai-toolkit@claude-plugins-official --scope user
claude plugin install playwright@claude-plugins-official --scope user
claude plugin install frontend-design@claude-plugins-official --scope user
claude plugin install context7@claude-plugins-official --scope user
```

(If `claude-plugins-official` marketplace is already configured, the first command will say so — that's fine, continue.)

---

## Step 6 — Configure `~/.claude/settings.json`

**Important:** if the file already exists, BACK IT UP first (do not destroy student's existing config):

1. Read existing `~/.claude/settings.json` (if any).
2. Save backup at `~/.claude/settings.json.bak.<timestamp>`.
3. Merge the keys below into the existing JSON. Preserve any custom keys (hooks, mcpServers, etc.) the student already had.
4. Write back as UTF-8 without BOM.

Required keys to ensure are present:

```json
{
  "permissions": {
    "allow": [
      "Read", "Glob", "Grep", "TodoWrite", "WebFetch", "WebSearch",
      "Bash(npm install *)", "Bash(npm install -g *)",
      "Bash(node --version)", "Bash(bun --version)",
      "Bash(shopify version*)", "Bash(shopify store auth*)", "Bash(shopify store execute*)",
      "Bash(shopify theme *)",
      "Bash(claude plugin*)",
      "Bash(git status*)", "Bash(git log*)", "Bash(git diff*)",
      "Bash(ls*)", "Bash(pwd)", "Bash(cat *)", "Bash(echo *)",
      "Bash(mkdir -p *)",
      "mcp__plugin_telegram_telegram__reply",
      "mcp__plugin_telegram_telegram__react",
      "mcp__plugin_telegram_telegram__edit_message",
      "mcp__plugin_playwright_playwright__browser_navigate",
      "mcp__plugin_playwright_playwright__browser_snapshot",
      "mcp__plugin_playwright_playwright__browser_click",
      "mcp__plugin_playwright_playwright__browser_type",
      "mcp__plugin_playwright_playwright__browser_evaluate",
      "mcp__plugin_playwright_playwright__browser_take_screenshot",
      "mcp__plugin_playwright_playwright__browser_press_key",
      "mcp__plugin_playwright_playwright__browser_wait_for",
      "mcp__plugin_playwright_playwright__browser_resize",
      "mcp__plugin_playwright_playwright__browser_navigate_back",
      "mcp__plugin_playwright_playwright__browser_hover",
      "mcp__plugin_playwright_playwright__browser_fill_form",
      "mcp__plugin_playwright_playwright__browser_select_option",
      "mcp__plugin_playwright_playwright__browser_tabs",
      "mcp__plugin_playwright_playwright__browser_console_messages",
      "mcp__plugin_playwright_playwright__browser_close",
      "mcp__plugin_context7_context7__query-docs",
      "mcp__plugin_context7_context7__resolve-library-id"
    ],
    "deny": [
      "Bash(rm -rf *)", "Bash(del /q *)", "Bash(format *)",
      "Bash(diskpart*)", "Bash(shutdown*)", "Bash(reg delete*)",
      "Bash(git push --force*)", "Bash(git reset --hard*)"
    ]
  },
  "enabledPlugins": {
    "telegram@claude-plugins-official": true,
    "shopify-ai-toolkit@claude-plugins-official": true,
    "playwright@claude-plugins-official": true,
    "frontend-design@claude-plugins-official": true,
    "context7@claude-plugins-official": true,
    "genesyum-core@genesyum-dev": true,
    "genesyum-nisa@genesyum-dev": true,
    "genesyum-build-ops@genesyum-dev": true
  },
  "extraKnownMarketplaces": {
    "claude-plugins-official": {
      "source": {"source": "github", "repo": "anthropics/claude-plugins-official"}
    },
    "genesyum-dev": {
      "source": {"source": "github", "repo": "byraul93/genesyum-plugins"}
    }
  },
  "autoUpdatesChannel": "latest"
}
```

After writing, validate the file is valid JSON before continuing.

---

## Step 7 — Initialize Genesyum state

Create `~/.genesyum/state.json` if it does not already exist (do NOT overwrite existing):

```json
{"schema_version":"2.0.0","student_id":null}
```

---

## Step 8 — Telegram bot (optional, ask student)

Ask:
> "Vrei să folosești Telegram pentru a vorbi cu mine de pe telefon? (Y/n)"

If no, skip this entire step. If yes:

### 8a — Student creates the bot

Tell them:
> "Singurul pas manual e să-mi creezi bot-ul. Durează 30 secunde:
>
> 1. Deschide pe telefon: https://t.me/BotFather
> 2. Trimite: `/newbot`
> 3. Nume (orice, ex: 'GenyAR mentor'): trimite numele
> 4. Username (terminat în 'bot', ex: 'genyar_xxx_bot'): trimite username-ul
> 5. BotFather îți răspunde cu un TOKEN (format: `123456789:AAH...`)
> 6. Copiază token-ul și paste-l aici."

Wait for the token. Validate format: `^\d{8,}:[A-Za-z0-9_-]{30,}$`. If invalid, ask again.

### 8b — Save token

Save at:
- Windows: `%USERPROFILE%\.claude\channels\telegram\.env`
- Mac/Linux: `~/.claude/channels/telegram/.env`

Content (UTF-8, no BOM, no trailing newline):
```
TELEGRAM_BOT_TOKEN=<token>
```

### 8c — Create auto-start launcher (Windows only)

This is critical — student should NEVER need to open a terminal again. Create a `.bat` file that launches Claude minimized, and place a shortcut to it in the Startup folder so the bot auto-starts on every Windows login.

**Create launcher** at `%USERPROFILE%\Documents\Genesyum\Genesyum-Bot.bat` with content:

```bat
@echo off
title Genesyum Bot
cd /d "%USERPROFILE%\Documents\Genesyum"
start /min "" claude
```

(Create the `Genesyum` folder if missing.)

**Add to Startup folder** so it auto-starts on Windows login:

Use this PowerShell command to create the shortcut in the Startup folder:

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$startup = [Environment]::GetFolderPath('Startup')
$shortcut = $WshShell.CreateShortcut("$startup\Genesyum Bot.lnk")
$shortcut.TargetPath = "$env:USERPROFILE\Documents\Genesyum\Genesyum-Bot.bat"
$shortcut.WorkingDirectory = "$env:USERPROFILE\Documents\Genesyum"
$shortcut.WindowStyle = 7
$shortcut.Description = "Genesyum Telegram bot - porneste automat cu Windows"
$shortcut.Save()
```

(`WindowStyle = 7` = minimized.)

Also place a copy on Desktop so the student can manually start/restart the bot if needed:

```powershell
$WshShell = New-Object -ComObject WScript.Shell
$desktop = [Environment]::GetFolderPath('Desktop')
$shortcut = $WshShell.CreateShortcut("$desktop\Genesyum Bot.lnk")
$shortcut.TargetPath = "$env:USERPROFILE\Documents\Genesyum\Genesyum-Bot.bat"
$shortcut.WorkingDirectory = "$env:USERPROFILE\Documents\Genesyum"
$shortcut.WindowStyle = 7
$shortcut.Description = "Porneste Genesyum bot Telegram"
$shortcut.Save()
```

### 8d — Tell the student what happens next

Tell them:
> "Setup Telegram complet! Acum:
>
> 1. Restart Claude (Step 10 te ghidează)
> 2. După restart, deschide Telegram pe telefon și DM-uiește bot-ul tău (prima oară orice mesaj). Bot-ul îți va trimite un cod de 6 caractere.
> 3. Trimite-mi codul aici (în Claude) ca să facem pairing-ul: `/telegram:access pair <COD>`
> 4. Apoi: `/telegram:access policy allowlist` ca să blochezi bot-ul doar pentru tine
>
> **De atunci înainte:** la fiecare boot Windows, bot-ul pornește singur (fereastră minimizată în taskbar). Niciodată nu mai trebuie să deschizi PowerShell sau să rulezi comenzi. Dacă vrei să-l oprești, click pe fereastra Genesyum Bot din taskbar și închide-o. Ca să-l repornești manual, dublu-click pe iconița 'Genesyum Bot' de pe Desktop."

---

## Step 9 — Final verification

```bash
claude plugin list
```

Should show all 8 plugins enabled. If any are missing, retry Step 4/5 for that one.

Read `~/.claude/settings.json` and verify:
- `enabledPlugins` has all 8 entries set to `true`
- `extraKnownMarketplaces` has `genesyum-dev` and `claude-plugins-official`
- The JSON is valid (no parse errors)

---

## Step 10 — Report to student

When everything passes, send the student this exact message in Romanian:

> ✅ **Setup Genesyum complet!**
>
> Plugins instalate: 3 Genesyum (core/nisa/build-ops) + 5 dependențe (telegram/shopify/playwright/frontend-design/context7).
>
> **Pasul următor:** închide complet Claude și redeschide-l. După restart:
>
> 1. Scrie `/genesyum-core:start` — GenyAR (mentorul tău AI) preia de aici.
>
> Dacă ai configurat Telegram (Step 8):
> 2. Bot-ul Genesyum e deja setat să pornească automat la fiecare boot Windows (icoana **Genesyum Bot** e și pe Desktop dacă vrei să-l pornești/oprești manual).
> 3. Pentru pairing inițial: după restart Claude, deschide Telegram pe telefon → DM-uiește bot-ul tău o dată → primești cod 6 caractere → întoarce-te la Claude pe PC și scrie `/telegram:access pair <COD>` apoi `/telegram:access policy allowlist`. Asta se face **o singură dată**, niciodată repetat.

If anything failed, instead report the exact failures with line-by-line details — DO NOT pretend success.

---

## Anti-hallucination rules for you, Claude

While doing this setup:
- **Do not invent flags** that don't exist (e.g., `claude plugin marketplace add --token` does NOT exist).
- **Do not skip steps** to be "efficient." Every step matters.
- **Do not silently swallow errors.** If a command fails, report the error to the student verbatim and stop.
- **Do not assume** packages are installed. Always verify with `--version` checks.
- **Do not ask for or accept GitHub PATs** in chat. The auth model is GitHub Collaborator (Step 1) — student must have been invited to the repo and accepted. There is no token to paste.
- **Do not write the Telegram bot token** anywhere except the `.env` file path specified.

---

## Troubleshooting reference

| Symptom | Likely cause | Fix |
|---|---|---|
| `Failed to clone marketplace repository: Authentication failed` | git not logged in with the GitHub account that has access | Run `gh auth login` or sign in via GitHub Desktop / VS Code; restart Claude |
| `Repository not found` (yet student knows it exists) | Student wasn't invited or didn't accept invitation | Send student to https://github.com/byraul93/genesyum-plugins/invitations to accept; if no invitation, contact support |
| `git not found or in unsafe location` | Git for Windows not installed | Install Git from https://git-scm.com/download/win |
| Plugin install: "marketplace not found" | Marketplace add failed silently | Re-run Step 3 |
| Settings.json is invalid after edit | BOM or syntax error | Re-read backup `*.bak.*` and merge again carefully |

---

**Maintainer:** Raul Paclisan / Genesyum
**Last updated:** 2026-05-03
**Version:** 1.1.0 (auth via GitHub Collaborator, no PAT)
