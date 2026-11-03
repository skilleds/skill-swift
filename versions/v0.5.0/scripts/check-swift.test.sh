#!/usr/bin/env bash
# Vermelho primeiro do gate de Swift. Cada fixture tem UM defeito.
#
# strict-ok: harness de teste — continua depois de um caso vermelho para reportar todos
# (`schematize-shell` -> `references/piso.md` secao 1)
set -u
AQUI="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
G="$AQUI/check-swift.sh"
TMP="$(mktemp -d)"; trap 'rm -rf "$TMP"' EXIT INT TERM
ok=0; fail=0
caso() {
  local nome="$1" esp="$2" agulha="$3" arq="${4:-Alvo.swift}"
  local d="$TMP/$nome"; mkdir -p "$d/$(dirname "$arq")"; cat > "$d/$arq"
  local saida; saida="$(bash "$G" "$d" 2>&1)"; local rc=$?
  if [ "$rc" != "$esp" ]; then echo "  ✖ $nome: exit $rc, esperado $esp"; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  if [ -n "$agulha" ] && ! grep -qF -- "$agulha" <<<"$saida"; then echo "  ✖ $nome: exit certo, saída sem \"$agulha\""; sed 's/^/      /' <<<"$saida"; fail=$((fail+1)); return; fi
  echo "  ✔ $nome"; ok=$((ok+1))
}

echo "== verde de partida =="
caso verde 0 "regras textuais do piso" <<'FIX'
import Foundation

enum ErroDePedido: Error { case naoEncontrado, semPermissao }

actor Pedidos {
    private var itens: [String: Int] = [:]

    func total(de id: String) throws -> Int {
        guard let valor = itens[id] else { throw ErroDePedido.naoEncontrado }
        return valor
    }
}

final class Sincronizador {
    private weak var delegate: AnyObject?

    func sincronizar() async throws {
        try Task.checkCancellation()
    }
}
FIX

echo "== opcional e cast =="
caso try-bang 1 "VETADO em produção" <<'FIX'
import Foundation
func carregar(_ url: URL) -> Data {
    return try! Data(contentsOf: url)
}
FIX
caso as-bang 1 "cast forçado" <<'FIX'
import Foundation
func converter(_ qualquer: Any) -> String {
    return qualquer as! String
}
FIX

caso force-unwrap 1 "force-unwrap" <<'FIX'
import Foundation
func primeiro(_ itens: [String]) -> String {
    return itens.first!
}
FIX

echo "== erro engolido =="
caso catch-vazio 1 "erro engolido" <<'FIX'
import Foundation
func salvar() {
    do { try gravar() } catch { }
}
FIX

echo "== concorrência =="
caso semaforo 1 "deadlock na main thread" <<'FIX'
import Foundation
func esperar() {
    let sem = DispatchSemaphore(value: 0)
    Task { sem.signal() }
    sem.wait()
}
FIX

echo "== segurança do cliente =="
caso credencial-userdefaults 1 "plist EM CLARO" <<'FIX'
import Foundation
func guardar(token: String) {
    UserDefaults.standard.set(token, forKey: "token")
}
FIX
caso tls-relaxado 1 "TLS relaxado" <<'FIX'
import Foundation
let config = ["NSAppTransportSecurity": ["NSAllowsArbitraryLoads": true]]
FIX

echo "== teste pode usar force-unwrap =="
caso force-unwrap-em-teste 0 "" "PedidoTests.swift" <<'FIX'
import XCTest

final class PedidoTests: XCTestCase {
    func testAlgo() throws {
        let url = URL(string: "https://exemplo.test")!
        XCTAssertNotNil(url)
    }
}
FIX

echo "== waiver por linha, teste por caminho, print, fatalError =="
caso waiver-na-linha 0 "" <<'FIX'
import Foundation
func primeiro(_ itens: [String]) -> String {
    return itens.first! // swift-ok: lista validada na entrada, nunca vazia
}
FIX
caso waiver-nao-vale-pro-arquivo 1 "force-unwrap" <<'FIX'
import Foundation
func a(_ i: [String]) -> String { return i.first! // swift-ok: invariante
}
func b(_ i: [String]) -> String { return i.last! }
FIX
caso iuo-de-outlet 0 "" <<'FIX'
import UIKit
final class Tela: UIViewController {
    @IBOutlet var titulo: UILabel!
}
FIX
caso nome-com-Test-nao-e-teste 1 "VETADO em produção" "TestFlightUploader.swift" <<'FIX'
import Foundation
func carregar(_ url: URL) -> Data { return try! Data(contentsOf: url) }
FIX
caso diretorio-TestFlight-nao-e-teste 1 "cast forçado" "TestFlight/Feed.swift" <<'FIX'
import Foundation
func f(_ x: Any) -> String { return x as! String }
FIX
caso print-em-producao 1 "print" <<'FIX'
import Foundation
func logar(_ m: String) { print(m) }
FIX
caso print-em-teste 0 "" "LogTests.swift" <<'FIX'
import XCTest
final class LogTests: XCTestCase { func testA() { print("ok") } }
FIX
caso fatalError-avisa 0 "fatalError" <<'FIX'
import Foundation
func ler(_ url: URL) -> Data {
    do { return try Data(contentsOf: url) } catch { fatalError("falhou") }
}
FIX
caso unchecked-comentario-longe 0 "@unchecked Sendable" <<'FIX'
// nota sobre @unchecked lá no topo, longe do uso
import Foundation

final class Cache {}
final class Caixa: @unchecked Sendable { var v = 0 }
FIX
caso unchecked-comentado 0 "" <<'FIX'
import Foundation
// protegido por lock interno
final class Caixa: @unchecked Sendable { var v = 0 }
FIX

echo "== nada para verificar =="
d="$TMP/vazio"; mkdir -p "$d"; echo "# prosa" > "$d/LEIA.md"
saida="$(bash "$G" "$d" 2>&1)"; rc=$?
if [ "$rc" = 2 ] && grep -q "não é aprovação" <<<"$saida"; then echo "  ✔ repo sem .swift sai 2 (não 0)"; ok=$((ok+1))
else echo "  ✖ repo sem .swift: exit $rc"; fail=$((fail+1)); fi

echo; echo "check-swift: $ok ok, $fail falha(s)"; [ "$fail" = 0 ]
