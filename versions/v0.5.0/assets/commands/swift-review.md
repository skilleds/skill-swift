---
description: schematize-swift — revisa Swift contra o piso: roda o gate e depois lê o que a máquina não lê (concorrência, memória, fronteira com a mobile)
argument-hint: "[arquivo.swift ou diretório]"
---

# /swift-review

## 1. A máquina

```bash
bash .claude/skills/schematize-swift/scripts/check-swift.sh .
# onde houver toolchain, SÃO ELES que mandam:
swift build -Xswiftc -warnings-as-errors && swift test
swiftlint --strict   # ou swift-format lint --strict
```

`0` passa · `1` reprova · `2` **nada para verificar** (não é aprovação). O gate é **textual** e diz
isso na saída.

## 2. O que a máquina não lê

- **Concorrência:** o módulo está em **Swift 6 mode**? Há `@MainActor` no que **não** toca UI (que
  serializa o app)? Toda operação longa **checa cancelamento**? Depois de cada `await` dentro de um
  `actor`, a invariante foi **relida** (reentrância)?
- **Memória:** toda closure que sobrevive à tela captura `[weak self]`? Existe `deinit` com log em
  debug nos fluxos suspeitos? O Instruments rodou nos fluxos críticos?
- **Opcional:** cada `!` restante tem invariante **real** — ou é um crash agendado?
- **Erro:** o `catch` trata, propaga ou registra **com contexto**? Nenhum `fatalError` em erro de
  I/O/rede/entrada?
- **Fronteira:** o que é de app (offline, IAM, push, loja) está seguindo a **`schematize-mobile`**,
  não uma segunda versão da regra escrita aqui?
- **Segredo:** nada no bundle; credencial no Keychain; log sem PII (`os.Logger` com `.private`).

## 3. Feche

Achado vira correção no mesmo commit ou item de checklist com dono. Mexeu no gate? rode o vermelho:
`bash scripts/check-swift.test.sh` (20 casos).
