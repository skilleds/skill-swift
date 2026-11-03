---
name: schematize-swift
metadata:
  version: 0.4.0
description: >-
  Piso de Swift para Apple. Use ao tocar Package.swift, *.swift ou *.xcodeproj: sem force-unwrap, concorrência estrita, ciclos de retenção, Keychain. IAM e lojas: mobile.
---
<!-- cross-skill: linguagens.md -> schematize-engineering -->

# O piso de Swift da casa (schematize-swift)

Recorte de **linguagem** para o cliente Apple. A base agnóstica é a **`schematize-engineering`**; o
piso de **app** (offline-first, IAM mobile, push, lojas, testes no device) é da
**`schematize-mobile`** — e, no que é de app, **ela manda**. Aqui fica o que é da linguagem e da
toolchain.

**Versão:** skill `schematize-swift` v0.4.0. Changelog em `CHANGELOG.md`.

## Precedência e herança (leia antes de divergir)

<!-- herdado:engineering/precedencia:mobile intro="Esta skill é o recorte **Swift** das linguagens **sancionadas fora do rol de backend** (`schematize-engineering` → `references/linguagens.md` §2.2): cliente **iOS/iPadOS/macOS**, **sob a `schematize-mobile`**." cmd="swift" -->Esta skill é o recorte **Swift** das linguagens **sancionadas fora do rol de backend** (`schematize-engineering` → `references/linguagens.md` §2.2): cliente **iOS/iPadOS/macOS**, **sob a `schematize-mobile`**.

1. **Onde esta skill divergir da base, a BASE MANDA.** Aqui mora a especialização — a lib, o gate, a
   sintaxe da linguagem. Divergência de *piso* é defeito desta skill, não variante local.
2. **O que não está repetido aqui é HERDADO, não dispensado.** Valem integralmente, sem cópia local:
   - **§28 Archive** — `<projeto>/<projeto>_archive/` é **repositório git próprio, PRIVADO e
     obrigatório**, criticidade 0 (`schematize-archive`).
   - **§35 Definition of Done** e a lista de anti-padrões (citada por **título**, nunca por número).
   - **§39 Índice/MAPA** — enumeração exaustiva (uma entrada por unidade chamável, `M == N`) e grafo
     com arestas em ASCII (`A -> B`), nunca a seta unicode.
   - **IAM** (`schematize-engineering` → `references/iam.md`): identidade ≠ email, ≥2 fatores, ReBAC
     multi-tenant, argon2id-only para senha nova, sessão longa e logout irreversível.
   - **Efeito externo** nunca sai de não-produção (`schematize-engineering` →
     `references/efeitos-externos.md`).
   - **Orquestração** (`schematize-engineering` → `references/orquestracao.md` §9): o principal não
     desenvolve (é Claude Opus); executor mais barato que resolve — `haiku`/`sonnet` → Codex Terra → Cursor → `opus` só após falha; visual direto ao Codex; imagem nunca pelo Claude: detecta Codex/Gemini e pergunta ao usuário qual usar (Codex é a sugestão, não automática), nunca API paga.
3. **Delegado à `schematize-mobile`, por nome:** IAM mobile (public client OIDC/PKCE, passkeys,
   Keychain/Keystore), ops, offline/sync, push, testes no device e entrega nas lojas
   (`schematize-mobile` → `references/testes-mobile.md`, `schematize-mobile` →
   `references/entrega-lojas.md`; comandos `/mobile-auth`, `/mobile-offline`, `/mobile-test`,
   `/mobile-release`). **Dependência:** instale a `schematize-mobile` junto; sem ela esses
   arquivos não existem no seu ambiente e o piso de app fica sem dono.
4. **QA, ops, IAM e índice não têm comando próprio aqui:** vêm da base `/eng-*`. Para trabalho
   contínuo use `/eng-overdev`; para planejar `/eng-plan`; para varrer a base `/eng-scan`; para
   revisão geral `/eng-review` (e `/eng-ops`, `/eng-iam`, `/eng-index`). Os comandos
   `/swift-*` cobrem só o piso da linguagem.<!-- /herdado -->

<!-- herdado:engineering/pisos-22-29:bloco -->**Herda os pisos 22–29 da `schematize-engineering`** (texto completo em `assets/CLAUDE.md` dela): 22 tudo no git — sem remote, push falho ou HEAD≠origin a demanda NÃO se conclui; 23 deploy só do git (VETADO scp/rsync/tar|ssh/docker save|load/git bundle); 24 o ops é o gate da IA — a IA nunca muda a VPS direto nem escreve SQL, só operação nomeada (`ssh vps "ops <op>"`); 25 sem agents inúteis (entregou, morreu); 26 relatório a cada 30 min e handoff a cada 6 h; 27 CI remoto só antes do hml, a pedido ou em tag (`workflow_dispatch` + `hml-*`/`v*`; VETADO `pull_request`, `push` em branch, `workflow_run`, cron sem justificativa); 28 microserviço autônomo (fila durável + 7 testes de resiliência); 29 build/teste na máquina dev/hml quando existe (ponte só no workspace de build, nunca prd) + higiene (`scripts/higiene.sh`).<!-- /herdado -->

## Por que ela nasceu

A `schematize-mobile` promete escolha *"nativo vs cross por fit + ADR"* — e não havia **skill por
trás de nenhuma das opções**: promessa publicada e não sustentada (vistoria de 2026-08-21). Esta
skill é uma das quatro peças que fecham isso, junto com `schematize-kotlin`, `schematize-dart` e o
conserto da própria `schematize-mobile`.

## Comandos (Claude Code)

| Comando | O que faz |
|---|---|
| `/swift-help` | lista os comandos |
| `/swift-load` | carrega à força o corpo normativo (piso, plataforma) |
| `/swift-review` | revisa `.swift` contra o piso: roda o gate e lê o que a máquina não lê |
| `/swift-claude` | cria/mescla o `CLAUDE.md` sempre-on na raiz do repo |
| `/swift-cc` · `/swift-handoff` | context compact / handoff arquivado |

## Como usar

1. **O que é de app é da `schematize-mobile`** — comece por lá se a pergunta é offline, IAM, push,
   loja ou teste no device.
2. **Rode o gate:** `bash scripts/check-swift.sh .` — `0` passa · `1` reprova · `2` **nada para
   verificar** (que não é aprovação). Ele é **textual**: onde houver compilador e SwiftLint, **são
   eles que mandam**.
3. **Piso de linguagem** em `references/piso.md`; **toolchain e distribuição** em
   `references/plataforma.md`.

Mapa de references:

| Tarefa | Reference |
|---|---|
| Opcional, concorrência estruturada (Swift 6 mode, `@MainActor`, `Sendable`, cancelamento, reentrância do actor), ARC e ciclo de retenção, erro tipado, segurança do cliente, teste | `references/piso.md` |
| SwiftPM e `Package.resolved`, build no CI com simulador fixado, assinatura em cofre, `@available`, Swift fora do iOS, interop Obj-C/C | `references/plataforma.md` |
| Versões e ferramental, com data de verificação **e a ressalva de que a toolchain não roda na máquina de referência** | `references/stack-versoes.md` |

Assets prontos para copiar: `assets/ci/github-actions-ci.yml` (swift-format lint, swift test com strict concurrency) · `assets/lint/.swift-format`.

## Pisos inegociáveis (vetam o atalho)

1. **Force-unwrap é `fatalError` adiado.** `try!`/`as!` são VETADOS em produção; `!` só com
   invariante real — e aí `precondition` com mensagem diz o que quebrou, o `!` não diz nada.
2. **Concorrência estruturada:** `async/await`; **`DispatchSemaphore` para esperar async é VETADO**
   (deadlock na main thread esperando acontecer).
3. **Strict concurrency (Swift 6 mode) ligado** no código novo — é o que transforma data race em
   erro de compilação em vez de crash intermitente.
4. **`@MainActor` só no que toca UI.** Marcar o mundo de `@MainActor` para calar o compilador é
   serializar o app.
5. **Cancelamento é cooperativo:** operação longa checa `Task.isCancelled`, senão continua rodando
   depois que a tela sumiu.
6. **Ciclo de retenção é vazamento:** `[weak self]` no que sobrevive à tela; delegate é `weak`;
   `unowned` só quando o dono é garantidamente mais longevo — se não for, é **crash**, não `nil`.
7. **Erro é valor tipado.** `catch { }` vazio é VETADO; `fatalError` só em invariante de
   programação, nunca em erro de I/O, rede ou dado do usuário.
8. **Segredo nunca no bundle** (tudo no `.ipa` é legível com `strings`); credencial no **Keychain**,
   nunca `UserDefaults`; `NSAllowsArbitraryLoads` VETADO.
9. **`Package.resolved` commitado** e toolchain declarada — sem lockfile, duas máquinas resolvem
   versões diferentes.
10. **Warnings são erros no CI.** Em Swift, warning é quase sempre defeito real.
11. <!-- herdado:engineering/orquestracao:curto -->**Orquestrador não desenvolve; subagent barato executa.** O agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para o executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código; falhou → mesmo subagent corrige, até 2 rodadas) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo) → `park`; **visual vai direto ao Codex**; **imagem nunca pelo Claude: detectar Codex/Gemini e perguntar ao usuário qual usar (Codex é a sugestão), nunca API de imagem paga**; papéis em `agentes.toml`. No overdev, cada item do checklist vai a um subagent e o principal revisa antes do `- [x]`. **Sem frota ociosa:** idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata (§9.6). Detalhe: `schematize-engineering` → `references/orquestracao.md` §9.<!-- /herdado -->

## Relação com as outras skills

- **`schematize-mobile`** — o piso de **app**. Onde as duas falarem do mesmo assunto, **a mobile
  manda** no que é de produto/plataforma; aqui manda o que é de linguagem.
- **`schematize-engineering`** — a base e o rol. **Server-side Swift não é backend do rol**: entra
  só por ADR de exceção.
- **`schematize-qa`** — a disciplina de teste; aqui só muda o runner (`swift-testing`/XCTest).
- **`schematize-pentest`** — o lado ofensivo (segredo no bundle, pinning, deep link hostil).
