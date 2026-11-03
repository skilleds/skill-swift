# Plataforma Apple — build, dependência, distribuição

> Parte da skill **schematize-swift**. O que é de **app** (offline-first, IAM, push, lojas, testes
> no device) é da **`schematize-mobile`**; aqui fica o que é da **toolchain e do ecossistema**.

---

## 1. O projeto é reprodutível ou não é projeto

- **MUST: Swift Package Manager** como gerenciador. `Package.resolved` **commitado** — ele é o
  lockfile, e sem ele duas máquinas resolvem versões diferentes da mesma faixa.
- **VETADO** dependência por arrastar arquivo para o projeto, e **VETADO** commitar binário de
  terceiro sem origem, licença e versão registradas (`schematize-engineering`, cadeia de
  suprimentos).
- **Versão de Swift e de SDK declaradas** (`swift-tools-version`, `.xcode-version` ou equivalente no
  CI). "Compila na minha máquina" quase sempre é versão de toolchain diferente.
- **Warnings são erros** no CI (`-warnings-as-errors`). Em Swift, warning é quase sempre um defeito
  real (variável não usada que devia ter sido, `@available` esquecido, captura implícita).

## 2. Build no CI, não na máquina de alguém

- **MUST:** build e teste (`xcodebuild test` / `swift test`) no gate LOCAL a cada commit; o CI remoto
  (macOS é caro) roda só antes de promover a hml, em release/tag ou sob demanda (piso 27), com o **simulador
  fixado** (nome e versão) — simulador flutuante é flaky garantido.
- **Assinatura em cofre**, nunca no repo: certificado e provisioning profile entram por variável
  segura no runner (piso da `schematize-mobile → references/entrega-lojas.md`; dependência: instale a `schematize-mobile`).
- **Artefato imutável com proveniência**: o `.ipa`/`.app` que foi testado é o que sobe, com o commit
  SHA registrado.

## 3. Compatibilidade — o que trava e o que não

- **Alvo de deployment é decisão de produto**, escrita: sustentar iOS antigo custa em API e em
  teste. A janela da casa e os números correntes ficam no anexo volátil (`stack-versoes.md`).
- **`@available` e `if #available`** onde a API é nova — e o caminho alternativo **existe e é
  testado**, senão o `if` é decorativo.
- **Não confie no simulador para o que é físico:** térmica, bateria, rede móvel, câmera, biometria
  e armazenamento cheio só aparecem no aparelho (`schematize-mobile`).

## 4. Swift fora do iOS

- **Server-side Swift (Vapor/Hummingbird) NÃO é backend do rol** desta casa: serviço novo nasce no
  rol sancionado (`schematize-engineering` → `references/linguagens.md`), e Swift entra ali só por
  **ADR de exceção**. Esta skill existe para o **cliente Apple**.
- **Swift para CLI de apoio** é aceitável quando o time já é de iOS e o alvo é a máquina do time —
  ainda cumprindo o piso da `schematize-shell` no que for script de orquestração.

## 5. Interoperabilidade

- **Objective-C**: fronteira explícita (`@objc` só onde precisa), e o que vem de lá é **opcional
  implícito mentiroso** — trate como `Optional` de verdade na borda.
- **C/C++ via módulo**: o Swift **não protege o que acontece dentro do C** — do outro lado da
  fronteira valem as regras de segurança de memória de quem escreveu aquele código (e a `schematize-c` / `schematize-cpp`
  mandam ali). Trate o retorno como não confiável: ponteiro,
  tamanho e tempo de vida são contrato que o compilador do Swift não verifica.

## 6. Plataforma Apple: o que o gate textual não vê

- **`PrivacyInfo.xcprivacy`** declarado no app e em cada SDK de terceiros; APIs "required reason" (`UserDefaults`, timestamps de arquivo, etc.) só com motivo declarado. Detalhe de loja: `schematize-mobile` -> `references/entrega-lojas.md`.
- **Supply chain do SwiftPM:** dependência fixada por versão exata ou revisão (`Package.resolved` commitado); plugins de build do SwiftPM **executam código** na sua máquina — revise antes de aceitar.
