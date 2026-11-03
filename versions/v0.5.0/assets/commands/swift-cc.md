---
description: schematize-swift — context compact: grava o handoff no archive e roda /compact.
---
Antes de compactar, grave o handoff em `<projeto>/<projeto>_archive/context/`, no par
context + checklist do padrão da `schematize-archive` (prefixo `AAAA-MM-DD-<slug>-`): o que foi
escrito/revisado, o que o `check-swift.sh` acusou e ficou aberto, e as decisões de concorrência
(módulos migrados para Swift 6 mode, `@unchecked Sendable` com invariante). Só então rode `/compact`.
