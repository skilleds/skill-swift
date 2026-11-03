# Piso de Swift (schematize-swift) — sempre-on

> No que é de **app** (offline, IAM, push, loja, teste no device), quem manda é a
> **`schematize-mobile`**. Aqui é o que é de **linguagem**.

1. **Force-unwrap é `fatalError` adiado.** `try!`/`as!` VETADOS em produção; `!` só com invariante
   real — e aí use `precondition` com mensagem. Prefira `guard let`, `??`, `throws`.
2. **`async/await`**; **`DispatchSemaphore` para esperar async é VETADO** (deadlock na main thread).
3. **Strict concurrency (Swift 6) ligado** no código novo; `@MainActor` **só** no que toca UI;
   `Sendable` é contrato — `@unchecked` exige comentário com a invariante.
4. **Cancelamento é cooperativo:** operação longa checa `Task.isCancelled`.
5. **`actor` tem reentrância:** releia a invariante depois de cada `await`.
6. **`[weak self]`** no que sobrevive à tela; delegate `weak`; `unowned` errado é **crash**.
7. **Erro tipado** (`enum: Error`); `catch { }` vazio é VETADO; `fatalError` só em invariante de
   programação.
8. **Segredo nunca no bundle** (`strings` no `.ipa` lê tudo); credencial no **Keychain**;
   `NSAllowsArbitraryLoads` VETADO.
9. **`Package.resolved` commitado**; toolchain e SDK declarados; **warnings são erros** no CI.
10. **Teste:** `swift-testing` no novo; unidade **sem device**; `XCTAssertNoThrow` sem asserção de
    valor não testa nada.
11. <!-- herdado:engineering/orquestracao:curto -->**Orquestrador não desenvolve; subagent barato executa.** O agent principal só planeja, despacha e revisa; ação onerosa vira micro-tasks para o executor mais barato que resolve: `haiku` (mecânico) / `sonnet` (código; falhou → mesmo subagent corrige, até 2 rodadas) → Codex `gpt-5.6-terra` → Cursor → subagent `opus` (motivo) → `park`; **visual vai direto ao Codex**; **imagem nunca pelo Claude: detectar Codex/Gemini e perguntar ao usuário qual usar (Codex é a sugestão), nunca API de imagem paga**; papéis em `agentes.toml`. No overdev, cada item do checklist vai a um subagent e o principal revisa antes do `- [x]`. **Sem frota ociosa:** idle com pendência volta ao trabalho; dependente de outro agent → mata e enfileira com gatilho; terminou → mata (§9.6). Detalhe: `schematize-engineering` → `references/orquestracao.md` §9.<!-- /herdado -->

Gate: `bash .claude/skills/schematize-swift/scripts/check-swift.sh .`

<!-- herdado:engineering/pisos-22-29:bloco -->**Herda os pisos 22–29 da `schematize-engineering`** (texto completo em `assets/CLAUDE.md` dela): 22 tudo no git — sem remote, push falho ou HEAD≠origin a demanda NÃO se conclui; 23 deploy só do git (VETADO scp/rsync/tar|ssh/docker save|load/git bundle); 24 o ops é o gate da IA — a IA nunca muda a VPS direto nem escreve SQL, só operação nomeada (`ssh vps "ops <op>"`); 25 sem agents inúteis (entregou, morreu); 26 relatório a cada 30 min e handoff a cada 6 h; 27 CI remoto só antes do hml, a pedido ou em tag (`workflow_dispatch` + `hml-*`/`v*`; VETADO `pull_request`, `push` em branch, `workflow_run`, cron sem justificativa); 28 microserviço autônomo (fila durável + 7 testes de resiliência); 29 build/teste na máquina dev/hml quando existe (ponte só no workspace de build, nunca prd) + higiene (`scripts/higiene.sh`).<!-- /herdado -->
