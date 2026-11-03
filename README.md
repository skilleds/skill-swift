# schematize-swift

> **O piso de Swift da casa** — cliente Apple (iOS/iPadOS/macOS). Force-unwrap é `fatalError`
> adiado; concorrência é estruturada e o compilador do Swift 6 é aliado; ARC não é GC; segredo nunca
> vai no bundle. E a fronteira é explícita: **no que é de app, a `schematize-mobile` manda**.

Pacote de **skill normativa para [Claude Code](https://claude.com/claude-code)**.
Parte do catálogo **schematize skills**.

## Por que ela existe

A `schematize-mobile` promete escolha *"nativo vs cross por fit + ADR"* — e não havia **skill por
trás de nenhuma opção**. Promessa publicada e não sustentada (vistoria de 2026-08-21).

## Instalar

```bash
schematize install swift          # pelo app schematize
# ou
git clone https://github.com/schematizeme/skill-swift.git /tmp/skill-swift
bash /tmp/skill-swift/install.sh .
```

## O que tem dentro

- **SKILL.md** — o contrato: 11 pisos inegociáveis + mapa de references.
- **references/** — `piso` (opcional, concorrência, ARC, erro, segurança, teste), `plataforma`
  (SwiftPM, CI, assinatura, `@available`, interop), `stack-versoes` (anexo volátil, datado).
- **scripts/** — `check-swift.sh` (gate textual, honesto sobre o alcance) e `check-swift.test.sh`
  (20 casos).
- **assets/commands/** — `/swift-help`, `/swift-load`, `/swift-review`, `/swift-claude`,
  `/swift-cc`, `/swift-handoff`.
- **assets/CLAUDE.md** — regra sempre-on.

## Comandos

| Comando | O que faz |
|---|---|
| `/swift-help` | lista os comandos |
| `/swift-load` | carrega o corpo normativo |
| `/swift-review` | roda o gate e revisa o que a máquina não lê |
| `/swift-claude` | cria/mescla o `CLAUDE.md` sempre-on |
| `/swift-cc` · `/swift-handoff` | context compact / handoff no archive |

## Versão

**v0.4.0** — changelog em `CHANGELOG.md`.

## Regra de ouro

**Cada `!` é um crash que você agendou para a mão do usuário.**

MIT.
