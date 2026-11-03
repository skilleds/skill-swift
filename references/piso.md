# O piso de Swift da casa

> Parte da skill **schematize-swift**. A base agnóstica (segurança, testes, DoD, archive, IAM) é da
> **`schematize-engineering`**; o piso de **app** (offline-first, IAM mobile, entrega nas lojas,
> push, testes no device) é da **`schematize-mobile`** — e ela manda no que é de app. Aqui fica o
> que é **da linguagem**.

Convenção: **MUST** = o gate cobra · **VETADO** = piso.

---

## 1. Opcional é o tipo, não uma sugestão

- **VETADO `!` de force-unwrap** em caminho de produção (`valor!`, `as!`, `try!`,
  `@IBOutlet var x: Tipo!` fora do ciclo de vida da view). Cada `!` é um `fatalError` que você
  escolheu adiar — e no app instalado ele é **crash na mão do usuário**, não exceção capturável.
- **MUST:** `guard let`/`if let`, `??` com default explícito, ou propagação com `throws`. Onde a
  invariante é real, **`precondition` com mensagem** diz o que quebrou; `!` não diz nada.
- **Waiver rastreável, por linha:** `// swift-ok: motivo` na MESMA linha libera aquele `!`/`print(`/`fatalError(` (o gate trata `!`, `try!`, `as!` e `print(` como ERRO; `fatalError` como aviso). Vale só para a linha; nunca para o arquivo. Teste (`*Tests/*`, `*Tests.swift`, `*Test.swift`) é isento.
- **`try?` engole o erro** — só onde a falha é aceitável **e** está comentada. `try!` é VETADO.
- **Optional chaining silencioso é bug esperando:** `objeto?.metodo()` que "não fez nada" porque o
  objeto era `nil` é o defeito mais difícil de achar, porque não deixa rastro. Onde importa, teste
  o `nil` explicitamente.

## 2. Concorrência estruturada — e o compilador do seu lado

- **MUST: `async/await` + `Task`**; **VETADO** `DispatchSemaphore` para "esperar async" (é deadlock
  na main thread esperando acontecer) e **VETADO** completion handler novo em código novo.
- **Ligue o `strict concurrency` / Swift 6 mode.** É o que transforma data race em **erro de
  compilação** em vez de crash intermitente. Migrar custa; descobrir a corrida em produção custa
  mais.
- **`@MainActor` no que toca UI**, e só nele. Marcar o mundo inteiro de `@MainActor` para calar o
  compilador é serializar o app — e ninguém percebe até a lista travar ao rolar.
- **`Sendable`** é contrato, não anotação decorativa: tipo compartilhado entre tasks é `struct`
  imutável, `actor`, ou tem sincronização própria. `@unchecked Sendable` exige **comentário
  explicando a invariante** que o compilador não vê.
- **Cancelamento é cooperativo:** toda operação longa checa `Task.isCancelled` (ou usa APIs que
  lançam `CancellationError`). Task que não checa nada **continua rodando** depois que a tela sumiu.
- **`actor` não é lock mágico:** reentrância existe — o estado pode mudar **durante** um `await`
  dentro do actor. Releia a invariante depois de cada `await`.

## 3. Memória — ARC não é GC

- **Ciclo de retenção é vazamento**, e a fonte nº 1 é a **closure que captura `self` forte**:
  `[weak self] guard let self else { return }` no que sobrevive à tela (rede, timer, observer).
- **`unowned` só quando o dono é garantidamente mais longevo** — se não for, é crash, não `nil`.
- **Delegate é `weak`**, sempre.
- **MUST:** rodar o **Leaks/Instruments** (ou `xcodebuild test` com o sanitizer) nos fluxos
  críticos antes do release; `deinit` com log em debug é a maneira barata de ver a tela que não
  morreu.

## 4. Erro é valor, e ele tem forma

- **`throws` + `Result` na fronteira**; erro de domínio é `enum: Error` **tipado**, não `NSError`
  genérico nem string.
- **VETADO** `catch { }` vazio e `catch { print(erro) }` como tratamento. Ou trata, ou propaga, ou
  registra **com contexto** (`schematize-engineering`: erro nunca engolido).
- **`fatalError` só em invariante de programação** (caso impossível), nunca em erro esperado de
  I/O, rede ou dado do usuário.

## 5. Tipos e API — o que a linguagem dá de graça

- **`struct` por default**, `class` quando precisa de identidade ou herança de framework.
- **`let` por default**; `var` é declaração de que aquilo muda.
- **`enum` com valor associado** para estado — é o que torna "estado impossível" **impossível de
  compilar**, em vez de um `if` a mais.
- **`Codable` na borda**, com `CodingKeys` explícito quando o JSON não é seu; e **decodificação que
  falha é erro tratado**, não `try!`.
- **API pública tem `///` de documentação** (`schematize-engineering` §6): o quê e por quê, não o
  como.

## 6. Segurança do lado do cliente

- **Nunca segredo no bundle** — `Info.plist`, constante, string ofuscada: tudo é legível com
  `strings` no `.ipa`. Piso da `schematize-mobile`.
- **Keychain para credencial**, nunca `UserDefaults` (que é um plist em claro). Defina `kSecAttrAccessible` explícito (`...AfterFirstUnlockThisDeviceOnly` para token de sessão em background; `...WhenUnlockedThisDeviceOnly` no resto).
- **`URLSession` com timeout explícito**; validação de certificado **nunca** relaxada
  (`NSAllowsArbitraryLoads` é VETADO fora de teste local documentado).
- **Log sem PII** e sem token; `print` não vai para produção (`os.Logger` com privacidade
  declarada — `.private` por default para dado de usuário).

## 7. Teste

A disciplina é da **`schematize-qa`**; aqui, o que muda: **`swift-testing`** (`@Test`, `#expect`)
para código novo, XCTest onde já existe; teste de unidade **sem device**, o resto na pirâmide da
`schematize-mobile` (`schematize-mobile → references/testes-mobile.md`; dependência: instale a `schematize-mobile`). **`XCTAssertNoThrow` não testa nada** se você
não asserta o valor — o verde que não reprova é o que a casa chama de verde mentiroso.
