# Genesyum AI Installer

**One-line installer for Genesyum students** — configures Claude Code + 8 plugins + optional Telegram bot.

## Install Genesyum (Windows)

Open **PowerShell as Administrator** and paste:

```powershell
Set-ExecutionPolicy -Scope CurrentUser RemoteSigned -Force; $i="$env:TEMP\genesyum-install.ps1"; irm "https://raw.githubusercontent.com/byraul93/genesyum-installer/main/install.ps1" -OutFile $i; & $i
```

Wizard will ask for:
1. **Genesyum access token** — received via email/Telegram from support
2. **Telegram setup (optional)** — bot creation via @BotFather
3. **VS Code install (optional)** — auto-install if not present

After install:
- Click **Genesyum Terminal** on Desktop → CLI chat
- Click **Genesyum VS Code** on Desktop → IDE chat (if VS Code installed)
- Click **Genesyum Telegram** on Desktop → bot active for phone DM

## What gets installed

- Node.js 18+ LTS (if missing)
- Bun runtime (for Telegram bot bridge)
- Claude Code CLI
- Shopify CLI
- 3 Genesyum plugins (core, nisa, build-ops)
- 5 dependency plugins (telegram, shopify-ai-toolkit, playwright, frontend-design, context7)

## Support

- Email: support@genesyum.com
- Token issues: contact support for new token

## License

© 2026 Raul Paclisan / Genesyum — Uz exclusiv studenți activi.
