# Genesyum AI — Setup pentru studenți

**Mentor AI dropshipping pentru piețele Big 5** (UK, US, CA, AU, NZ).

---

## Cum se instalează (zero comenzi PowerShell)

Studentul are deja **Claude Desktop** sau **VS Code cu extensia Claude** (vine cu abonamentul Claude). Folosim Claude pentru a face setup-ul automat — tu doar îi dai instrucțiunile.

### Pasul 1 — Deschide Claude

- **Claude Desktop:** click pe iconița Claude → New Chat
- **VS Code:** instalează extensia [Claude](https://marketplace.visualstudio.com/items?itemName=anthropic.claude-code), apoi `Ctrl+Shift+P` → "Claude: New Chat"

### Pasul 2 — Paste acest mesaj în chat

```
Te rog citește https://raw.githubusercontent.com/byraul93/genesyum-installer/main/SETUP.md și execută toți pașii pentru mine.

Token-ul meu Genesyum: github_pat_XXXXXXXXXXXXXXXX
```

(Înlocuiește `github_pat_XXX...` cu token-ul real primit pe email/Telegram de la support@genesyum.com.)

### Pasul 3 — Lasă Claude să facă setup-ul

Claude va:
- Verifica prerequisitele (git, node)
- Adăuga marketplace-ul privat Genesyum (cu token-ul tău)
- Instala 3 plugins Genesyum (core, nisa, build-ops)
- Instala 5 plugins dependențe (telegram, shopify, playwright, frontend-design, context7)
- Configura `settings.json` (cu backup la cel existent)
- Te întreba dacă vrei Telegram bot (opțional)
- Verifica totul + raporta status

Durată: 5-10 minute.

### Pasul 4 — Restart Claude

După ce Claude raportează ✅ **Setup Genesyum complet!**:
1. Închide complet Claude Desktop / VS Code
2. Redeschide
3. Într-o sesiune nouă: scrie `/genesyum-core:start`
4. GenyAR (mentorul AI) începe onboarding-ul

---

## Pentru mentori / contributori

Repo-uri:
- **`genesyum-installer`** (acesta, public) — `SETUP.md` cu instrucțiuni pentru Claude
- **`genesyum-plugins`** (privat) — codul real al plugin-urilor; access read-only via PAT

Distribuție token studenți:
1. Generează un Fine-grained PAT pe `genesyum-plugins` cu Contents: Read-only
2. Trimite token-ul prin email/Telegram studentului împreună cu link-ul la setup

Update-uri plugins:
1. Bump version în `plugin.json` + commit + push
2. Studenții primesc auto-update silent (PATCH/MINOR) sau confirm prompt (MAJOR)

---

## Suport

- Email: support@genesyum.com
- Probleme cu token: contact support pentru token nou

## Licență

© 2026 Raul Paclisan / Genesyum — uz exclusiv studenți activi.
