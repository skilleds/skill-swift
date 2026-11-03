# Changelog — schematize-swift

Todas as mudanças relevantes deste pacote, no formato [Keep a Changelog](https://keepachangelog.com/pt-BR/1.1.0/),
com versionamento [SemVer](https://semver.org/lang/pt-BR/).

## [0.5.0] — 2026-11-03

### Corrigido
- CI de referência (P0-1): `on: [push, pull_request]` em macOS virou `workflow_dispatch` + `push: tags ["hml-*","v*"]`, com `concurrency` (`cancel-in-progress`) e `paths-ignore`; cabeçalho diz que o gate por commit é LOCAL (`scripts/check-swift.sh`). `plataforma.md` §2 deixa de mandar "CI a cada PR".
- Gate (P1-3): waiver `// swift-ok: motivo` agora é POR LINHA (antes testava `#`, que nunca casava, e valia pelo arquivo); force-unwrap `!` em produção virou ERRO (declaração `var x: Tipo!` segue permitida).
- Gate (P1-4): arquivo de teste só por `*Tests/*|*Tests.swift|*Test.swift` (antes `*Test*` desligava as regras em `TestFlight/…`).
- Gate (P1-5/P2-6): cobre `print(` (erro) e `fatalError(` (aviso); `@unchecked Sendable` exige comentário na mesma linha/anterior; removida linha no-op de `weak var delegate`.
- Textos (P1-5): Keychain `kSecAttrAccessible`, PrivacyInfo e supply chain do SwiftPM em `piso.md`/`plataforma.md`.
- P1-1/P1-2: bloco curto "Herda os pisos 22–29" em SKILL.md e assets/CLAUDE.md (sync-herdados fica para o orquestrador).
- P2: README v0.4.0, contagem de casos (20), `.swift-format` com `AllPublicDeclarationsHaveDocumentation: true`, referência a `schematize-c`/`schematize-cpp`.
- Testes: `check-swift.test.sh` de 10 para 20 casos (vermelho antes: 6 falhas).

### Pendente `[~]`
- P1-5: SwiftData/Observation, entitlements/ATS e `PrivacyInfo` por required-reason API em detalhe — exigem texto de política/fonte oficial; não inventado.

## [0.4.0] — 2026-10-14
Description reduzida para o orçamento de listagem do catálogo; sem mudança de piso.

### Alterado
- Description encurtada para ≤190 caracteres (catálogo estourou o orçamento de 9000 com 45 skills), mantendo O QUE + gatilho concreto + divisa com as irmãs.
- Ponteiro: o broker que emite os tokens do IAM mobile é da `schematize-iam` (`references/protocolos.md`).

## [0.3.1] — 2026-10-14
Ressincronização dos blocos herdados com a engineering v0.27.0; sem mudança de piso próprio.

### Alterado
- Description reduzida (≤235 chars) para caber no orçamento de listagem de skills (soma ≤8300); mesmo território, fronteiras com as irmãs preservadas.
- Blocos herdados ressincronizados com a `schematize-engineering` v0.27.0 (`tools/sync-herdados.mjs`): orquestração com a regra de imagem (nunca pelo Claude; detecta Codex/Gemini e pergunta ao usuário qual usar, Codex como sugestão) e `schematize overdev delegar` (comando do app) no lugar do falso nome de skill `schematize-overdev`.

## [0.3.0] — 2026-10-14
Saneamento: description válida e ancorada nos artefatos, herança explícita da base e CI de referência — porque a skill não dizia o que herdava (nem qual era o papel dela no §2.2 de `linguagens.md`) e o instalador prometia hooks que não existem.

### Corrigido
- `description` em bloco `>-`, ≤350 caracteres, YAML válido, ancorada nos artefatos da linguagem.
- Seção "Precedência e herança": §28 archive, §35 DoD, §39 índice, IAM, efeito externo, orquestração herdados da base; papel ancorado em `schematize-engineering → references/linguagens.md` §2.2; QA/ops/IAM/índice vêm de `/eng-*` (`/eng-overdev`, `/eng-plan`, `/eng-scan`, `/eng-review`). IAM/ops/entrega delegados à `schematize-mobile`.
- `install.sh`: removido o trecho que copiava `assets/hooks` e mandava registrar `assets/settings.claude.example.json` — nenhum dos dois existe (mensagem enganosa).
- `swift-help`: `/swift-load` listava "(piso, plataforma)"; corrigido para os arquivos reais. `schematize-mobile → references/...` com aviso de dependência; ressalva de toolchain passa a "uma das três (Swift, Kotlin, Dart)".

### Adicionado
- `assets/ci/github-actions-ci.yml` (actions pinadas por SHA) e arquivo de config do linter em `assets/lint/`; referenciados no SKILL.md.

### Atualizado
- Anexo volátil: Swift 6.2 Approachable Concurrency e default MainActor vs. o piso, exigência de Xcode da App Store.
- **Description** reduzida (~270 chars) para caber no orçamento de listagem (soma das 31 skills ≤ 8500; o Claude Code corta a listagem acima disso).

### Alterado
- Bloco "Precedência e herança" passa a ser herdado da base (`schematize-engineering` → `assets/herdados/precedencia.md`), gerado por `tools/sync-herdados.mjs`; corpo sem mudança de conteúdo.

## [0.2.2] — 2026-09-30
O piso de orquestração passa a ser **herdado** da base em vez de copiado à mão: uma mudança na engineering não exige mais editar 38 arquivos.

### Alterado
- Piso "Orquestrador não desenvolve; subagent barato executa" em `assets/CLAUDE.md` e `SKILL.md` agora é um bloco `<!-- herdado:engineering/orquestracao:… -->`, sincronizado de `schematize-engineering/assets/herdados/orquestracao.md` por `tools/sync-herdados.mjs` (checado no CI). Redação normalizada; conteúdo inalterado.

### Mantido (piso inalterado)
- Sonnet por default, escada até opus, sem frota ociosa (engineering `references/orquestracao.md` §9/§9.6).

## [0.2.1] — 2026-09-30
Pedido do dono: agents idle poluem a tela e seguram recurso.

### Adicionado
- Piso de orquestração ganha a regra de frota ociosa (idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata); detalhe na `schematize-engineering` §9.6.

## [0.2.0] — 2026-09-30

Pedido do dono, por **custo**: o orquestrador não desenvolve; ação onerosa vira micro-tasks baratas; `sonnet` é o default dos subagents e `opus` só entra após falha.

### Adicionado
- **Piso "Orquestrador não desenvolve; subagent barato executa"** no `assets/CLAUDE.md` e no `SKILL.md`: o agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para subagents em `sonnet` (falhou → o mesmo subagent corrige → re-decompõe → só então `opus`, com motivo). Detalhe na base: `schematize-engineering` → `references/orquestracao.md` §9.

### Mantido (piso inalterado)
- Todos os pisos anteriores e o gate de `scripts/` seguem exatamente como estavam; a mudança é só de orquestração, não de código.

## [0.1.0] — 2026-08-21

Primeira versão. A `schematize-mobile` promete escolha *"nativo vs cross por fit + ADR"* e **não havia skill por trás de nenhuma das opções** — promessa **publicada e não sustentada** (vistoria de 2026-08-21). Esta skill é uma das quatro peças que fecham isso, com `schematize-kotlin`, `schematize-dart` e o conserto da própria `schematize-mobile` (v0.3.0), no mesmo marco.

### Adicionado
- **`references/piso.md`** — o piso de linguagem: **opcional é tipo, não sugestão** (cada `!` é um `fatalError` que você escolheu adiar, e no app instalado é **crash na mão do usuário**, não exceção capturável); **concorrência estruturada** com `async/await`, **strict concurrency do Swift 6** (data race vira erro de compilação), `@MainActor` **só no que toca UI** (marcar o mundo para calar o compilador é serializar o app), `Sendable` como contrato, **cancelamento cooperativo** e a **reentrância do `actor`** — o estado pode mudar **durante** um `await` dentro dele; **ARC não é GC** (ciclo de retenção é vazamento; `unowned` errado é crash, não `nil`); erro tipado; segurança do cliente; teste.
- **`references/plataforma.md`** — SwiftPM com **`Package.resolved` commitado** (é o lockfile), build no CI com **simulador fixado** (simulador flutuante é flaky garantido), assinatura em cofre, `@available` com caminho alternativo **testado**, e a posição sobre **server-side Swift**: não é backend do rol — entra por ADR de exceção.
- **`scripts/check-swift.sh`** + **`check-swift.test.sh`** (**9 casos**, 7 vermelhos): `try!`/`as!`, `catch {}` vazio, `DispatchSemaphore`, credencial em `UserDefaults`, `NSAllowsArbitraryLoads` (no código **e** no `Info.plist`), `@unchecked Sendable` sem justificativa, `unowned`, URLSession sem timeout. Teste **pode** usar force-unwrap — a regra distingue.

### Honestidade sobre o alcance
- A toolchain Swift **não roda na máquina de referência do catálogo** (Linux). O gate é **textual** e **diz isso na saída**; onde houver `swift build`/SwiftLint, **são eles que mandam**. *Um verificador que finge ser compilador é pior que nenhum.* Os números de versão moram no anexo volátil, com a mesma ressalva.
