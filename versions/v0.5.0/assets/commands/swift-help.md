---
description: Mapa da skill schematize-swift (o piso de linguagem do cliente Apple).
---
**schematize-swift** — o piso de Swift da casa (cliente Apple).

| Comando | O que faz |
|---|---|
| `/swift-help` | esta lista |
| `/swift-load` | carrega TODO o corpo normativo (piso, plataforma) e passa a aplicá-lo |
| `/swift-review` | roda `scripts/check-swift.sh` e revisa o que a máquina não lê |
| `/swift-claude` | cria ou mescla o `CLAUDE.md` sempre-on na raiz do repo |
| `/swift-cc` · `/swift-handoff` | context compact / handoff no archive |

**A fronteira:** no que é de **app** (offline-first, IAM, push, lojas, teste no device), quem manda é
a **`schematize-mobile`**. Aqui é linguagem e toolchain.
