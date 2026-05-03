# Genesyum AI — Setup Instructions for Claude

**Audience:** Claude (running in student's Claude Desktop or VS Code session).
**Purpose:** This file tells you, Claude, how to set up the Genesyum mentor system on the student's machine. Read carefully and execute step by step. The student gave you this URL because they want you to do the setup for them.

---

## What you are installing

**Genesyum AI Mentor** — a 3-plugin Claude Code system that guides students through dropshipping (Shopify + Google Shopping) for Big 5 markets (UK, US, CA, AU, NZ).

You will install:
- `genesyum-core@genesyum-dev` — onboarding, status, help
- `genesyum-nisa@genesyum-dev` — niche research workflow
- `genesyum-build-ops@genesyum-dev` — store, ads, ops, scaling
- 5 dependency plugins from `claude-plugins-official`: telegram, shopify-ai-toolkit, playwright, frontend-design, context7

---

## Prerequisites — verify first

Run these checks. If any fail, ask the student to install the missing tool, then continue.

```bash
git --version       # any version
node --version      # >= v18
claude --version    # any version (you're running inside it)
```

If `git` is missing → ask student to install Git for Windows from https://git-scm.com/download/win, then re-run setup.
If `node` is missing → ask student to install Node.js LTS from https://nodejs.org, then re-run setup.

---

## Step 1 — Get the Genesyum access token (PAT)

The student should have provided a token in their message (format: `github_pat_11C...`).

If they did NOT provide it, ask:
> "Pentru a continua am nevoie de token-ul Genesyum primit pe email/Telegram (format: `github_pat_...`). Trimite-l aici."

Validate the token format with this regex: `^github_pat_[A-Za-z0-9_]{40,}$`. If invalid, ask again.

**Verify the token works** (read-only check — does NOT modify anything):

```bash
curl -s -o /dev/null -w "%{http_code}" -H "Authorization: Bearer <PAT>" https://api.github.com/repos/byraul93/genesyum-plugins
```

Expect `200`. If `401` or `404` → tell student the token is invalid/expired and to contact `support@genesyum.com`.

---

## Step 2 — Cache PAT in git credential store

Required because `claude plugin marketplace add` does a `git clone` of the private repo behind the scenes.

```bash
printf "protocol=https\nhost=github.com\nusername=x-access-token\npassword=<PAT>\n\n" | git credential approve
```

Replace `<PAT>` with the actual token. No output = success.

---

## Step 3 — Install Bun runtime (for Telegram bot bridge)

Check if Bun is already installed:
```bash
bun --version
```

If missing, install via winget (Windows):
```bash
winget install --id Oven-sh.Bun -e --silent --accept-source-agreements --accept-package-agreements
```

If winget is not available, fall back to:
```bash
powershell -c "irm bun.sh/install.ps1 | iex"
```

After install, verify `bun --version` works. If still failing, tell student to restart their terminal and re-run setup.

---

## Step 4 — Add the Genesyum marketplace

```bash
claude plugin marketplace add byraul93/genesyum-plugins
```

Should succeed silently. If it errors with auth/clone issues, repeat Step 2 (credential cache) and retry. Do NOT add the marketplace with `--token` — that flag does not exist.

Verify:
```bash
claude plugin marketplace list
```

Should list `genesyum-dev`.

---

## Step 5 — Install the 3 Genesyum plugins

Run each, one by one. Wait for each to finish before the next.

```bash
claude plugin install genesyum-core@genesyum-dev --scope user
claude plugin install genesyum-nisa@genesyum-dev --scope user
claude plugin install genesyum-build-ops@genesyum-dev --scope user
```

If any fails, capture the error output and report it to the student before continuing — do NOT silently skip.

---

## Step 6 — Install the 5 dependency plugins (public, no auth)

```bash
claude plugin install telegram@claude-plugins-official --scope user
claude plugin install shopify-ai-toolkit@claude-plugins-official --scope user
claude plugin install playwright@claude-plugins-official --scope user
claude plugin install frontend-design@claude-plugins-official --scope user
claude plugin install context7@claude-plugins-official --scope user
```

If `claude-plugins-official` marketplace is not configured, add it first:
```bash
claude plugin marketplace add anthropics/claude-plugins-official
```

---

## Step 7 — Configure `~/.claude/settings.json`

**Important:** if the file already exists, BACK IT UP first (do not destroy student's existing config):

```bash
# Windows
copy "%USERPROFILE%\.claude\settings.json" "%USERPROFILE%\.claude\settings.json.bak.<timestamp>"

# Or via Claude tools — read existing, save backup, then merge
```

**Merge strategy** (do NOT overwrite blindly):
1. Read existing `~/.claude/settings.json` (if any).
2. Add/merge the keys below into the existing JSON. Preserve any existing custom keys (hooks, mcpServers, etc.) the student already had.
3. Write back as UTF-8 without BOM.

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

## Step 8 — Initialize Genesyum state

Create `~/.genesyum/state.json` if it does not already exist (do NOT overwrite existing):

```json
{"schema_version":"2.0.0","student_id":null}
```

---

## Step 9 — Telegram bot (optional, ask student)

Ask:
> "Vrei să folosești Telegram pentru a vorbi cu mine de pe telefon? (Y/n)"

If yes:
1. Tell them to:
   - Open Telegram on their phone
   - Search `@BotFather`
   - Send `/newbot`
   - Choose a name (e.g., "GenyAR Mentor") and username (e.g., `genyar_xxx_bot`)
   - Copy the token (format: `123456789:AAH...`)
2. Ask them to paste the bot token here.
3. Validate format: `^\d{8,}:[A-Za-z0-9_-]{30,}$`. If invalid, ask again.
4. Save it (UTF-8 no BOM, no trailing newline):
   - Path: `%USERPROFILE%\.claude\channels\telegram\.env`
   - Content: `TELEGRAM_BOT_TOKEN=<token>`

Tell them they will pair their phone after restart by running `/telegram:access pair <code>` once the bot DMs them a 6-character code on first message.

---

## Step 10 — Final verification

Run this to confirm everything is in place:

```bash
claude plugin list
```

Should show all 8 plugins enabled. If any are missing, retry Step 5/6 for that one.

Read `~/.claude/settings.json` and verify:
- `enabledPlugins` has all 8 entries set to `true`
- `extraKnownMarketplaces` has `genesyum-dev` and `claude-plugins-official`
- The JSON is valid (no parse errors)

---

## Step 11 — Report to student

When everything passes, send the student this exact message in Romanian:

> ✅ **Setup Genesyum complet!**
>
> Plugins instalate: 3 Genesyum (core/nisa/build-ops) + 5 dependențe (telegram/shopify/playwright/frontend-design/context7).
>
> **Pasul următor:** trebuie să RESTARTEZI Claude (închide complet și redeschide) pentru ca plugins-urile să se activeze.
>
> După restart, scrie `/genesyum-core:start` ca să începi onboarding-ul cu GenyAR.
>
> Dacă ai configurat Telegram, după restart rulează în terminal: `/telegram:access pair <cod>` cu codul pe care ți-l trimite bot-ul când îi dai DM pe telefon.

If anything failed, instead report the exact failures with line-by-line details — DO NOT pretend success.

---

## Anti-hallucination rules for you, Claude

While doing this setup:
- **Do not invent flags** that don't exist (e.g., `claude plugin marketplace add --token` does NOT exist).
- **Do not skip steps** to be "efficient." Every step matters.
- **Do not silently swallow errors.** If a command fails, report the error to the student verbatim and stop.
- **Do not assume** packages are installed. Always verify with `--version` checks.
- **Do not write the PAT** anywhere except `git credential approve`. Do NOT save it to a file.
- **Do not write the Telegram bot token** anywhere except the `.env` file path specified.

---

## Troubleshooting reference

| Symptom | Likely cause | Fix |
|---|---|---|
| `Failed to clone marketplace repository` | git missing or PAT not cached | Re-run Step 2 (credential approve) and Step 3 (install Bun is independent) |
| `git not found or in unsafe location` | Git for Windows not installed | Install Git from https://git-scm.com/download/win |
| `npm install` fails with `npm notice` text | Output redirected stderr in PowerShell — not a real error | Check `claude --version` actually works after; if yes, ignore the notice |
| Plugin install: "marketplace not found" | Marketplace add failed silently | Re-run Step 4 |
| Settings.json is invalid after edit | BOM or syntax error | Re-read backup `*.bak.*` and merge again carefully |

---

**Maintainer:** Raul Paclisan / Genesyum
**Last updated:** 2026-05-03
**Version:** 1.0.0
