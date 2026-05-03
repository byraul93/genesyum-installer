# Genesyum AI — Setup Instructions for Claude

**Audience:** Claude (running in student's Claude Desktop or VS Code session).
**Purpose:** Set up the Genesyum mentor system on the student's machine.

---

## 🚨 CRITICAL — How you MUST execute this setup

You have full tool access on the student's machine: `Bash`, `PowerShell`, `Write`, `Edit`, `Read`, `WebFetch`, `TodoWrite`. **YOU execute every step yourself. The student does NOTHING in a terminal.**

### Rules of execution

1. **Run every command yourself** with the `Bash` or `PowerShell` tool. Do NOT show the command and ask the student to run it. Do NOT tell them to "open a terminal."
2. **Write every file yourself** with the `Write` or `Edit` tool. Do NOT ask the student to create files manually.
3. **Use `TodoWrite`** at the start to plan all 10 steps. Update progress as you go.
4. **The ONLY thing the student does manually is create the Telegram bot in BotFather (Step 8a)** — because BotFather is a Telegram bot on their phone and you cannot reach it. Everything else = your job.
5. **Permission prompts:** if the harness asks the student to approve a tool call, just wait — they'll approve. Do not abandon the step.
6. **When you cannot run something** (e.g., a permission was denied, a tool is missing), stop and tell the student exactly what blocked you with the error verbatim. Do NOT pivot to "please run this command."

### Communication style with the student

The student does NOT need to see commands or technical detail. While executing, give them brief progress updates in Romanian, like:

> ✅ Verificat: git și node sunt instalate.
> 🔧 Adaug marketplace-ul Genesyum...
> 🔧 Instalez plugin genesyum-core...
> ✅ Plugin genesyum-core instalat.

Do NOT show shell commands, JSON snippets, or tool names. The student should feel like they're watching an assistant work, not reading documentation.

---

## What you are installing

**Genesyum AI Mentor** — a 3-plugin Claude Code system for dropshipping (Shopify + Google Shopping) on Big 5 markets (UK, US, CA, AU, NZ).

You will install:
- `genesyum-core@genesyum-dev` — onboarding, status, help
- `genesyum-nisa@genesyum-dev` — niche research workflow
- `genesyum-build-ops@genesyum-dev` — store, ads, ops, scaling
- 5 dependency plugins from `claude-plugins-official`: telegram, shopify-ai-toolkit, playwright, frontend-design, context7

---

## Prerequisites — execute these checks yourself

Run each via `Bash` or `PowerShell` tool. Capture stdout.

- `git --version` (any version)
- `node --version` (must be >= v18; parse the major version number)
- `claude --version` (you're running inside it; should return immediately)

**If `git` is missing:** install it yourself via winget:
```
winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements
```
After winget completes, refresh PATH (read `Path` from `User` and `Machine` env vars, append `C:\Program Files\Git\cmd`), then re-test `git --version`. If it still fails, tell the student that Git could not be installed automatically and the setup is blocked.

**If `node` is missing or below v18:** install yourself:
```
winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements
```
Refresh PATH, re-test. Same blocking rule on failure.

Update student briefly: "✅ Verificat: git, node, claude — toate prezente." (or report what's missing).

---

## Step 1 — Verify GitHub access (execute yourself)

The Genesyum plugins repo is private. Run:
```
git ls-remote https://github.com/byraul93/genesyum-plugins HEAD
```

- ✅ If output is a SHA hash → access OK, continue silently.
- ❌ If `Authentication failed` or `Repository not found`:
  - Stop the setup.
  - Tell the student: *"Nu am access la repo-ul Genesyum cu contul tău GitHub. Verifică două lucruri: (1) Ai acceptat invitația primită pe email de la support@genesyum.com? Verifică la https://github.com/byraul93/genesyum-plugins/invitations. (2) Ești logat cu contul GitHub corect? Cea mai simplă verificare: deschide GitHub Desktop sau VS Code, vezi că ești sign-in cu același cont care a primit invitația. Dacă tot nu merge, scrie la support@genesyum.com cu username-ul tău GitHub."*

---

## Step 2 — Install Bun runtime (execute yourself)

Run `bun --version`.

- If exit 0 → already installed, continue.
- If missing → install yourself:
  - Windows: `winget install --id Oven-sh.Bun -e --silent --accept-source-agreements --accept-package-agreements`
  - Mac/Linux: `curl -fsSL https://bun.sh/install | bash`
- After install, refresh PATH (User+Machine env vars + `%USERPROFILE%\.bun\bin`), re-test.

Update: "✅ Bun instalat."

---

## Step 3 — Add the Genesyum marketplace (execute yourself)

Run: `claude plugin marketplace add byraul93/genesyum-plugins`

If it fails with `Failed to clone`, the git auth is broken — go back to Step 1 to diagnose. Do NOT continue.

Verify with `claude plugin marketplace list` — output should contain `genesyum-dev`.

Update: "✅ Marketplace Genesyum adăugat."

---

## Step 4 — Install the 3 Genesyum plugins (execute yourself)

Run each, sequentially, waiting for each to finish:
- `claude plugin install genesyum-core@genesyum-dev --scope user`
- `claude plugin install genesyum-nisa@genesyum-dev --scope user`
- `claude plugin install genesyum-build-ops@genesyum-dev --scope user`

If any fails, capture the error verbatim and report it to the student. Do NOT silently skip.

Update progressively: "✅ genesyum-core instalat", "✅ genesyum-nisa instalat", "✅ genesyum-build-ops instalat".

---

## Step 5 — Install the 5 dependency plugins (execute yourself)

First add the public marketplace if not already added:
- `claude plugin marketplace add anthropics/claude-plugins-official` (ignore "already exists" warning)

Then install each:
- `claude plugin install telegram@claude-plugins-official --scope user`
- `claude plugin install shopify-ai-toolkit@claude-plugins-official --scope user`
- `claude plugin install playwright@claude-plugins-official --scope user`
- `claude plugin install frontend-design@claude-plugins-official --scope user`
- `claude plugin install context7@claude-plugins-official --scope user`

Update: "✅ Toate plugins instalate (3 Genesyum + 5 dependențe)."

---

## Step 6 — Configure `~/.claude/settings.json` (execute yourself)

Use the `Read`, `Write`, and `Bash` tools to do this — do NOT instruct the student.

1. Use `Read` on `~/.claude/settings.json`. If it exists:
   - Use `Bash` to copy it: `cp ~/.claude/settings.json ~/.claude/settings.json.bak.$(date +%Y%m%d-%H%M%S)` (or PowerShell equivalent on Windows).
   - Parse the existing JSON content.
2. Compute the merged JSON object: existing JSON + the keys below. Preserve any existing custom keys (hooks, mcpServers, theme, etc.) the student had.
3. Use `Write` to save the merged result to `~/.claude/settings.json` as UTF-8 without BOM.
4. Validate by running `Bash`: `node -e "JSON.parse(require('fs').readFileSync('<path>', 'utf8'))"` — if it errors, restore from the backup and tell the student.

Update: "✅ settings.json configurat (cu backup la cel existent)."

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

## Step 7 — Initialize Genesyum state (execute yourself)

Use `Bash` and `Write`:

1. Check if `~/.genesyum/state.json` exists. If yes, leave it alone.
2. If no, `mkdir -p ~/.genesyum` then `Write` content `{"schema_version":"2.0.0","student_id":null}` to that path (UTF-8 no BOM).

Update (only if created): "✅ State Genesyum inițializat."

---

## Step 8 — Telegram bot (optional)

Ask:
> "Vrei să folosești Telegram ca să-mi vorbești de pe telefon? (Y/n)"

If no, skip this entire step.

If yes, **the only manual part for the student is creating the bot in BotFather** (Step 8a). Everything after — saving the token, creating the launcher, registering auto-start — **YOU execute yourself**. The student does NOT need to open any terminal.

### 8a — Student creates the bot (this is THE ONLY manual part)

Tell them:
> "Singurul pas manual e să-mi creezi bot-ul. Durează 30 secunde:
>
> 1. Deschide pe telefon: https://t.me/BotFather
> 2. Trimite: `/newbot`
> 3. **Nume bot (display name):** trimite exact `GenyAR` — toți studenții Genesyum au același nume pentru consistență brand.
> 4. **Username (handle unic, terminat în 'bot'):** trimite ceva personalizat ție, ex: `genyar_paul_bot`, `genyar_maria_bot`. Dacă username-ul e luat, încearcă cu o cifră: `genyar_paul_2026_bot`. Username-ul îl folosești doar la prima conectare; după aceea vorbești direct cu bot-ul "GenyAR" în lista de chat-uri Telegram.
> 5. BotFather îți răspunde cu un TOKEN (format: `123456789:AAH...`)
> 6. Copiază token-ul și paste-l aici."

**Important:** if the student tries a different display name (not `GenyAR`), correct them politely:
> "Pentru consistență cu programul Genesyum, te rog folosește exact numele `GenyAR` la pasul 3. Username-ul (pasul 4) poate fi orice — acolo personalizezi."

Wait until they confirm they used `GenyAR` as the display name before proceeding.

Wait for the token. Validate format: `^\d{8,}:[A-Za-z0-9_-]{30,}$`. If invalid, ask again.

### 8b — Save token (execute yourself)

Use `Bash`/`PowerShell` and `Write`:

1. Create directory `~/.claude/channels/telegram/` if missing.
2. `Write` file `~/.claude/channels/telegram/.env` with content `TELEGRAM_BOT_TOKEN=<token>` — UTF-8, no BOM, no trailing newline.

Update: "✅ Token salvat."

### 8c — Create auto-start launcher (execute yourself, Windows)

The goal: the student NEVER needs to open a terminal again. Bot starts automatically on every Windows login.

**Step 8c-1:** Use `Bash`/`PowerShell` to create folder `%USERPROFILE%\Documents\Genesyum` if missing.

**Step 8c-2:** Use `Write` to create `%USERPROFILE%\Documents\Genesyum\Genesyum-Bot.bat` with content:
```
@echo off
title Genesyum Bot
cd /d "%USERPROFILE%\Documents\Genesyum"
start /min "" claude
```

**Step 8c-3:** Use `PowerShell` to create the Startup shortcut (WindowStyle 7 = minimized). Run this exact command:

```powershell
$WshShell = New-Object -ComObject WScript.Shell; $startup = [Environment]::GetFolderPath('Startup'); $shortcut = $WshShell.CreateShortcut("$startup\Genesyum Bot.lnk"); $shortcut.TargetPath = "$env:USERPROFILE\Documents\Genesyum\Genesyum-Bot.bat"; $shortcut.WorkingDirectory = "$env:USERPROFILE\Documents\Genesyum"; $shortcut.WindowStyle = 7; $shortcut.Description = "Genesyum Telegram bot - porneste automat cu Windows"; $shortcut.Save()
```

**Step 8c-4:** Use `PowerShell` to create the Desktop shortcut for manual start/stop:

```powershell
$WshShell = New-Object -ComObject WScript.Shell; $desktop = [Environment]::GetFolderPath('Desktop'); $shortcut = $WshShell.CreateShortcut("$desktop\Genesyum Bot.lnk"); $shortcut.TargetPath = "$env:USERPROFILE\Documents\Genesyum\Genesyum-Bot.bat"; $shortcut.WorkingDirectory = "$env:USERPROFILE\Documents\Genesyum"; $shortcut.WindowStyle = 7; $shortcut.Description = "Porneste Genesyum bot Telegram"; $shortcut.Save()
```

**Step 8c-5:** Verify both `.lnk` files exist with `Bash` (`Test-Path` in PS or `[ -f ... ]` in bash).

Update: "✅ Bot configurat să pornească automat la fiecare boot Windows. Iconița 'Genesyum Bot' e și pe Desktop dacă vrei să-l pornești/oprești manual."

### 8d — Tell the student what happens next

Send this message to them:
> "Setup Telegram complet! Bot-ul e configurat să pornească automat la fiecare boot Windows — niciodată nu mai trebuie să deschizi terminal.
>
> **Pairing-ul (o singură dată, după restart Claude):**
> 1. La pasul 10 vei restarta Claude.
> 2. După restart, deschide Telegram pe telefon și caută bot-ul **GenyAR** cu username-ul pe care l-ai ales (ex: `@genyar_xxx_bot`).
> 3. Dă-i orice mesaj (ex: 'salut'). Bot-ul îți va trimite un cod de 6 caractere.
> 4. Întoarce-te în Claude pe PC și scrie: `/telegram:access pair <COD>`
> 5. Apoi: `/telegram:access policy allowlist`
>
> **De atunci înainte:** PC pornește → bot pornit deja, scrii de pe telefon → primești răspuns. Zero terminal."

---

## Step 9 — Final verification (execute yourself)

Run `claude plugin list` via `Bash`. Verify output contains all 8 plugins enabled. If any are missing, retry Step 4/5 for that specific one.

Use `Read` on `~/.claude/settings.json` and confirm:
- `enabledPlugins` has all 8 keys set to `true`
- `extraKnownMarketplaces` includes both `genesyum-dev` and `claude-plugins-official`
- JSON parses cleanly

If any check fails, do NOT report success. Tell the student exactly what's broken.

Update: "✅ Verificare finală: toate plugins active, settings.json valid."

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
- **The Telegram bot display name MUST be `GenyAR`** (Step 8a). If the student picks a different name, ask them to redo with `GenyAR`. The username (handle) is personal and free-form.

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
