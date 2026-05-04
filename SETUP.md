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
5. **Permission prompts:** the harness will ask the student to approve some tool calls. Tell the student up front (before running the first Bash/PowerShell command):
   > "Vei vedea câteva pop-up-uri unde Claude Code îți cere permisiune să ruleze comenzi. La fiecare, click **'Allow for this conversation'** (NU 'Allow once') — așa nu mai apare la fiecare comandă și setup-ul curge fluent."
   
   If a permission is denied, stop and ask the student to retry the step.
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

**Note:** Python is NOT required. Genesyum hooks rulează 100% în Node.js (din v1.0.2). NU instala Python — pierdere de timp.

### Git
**If missing:** `winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements`
After install, refresh PATH (User+Machine env vars + `C:\Program Files\Git\cmd`) and re-test. Block setup if still missing.

### Node.js
**If missing or below v18:** `winget install --id OpenJS.NodeJS.LTS -e --silent --accept-source-agreements --accept-package-agreements`
Refresh PATH, re-test.

### Final prerequisite report

After all three checks pass: "✅ Verificat: git, node, claude — toate prezente și funcționale."

If any check fails, stop and report exactly what's blocked.

---

## Step 1 — Verify GitHub access AND cache git credentials (execute yourself)

**Why this step is critical:** Step 3 (`claude plugin marketplace add`) does a `git clone` of the private repo behind the scenes. If git credentials aren't cached in Git Credential Manager (Windows) / keychain (Mac), the clone hangs silently waiting for a popup that Claude can't see → setup blocks at Step 3. Solution: prove auth + cache it NOW, in Step 1.

### 1.1 — Try `git ls-remote` with no auth fallback

```
git ls-remote https://github.com/byraul93/genesyum-plugins HEAD
```

- ✅ If output is a SHA hash → student already has cached GitHub auth in git. Continue to Step 2.
- ❌ If exits non-zero / hangs / shows `Authentication failed` / `Repository not found` / `terminal prompts disabled`:

### 1.2 — Bootstrap credentials via GitHub CLI

The cleanest way to make git work for the rest of setup is to install GitHub CLI and run `gh auth login`. CLI handles browser-based OAuth, then writes credentials to Git Credential Manager automatically (Windows) or keychain (Mac/Linux).

Install if missing:
- Windows: `winget install --id GitHub.cli -e --silent --accept-source-agreements --accept-package-agreements`
- Mac: `brew install gh`
- Linux: see https://cli.github.com/

Refresh PATH after install.

Then trigger interactive auth (this opens a browser tab for the student):
```
gh auth login --web --git-protocol https --hostname github.com
```

Tell the student:
> "Vei vedea un cod în terminal și se va deschide browserul. Copiază codul, lipește-l în pagina GitHub, autorizează — apoi revino aici. Asta e singura dată când e nevoie de browser pentru setup."

Wait until `gh auth status` returns "Logged in to github.com as ...".

### 1.3 — Setup git credential helper to use gh

After successful login, run:
```
gh auth setup-git
```

This wires GitHub CLI as the credential helper for git, so subsequent `git clone` commands authenticate automatically.

### 1.4 — Re-test access

Re-run:
```
git ls-remote https://github.com/byraul93/genesyum-plugins HEAD
```

- ✅ SHA → continue.
- ❌ Still failing → student likely wasn't invited or accepted. Tell them:
  > "Sunt logat cu contul tău GitHub, dar tot nu am access la repo-ul Genesyum. Verifică două lucruri: (1) Ai acceptat invitația de la support@genesyum.com? Vezi la https://github.com/byraul93/genesyum-plugins/invitations. (2) Contul cu care ești logat acum (`gh auth status` îți spune care) e același cu cel pe care l-ai trimis la support? Dacă da și nu vezi invitație în pagina de mai sus, scrie la support@genesyum.com cu username-ul GitHub afișat de `gh auth status`."
  
  Stop the setup.

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

Use the `Read`, `Write`, and `Bash`/`PowerShell` tools — do NOT instruct the student.

The settings file path:
- Windows: `$env:USERPROFILE\.claude\settings.json` (or in bash: `~/.claude/settings.json`)
- Mac/Linux: `~/.claude/settings.json`

### 6.1 — Check existence and back up

First check if the file exists. Use `Bash` (`test -f ~/.claude/settings.json && echo EXISTS`) or `PowerShell` (`Test-Path "$env:USERPROFILE\.claude\settings.json"`).

- **If it does not exist:** skip backup, treat existing config as `{}`.
- **If it exists:** back it up with a timestamped filename. Pick the right shell:
  - PowerShell: `Copy-Item "$env:USERPROFILE\.claude\settings.json" "$env:USERPROFILE\.claude\settings.json.bak.$(Get-Date -Format 'yyyyMMdd-HHmmss')"`
  - Bash: `cp ~/.claude/settings.json ~/.claude/settings.json.bak.$(date +%Y%m%d-%H%M%S)`

### 6.2 — Read existing config

Use `Read` only after confirming the file exists. Parse to a JSON object (or start from `{}` if missing).

### 6.3 — Deep-merge the required keys (do NOT overwrite)

The student may have existing custom config (hooks, mcpServers, theme, custom permissions). **Merge**, do not replace. Strategy per key:

- **`permissions.allow`** — UNION of student's existing entries + the entries from the template below. Deduplicate.
- **`permissions.deny`** — UNION of student's existing entries + the deny list below. Deduplicate.
- **`enabledPlugins`** — merge keys; if student already has `theme: false` for some plugin, preserve their choice. Add only missing Genesyum/dependency keys, all set to `true`.
- **`extraKnownMarketplaces`** — merge keys; preserve existing marketplaces, add `genesyum-dev` and `claude-plugins-official` if missing.
- **`autoUpdatesChannel`** — only set if the student does not already have a value.
- **All other top-level keys** (hooks, mcpServers, theme, env, etc.) — preserve untouched.

### 6.4 — Write merged config

Use `Write` to save the merged JSON to the settings path. UTF-8 without BOM. Pretty-print with 2-space indent.

### 6.5 — Validate

Use `Bash`/`PowerShell` to run a JSON parse check:
- PowerShell: `Get-Content "$env:USERPROFILE\.claude\settings.json" -Raw | ConvertFrom-Json | Out-Null; "OK"`
- Bash: `node -e "JSON.parse(require('fs').readFileSync(process.env.HOME + '/.claude/settings.json','utf8'))" && echo OK`

If invalid, restore from the most recent `.bak.*` backup and tell the student exactly what went wrong.

Update: "✅ settings.json configurat (cu backup la cel existent dacă era cazul)."

Required keys to ensure are present:

```json
{
  "permissions": {
    "allow": [
      "Read", "Write", "Edit", "Glob", "Grep", "TodoWrite", "WebFetch", "WebSearch",
      "Bash(npm install *)", "Bash(npm install -g *)",
      "Bash(node --version)", "Bash(bun --version)",
      "Bash(shopify version*)", "Bash(shopify store auth*)", "Bash(shopify store execute*)",
      "Bash(shopify theme *)",
      "Bash(claude plugin*)",
      "Bash(gh *)",
      "Bash(git status*)", "Bash(git log*)", "Bash(git diff*)",
      "Bash(git ls-remote *)", "Bash(git config*)", "Bash(git credential*)",
      "Bash(ls*)", "Bash(pwd)", "Bash(cat *)", "Bash(echo *)",
      "Bash(mkdir -p *)",
      "Bash(start *)",
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

Path:
- Windows: `$env:USERPROFILE\.genesyum\state.json`
- Mac/Linux: `~/.genesyum/state.json`

1. Check if the file exists (PowerShell `Test-Path` or Bash `test -f`).
2. If yes, leave it alone — DO NOT overwrite student progress.
3. If no:
   - Create the directory: PowerShell `New-Item -ItemType Directory -Force -Path "$env:USERPROFILE\.genesyum"` or Bash `mkdir -p ~/.genesyum`
   - Use `Write` to create the file with content `{"schema_version":"2.0.0","student_id":null,"student_name":null}` (UTF-8 no BOM).

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
> "Setup Telegram complet! Bot-ul e configurat să pornească automat la **fiecare boot Windows viitor**. (Pentru sesiunea de astăzi, va trebui să-l pornești manual o dată — vezi pasul 2 mai jos.)
>
> **Pairing-ul (o singură dată):**
> 1. **Restartează Claude** (vezi mesajul final de la pasul 10).
> 2. **Pornește bot-ul manual prima dată:** dublu-click pe iconița **Genesyum Bot** de pe Desktop. Se deschide o fereastră minimizată în taskbar — asta e bot-ul care rulează. (De la următorul login Windows, pornește singur, nu mai trebuie click manual.)
> 3. **Pe telefon:** deschide Telegram, caută bot-ul cu username-ul tău (ex: `@genyar_xxx_bot`), trimite-i orice mesaj. Bot-ul îți va trimite un cod de 6 caractere.
> 4. **Pe PC, în Claude (sesiune nouă, după restart):** scrie `/telegram:access pair <COD>` (înlocuiește `<COD>` cu cele 6 caractere). Apoi: `/telegram:access policy allowlist`.
>
> **De acum încolo:** PC pornește → bot pornit deja → scrii de pe telefon → primești răspuns. Zero terminal."

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

## Idempotency — handling re-runs

A student may re-run this setup (machine reinstall, second laptop, partial previous run). Each step must be safe to repeat:

- **Marketplace add** — if `claude plugin marketplace add` reports "already exists" or non-zero exit because of duplicate, treat as success and continue.
- **Plugin install** — if `claude plugin install <name>` reports "already installed" or fails because plugin exists, treat as success and continue.
- **settings.json** — backup + deep-merge (Step 6) — never overwrite existing custom keys.
- **state.json** — only create if missing (Step 7).
- **`.env` Telegram token** — overwrite is safe; the new token is the source of truth if student created a new bot.
- **Launcher `.bat` and `.lnk` shortcuts** — overwrite is safe; existing files get refreshed.

If a step fails for an unexpected reason (not "already exists" / "already installed"), stop and report the actual error.

---

## Anti-hallucination rules for you, Claude

While doing this setup:
- **Do not invent flags** that don't exist. Specifically: `claude plugin marketplace add --token` does NOT exist (only `--scope` and `--sparse`). `claude --channels plugin:...` does NOT exist (Telegram plugin auto-loads from `enabledPlugins`).
- **Do not skip steps** to be "efficient." Every step matters.
- **Do not silently swallow errors.** If a command fails, report the error to the student verbatim and stop.
- **Do not assume** packages are installed. Always verify with `--version` checks.
- **Do not ask for or accept GitHub PATs** in chat. The auth model is GitHub Collaborator (Step 1) — student must have been invited to the repo and accepted. There is no token to paste.
- **Do not write the Telegram bot token** anywhere except the `.env` file path specified.
- **The Telegram bot display name MUST be `GenyAR`** (Step 8a). If the student picks a different name, ask them to redo with `GenyAR`. The username (handle) is personal and free-form.
- **Do not invent MCP tool names.** Specifically `browser_scroll` does NOT exist in the Playwright MCP tool list. Stick to the names in the settings.json template.
- **PowerShell stderr is not always an error.** When running `npm install`, `claude plugin install`, `git`, etc. via PowerShell, native command stderr (e.g., "npm notice") gets wrapped as ErrorRecords if `$ErrorActionPreference='Stop'`. Use `$LASTEXITCODE` to determine real success/failure, not the presence of stderr text.
- **Do NOT install Python.** Genesyum hooks rulează 100% Node.js începând cu plugin v1.0.2. Python NU mai e folosit la runtime. Dacă vezi în vechi tutorial / vechi versiune SETUP.md că trebuie Python, ignoră — e obsolete. Singurele runtime-uri necesare: Node 18+ (hooks), Bun (Telegram bot bridge). Python install = waste de 5+ minute pentru student.
- **Git auth MUST be cached BEFORE Step 3.** `claude plugin marketplace add` face git clone în background. Dacă auth nu e cache-uit, git triggers Git Credential Manager popup invisible to Claude → setup hang silent. Step 1 obligatoriu via `gh auth login` + `gh auth setup-git` înainte de orice marketplace add.

---

## Troubleshooting reference

| Symptom | Likely cause | Fix |
|---|---|---|
| Setup hangs at Step 3 (marketplace add) with no error | Git Credential Manager popup invisible to Claude → blocks waiting for student | Re-run Step 1 (`gh auth login`) to ensure credentials are properly cached before retrying Step 3 |
| `Failed to clone marketplace repository: Authentication failed` | git credential cache missing or expired | Run `gh auth login` then `gh auth setup-git`; retry Step 3 |
| `Repository not found` (yet student knows it exists) | Student wasn't invited / didn't accept invitation, OR logged in with wrong GitHub account | (1) Check https://github.com/byraul93/genesyum-plugins/invitations. (2) Verify `gh auth status` shows the account that received the invite. (3) If mismatch, log out + log in with correct account. (4) If no invite, contact support |
| `git not found or in unsafe location` | Git for Windows not installed | Install Git: `winget install --id Git.Git -e --silent --accept-source-agreements --accept-package-agreements` |
| Plugin install: "marketplace not found" | Marketplace add failed silently | Re-run Step 3 after verifying Step 1 auth is working |
| Settings.json is invalid after edit | BOM or syntax error | Re-read backup `*.bak.*` and merge again carefully |
| Bot Telegram răspunde ca "Claude" generic, nu ca GenyAR | Plugin version pre-1.0.2 (vechi cu Python) pe machine | Update: `claude plugin update genesyum-core` (latest = 1.1.1 cu Node.js hooks). Restart bot Telegram |
| Permission denied for `Bash(git ...)` or `Bash(gh ...)` | settings.json allowlist out-of-date | Either click "Allow for this conversation" at the popup, OR re-run Step 6 to apply latest allowlist |

---

**Maintainer:** Raul Paclisan / Genesyum
**Last updated:** 2026-05-04
**Version:** 1.2.0 (Python prereq removed — hooks 100% Node.js; gh auth login pre-flight pentru git credential cache; allowlist extended cu git ls-remote/config/credential + gh)
