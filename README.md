# Genesyum AI — Setup pentru studenți

**Mentor AI dropshipping pentru piețele Big 5** (UK, US, CA, AU, NZ).

---

## Cum funcționează accesul

Fiecare student e **invitat ca colaborator** la repo-ul privat de pluginuri folosind contul lui GitHub. Niciun token, niciun secret în chat.

### Pasul 1 — Trimite admin-ului username-ul tău GitHub

Pe email/Telegram trimite la `support@genesyum.com`:

> Username-ul meu GitHub: **`username_meu`**

Admin-ul (Raul) te invită ca **collaborator cu Read access** la repo-ul `byraul93/genesyum-plugins`. Primești pe email un link de invitație.

### Pasul 2 — Acceptă invitația

Click pe link-ul din email **SAU** mergi la https://github.com/byraul93/genesyum-plugins/invitations → click **Accept invitation**.

Verifică că poți accesa repo-ul: https://github.com/byraul93/genesyum-plugins (ar trebui să fie vizibil acum).

### Pasul 3 — Loghează git pe machine-ul tău cu același cont GitHub

Cea mai ușoară metodă (alege una):
- **GitHub Desktop:** descarcă https://desktop.github.com → File → Options → Sign in
- **VS Code:** Ctrl+Shift+P → "Sign in with GitHub"
- **Terminal:** instalează GitHub CLI (`winget install GitHub.cli`) → `gh auth login`

### Pasul 4 — Deschide Claude și paste mesajul

Deschide **Claude Desktop** sau **VS Code** și paste exact:

```
Te rog citește https://raw.githubusercontent.com/byraul93/genesyum-installer/main/SETUP.md și execută toți pașii pentru mine.
```

Atât. **Niciun token, niciun secret.** Claude va:
- Verifica access-ul tău la repo (folosind credentials git deja autentificate)
- Adăuga marketplace-ul Genesyum
- Instala 3 plugins Genesyum + 5 plugins dependențe
- Configura `settings.json` (cu backup la cel existent)
- Te întreba dacă vrei Telegram bot (opțional)
- Verifica totul + raporta status

Durată: 5-10 minute.

### Pasul 5 — Restart Claude

După ce Claude raportează ✅ **Setup Genesyum complet!**:
1. Închide complet Claude Desktop / VS Code
2. Redeschide
3. Într-o sesiune nouă: scrie `/genesyum-core:start`
4. GenyAR (mentorul AI) începe onboarding-ul

---

## Pentru admin (Raul)

### Cum inviti un student

1. Studentul îți trimite username-ul GitHub
2. Mergi la https://github.com/byraul93/genesyum-plugins/settings/access
3. Click **Add people** → search username → select **Read** role → Add
4. Trimite-i studentului link-ul la README ca să continue cu pașii 2-5

### Cum revoci accesul (când student termină mentoratul)

1. https://github.com/byraul93/genesyum-plugins/settings/access
2. Găsește user-ul → Click trash icon → Confirm
3. Studentul își păstrează ce a clonat deja, dar **nu mai primește update-uri**

### Avantaje vs sistem cu PAT

| Aspect | PAT shared | GitHub Collaborator |
|---|---|---|
| Setup admin | Generezi token, distribui pe email | Add user în UI (1 click) |
| Setup student | Paste PAT în chat (Claude refuză uneori) | Doar accept invitație + login GitHub Desktop |
| Revocare | Trebuie revocat token + re-emis tuturor | 1 click pe user, restul rămân |
| Audit | Niciun trail per user | GitHub Insights — vezi cine a clonat |
| Risc leak | Studentul poate share-ui token | Studentul nu poate transfera contul |
| Token expiry | 1 an, re-issue manual la toți | N/A |

### Update-uri plugins

1. Bump version în `plugin.json` + commit + push
2. Studenții activi primesc auto-update silent (PATCH/MINOR) sau confirm prompt (MAJOR)
3. Fostii (revocați) rămân pe versiunea de la momentul revocării

---

## Suport

- Email: `support@genesyum.com`
- Probleme cu access: trimite username-ul GitHub la support pentru re-invitație

## Licență

© 2026 Raul Paclisan / Genesyum — uz exclusiv studenți activi.
