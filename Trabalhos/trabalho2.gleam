// Alunos: Guilherme José Monteiro Meirelles (RA 133994) e Guilherme Grecco Bononi (RA 134754)
import gleam/int
import gleam/list
import gleam/order
import gleam/result
import gleam/string
import sgleam/check

// Análise

// A partir de uma lista de resultados de partidas de futebol, montar uma tabela com a classificação dos times presentes nas partidas.
// A classificação dos times está relacionada com o desempenho de cada time nos jogos em ordem decrescente.
// Haverá tratamento de erro caso a lista de resultados possua elementos inválidos para a obtenção do resultados das partidas

// Tipos de Dados

// Inicialmente o programa receberá uma lista de string com os resultados da partida, em seguida a transformará em uma lista
// de estruturas com os resultados das partidas, depois transformará em uma lista de estruturas com o desempenho de cada time
// e no final devolverá uma lista de strings com o desempenho de cada time.

pub type Partida {

  // Estrutura que representa o resultado de uma partida de futebol
  // A estrutura contém o nome do time anfitrião, a quantidade de gols do time anfitrião, o nome do time visitante e a quantidade de gols do time visitante
  Partida(anfitriao: String, gols_anfi: Int, visitante: String, gols_visi: Int)
}

pub type Desempenho {

  // Estrutura que representa o desempenho de um time dada uma sequência de jogos que o time participou
  // A estrutura contém o nome do time, a quantidade de pontos, o número de vitórias  e o valor do saldo de gols.
  Desempenho(time: String, pontos: Int, vitorias: Int, saldo: Int)
}

pub fn jogo(partida: String) -> Result(Partida, Nil) {
  // Tranformar uma string que representa o resultado de uma partida de futebol na estrutura *Partida* que representa o resultado de uma partida de futebol.
  // Caso após a repartição da string em uma lista, a lista tenha menos ou mais de 4 elementos, e também caso 
  // as strings que representam os gols marcados não puderem ser convertidas para inteiros não negativos.
  // A função devolverá *Error(Nil)*, senão ela devolverá *Ok(Partida(anfitriao, a, visitante, b))*

  case string.split(partida, " ") {
    [anfitriao, golsanfi, visitante, golsvisi] -> {
      // Tenta fazer o parse
      use a <- result.try(int.parse(golsanfi))
      use b <- result.try(int.parse(golsvisi))

      // Verifica se ambos são >= 0 usando case
      case a >= 0, b >= 0 {
        True, True -> Ok(Partida(anfitriao, a, visitante, b))
        _, _ -> Error(Nil)
      }
    }
    _ -> Error(Nil)
  }
}

pub fn jogo_examples() {
  check.eq(
    jogo("Cruzeiro 3 Atletico-MG 3"),
    Ok(Partida("Cruzeiro", 3, "Atletico-MG", 3)),
  )
  check.eq(
    jogo("Palmeiras 2 Corinthians 1"),
    Ok(Partida("Palmeiras", 2, "Corinthians", 1)),
  )
  check.eq(jogo("A 0 B 0"), Ok(Partida("A", 0, "B", 0)))
  check.eq(jogo("Palmeiras 2 Cruzeiro 3 Corinthians 1"), Error(Nil))
  check.eq(jogo("Palmeiras 2 Cruzeiro Corinthians 1"), Error(Nil))
  check.eq(jogo("Palmeiras -2 Corinthians -1"), Error(Nil))
  check.eq(jogo("Palmeiras a Corinthians b"), Error(Nil))
  check.eq(jogo("Palmeiras2 Corinthians 1"), Error(Nil))
  check.eq(jogo("Palmeiras2Corinthians 1"), Error(Nil))
  check.eq(jogo("Palmeiras2Corinthians1"), Error(Nil))
  check.eq(jogo(""), Error(Nil))
}

pub fn lista_partidas(partidas: List(String)) -> List(Partida) {
  // Tranformar uma lista de string que representa resultados de partidas de futebol
  // em uma lista de estrutura *Partida* que representa resultado de partidas de futebol.
  // Utilizará a função auxiliar *jogo* para transformar as strings em estruturas.
  // Caso na conversão da string para estrutura dê como resultado Error(Nil), ela não será 
  // adicionada na lista final

  list.map(partidas, jogo)
  |> list.filter(result.is_ok)
  |> result.all()
  |> result.unwrap([])
}

pub fn lista_partidas_examples() {
  check.eq(
    lista_partidas([
      "Palmeiras 2 Corinthians 1", "Cruzeiro 3 Atletico-MG 3",
      "Botafogo 2 Flamengo 0", "Bahia 4 Vitoria 0",
    ]),
    [
      Partida("Palmeiras", 2, "Corinthians", 1),
      Partida("Cruzeiro", 3, "Atletico-MG", 3),
      Partida("Botafogo", 2, "Flamengo", 0),
      Partida("Bahia", 4, "Vitoria", 0),
    ],
  )
  check.eq(
    lista_partidas([
      "Santos -2 Corinthians 1", "Cruzeiro 3 Atletico-MG 3", "Coritiba 2",
      "Gremio 5 Internacional 0", "Vitoria a Vasco 0",
    ]),
    [
      Partida("Cruzeiro", 3, "Atletico-MG", 3),
      Partida("Gremio", 5, "Internacional", 0),
    ],
  )
  check.eq(lista_partidas([]), [])
}

pub fn desempenho(time: String) -> Desempenho {
  // Cria-se uma estrutura *Desempenho*, o qual o atributo *time* da estrutura é igual o parâmetro *time*
  Desempenho(time, 0, 0, 0)
}

pub fn desempenho_examples() {
  check.eq(desempenho("Palmeiras"), Desempenho("Palmeiras", 0, 0, 0))
  check.eq(desempenho("Santos"), Desempenho("Santos", 0, 0, 0))
  check.eq(desempenho("A"), Desempenho("A", 0, 0, 0))
}

pub fn encontra_time_partidas(time: String, jogos: List(Partida)) -> Bool {
  // Descobre se o time *time* está presente em alguma estrutura *Partida* da lista *jogos*
  list.any(jogos, fn(x) { x.anfitriao == time || x.visitante == time })
}

pub fn encontra_time_partidas_examples() {
  check.eq(
    encontra_time_partidas("Vasco", [
      Partida("Vasco", 2, "Internacional", 1),
      Partida("Internacional", 3, "Londrina", 3),
      Partida("Porto", 1, "Lisboa", 2),
    ]),
    True,
  )
  check.eq(
    encontra_time_partidas("Maringa-FC", [
      Partida("Palmeiras", 2, "Corinthians", 1),
      Partida("Cruzeiro", 3, "Atletico-MG", 3),
      Partida("Penapolense", 4, "Palmeiras", 2),
      Partida("Botafogo", 2, "Flamengo", 0),
      Partida("Palmeiras", 3, "Corinthians", 4),
      Partida("Sport", 2, "Cruzeiro", 3),
      Partida("Bahia", 4, "Vitoria", 0),
    ]),
    False,
  )
  check.eq(encontra_time_partidas("Palmeiras", []), False)
}

fn ja_no_desempenho(time: String, desempenhos: List(Desempenho)) -> Bool {
  // Função auxiliar para descobrir se alguma estrutura em *desempenhos* tem o atributo *time* igual
  // ao parâmetro *time*
  list.any(desempenhos, fn(d) { d.time == time })
}

pub fn ja_no_desempenho_examples() {
  check.eq(
    ja_no_desempenho("Palmeiras", [
      Desempenho("Palmeiras", 5, 1, 2),
      Desempenho("Corinthians", 7, 2, 1),
    ]),
    True,
  )
  check.eq(
    ja_no_desempenho("Botafogo", [
      Desempenho("Palmeiras", 5, 1, 2),
      Desempenho("Corinthians", 7, 2, 1),
      Desempenho("Barcelona", 10, 3, 4),
    ]),
    False,
  )
  check.eq(ja_no_desempenho("Cruzeiro", []), False)
  check.eq(
    ja_no_desempenho("RealMadrid", [Desempenho("RealMadrid", 3, 1, 1)]),
    True,
  )
}

pub fn tabela(jogos: List(Partida)) -> List(Desempenho) {
  // Cria-se uma lista de estruturas *Desempenho* com a os times presentes na lista de estrutura *Partidas* (times anfitriões e visitantes)
  // Não há repetição de times na lista de saída
  // Utiliza-se as funções auxiliares desempenho e encontra_time_partidas

  list.fold_right(jogos, [], fn(acc, jogo) {
    case
      ja_no_desempenho(jogo.anfitriao, acc),
      ja_no_desempenho(jogo.visitante, acc)
    {
      True, True -> acc
      False, True -> [desempenho(jogo.anfitriao), ..acc]
      True, False -> [desempenho(jogo.visitante), ..acc]
      False, False -> [
        desempenho(jogo.anfitriao),
        desempenho(jogo.visitante),
        ..acc
      ]
    }
  })
}

pub fn tabela_examples() {
  check.eq(
    tabela([
      Partida("Vasco", 2, "Internacional", 1),
      Partida("Internacional", 3, "Londrina", 3),
      Partida("Porto", 1, "Lisboa", 2),
    ]),
    [
      Desempenho(time: "Vasco", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Internacional", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Londrina", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Porto", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Lisboa", pontos: 0, vitorias: 0, saldo: 0),
    ],
  )
  check.eq(
    tabela([
      Partida("Palmeiras", 2, "Corinthians", 1),
      Partida("Cruzeiro", 3, "Atletico-MG", 3),
      Partida("Penapolense", 4, "Palmeiras", 2),
      Partida("Botafogo", 2, "Flamengo", 0),
      Partida("Palmeiras", 3, "Corinthians", 4),
      Partida("Sport", 2, "Cruzeiro", 3),
      Partida("Bahia", 4, "Vitoria", 0),
    ]),
    [
      Desempenho(time: "Atletico-MG", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Penapolense", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Botafogo", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Flamengo", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Palmeiras", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Corinthians", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Sport", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Cruzeiro", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Bahia", pontos: 0, vitorias: 0, saldo: 0),
      Desempenho(time: "Vitoria", pontos: 0, vitorias: 0, saldo: 0),
    ],
  )
  check.eq(tabela([]), [])
}

pub fn atualiza_desempenho(jogo: Partida, time: Desempenho) -> Desempenho {
  // Atualiza o desempenho de um time *time* a partir do resultado de uma partida *jogo*
  // Caso o time *time* seja o anfitrião ou visitante de *jogo*, atualiza-se o desempenho do time
  // respectivamente de acordo com o resultado da partida
  case time.time == jogo.anfitriao, time.time == jogo.visitante {
    True, False ->
      case jogo.gols_anfi > jogo.gols_visi, jogo.gols_anfi < jogo.gols_visi {
        True, _ ->
          Desempenho(
            time.time,
            time.pontos + 3,
            time.vitorias + 1,
            time.saldo + jogo.gols_anfi - jogo.gols_visi,
          )

        _, True ->
          Desempenho(
            time.time,
            time.pontos,
            time.vitorias,
            time.saldo + jogo.gols_anfi - jogo.gols_visi,
          )

        _, _ ->
          Desempenho(time.time, time.pontos + 1, time.vitorias, time.saldo)
      }
    False, True ->
      case jogo.gols_anfi > jogo.gols_visi, jogo.gols_anfi < jogo.gols_visi {
        _, True ->
          Desempenho(
            time.time,
            time.pontos + 3,
            time.vitorias + 1,
            time.saldo + jogo.gols_visi - jogo.gols_anfi,
          )

        True, _ ->
          Desempenho(
            time.time,
            time.pontos,
            time.vitorias,
            time.saldo + jogo.gols_visi - jogo.gols_anfi,
          )

        _, _ ->
          Desempenho(time.time, time.pontos + 1, time.vitorias, time.saldo)
      }
    _, _ -> Desempenho(time.time, time.pontos, time.vitorias, time.saldo)
  }
}

pub fn atualiza_desempenho_examples() {
  check.eq(
    atualiza_desempenho(
      Partida("Gremio", 3, "Internacional", 2),
      Desempenho("Gremio", 5, 1, 2),
    ),
    Desempenho("Gremio", 8, 2, 3),
  )

  check.eq(
    atualiza_desempenho(
      Partida("Palmeiras", 0, "Corinthians", 2),
      Desempenho("Corinthians", 10, 3, 4),
    ),
    Desempenho("Corinthians", 13, 4, 6),
  )

  check.eq(
    atualiza_desempenho(
      Partida("Bahia", 1, "Vitoria", 1),
      Desempenho("Bahia", 4, 1, 2),
    ),
    Desempenho("Bahia", 5, 1, 2),
  )

  check.eq(
    atualiza_desempenho(
      Partida("Cruzeiro", 2, "Atletico-MG", 2),
      Desempenho("Atletico-MG", 1, 0, 0),
    ),
    Desempenho("Atletico-MG", 2, 0, 0),
  )
}

pub fn atualiza_tabela(
  jogo: Partida,
  tabela: List(Desempenho),
) -> List(Desempenho) {
  // Ao analisar o resultado da estrutura *jogo*, atualizar em *tabela* (lista de estruturas desempenho) o desempenho do time anfitrião e visitantes presentes em *jogo*
  // Caso o time anfitrião de *jogo* não esteja em *tabela*, *tabela* não será atualizado
  // Utiliza a função auxiliar *atualiza_desempenho*
  list.fold_right(tabela, [], fn(acc, time) {
    [atualiza_desempenho(jogo, time), ..acc]
  })
}

pub fn atualiza_tabela_examples() {
  check.eq(
    atualiza_tabela(Partida("Palmeiras", 4, "Corinthians", 2), [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Corinthians", 10, 3, 6),
      Desempenho("Sao Paulo", 2, 0, -2),
    ]),
    [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 8, 2, 2),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Sao Paulo", 2, 0, -2),
    ],
  )
  check.eq(
    atualiza_tabela(Partida("Internacional", 2, "Santos", 2), [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sao Paulo", 2, 0, -2),
    ]),
    [
      Desempenho("Internacional", 11, 3, 5),
      Desempenho("Santos", 10, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sao Paulo", 2, 0, -2),
    ],
  )
  check.eq(
    atualiza_tabela(Partida("Sao Paulo", 2, "Agua Santa", 4), [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sao Paulo", 2, 0, -2),
      Desempenho("Agua Santa", 8, 2, 4),
    ]),
    [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sao Paulo", 2, 0, -4),
      Desempenho("Agua Santa", 11, 3, 6),
    ],
  )
}

pub fn tabela_completa(
  partidas: List(Partida),
  tabela: List(Desempenho),
) -> List(Desempenho) {
  // A partir de uma lista de estruturas Partidas *partidas* e da lista de estruturas Desempenho *tabela*, atualiza-se os valores de desempenho dos times em *tabela* 
  // em relação aos resultados das partidas em *partidas*
  // Utiliza a função auxiliar *atualiza_tabela*

  list.fold_right(partidas, tabela, fn(acc, p) { atualiza_tabela(p, acc) })
}

pub fn tabela_completa_examples() {
  check.eq(
    tabela_completa(
      [
        Partida("Palmeiras", 4, "Corinthians", 2),
        Partida("Santos", 0, "Palmeiras", 0),
        Partida("Corinthians", 1, "Santos", 0),
        Partida("Palmeiras", 1, "Internacional", 4),
      ],
      [
        Desempenho("Palmeiras", 0, 0, 0),
        Desempenho("Corinthians", 0, 0, 0),
        Desempenho("Santos", 0, 0, 0),
        Desempenho("Internacional", 0, 0, 0),
      ],
    ),
    [
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ],
  )
  check.eq(
    tabela_completa(
      [
        Partida("Palmeiras", 2, "Corinthians", 1),
        Partida("Cruzeiro", 3, "Atletico-MG", 3),
        Partida("Penapolense", 4, "Palmeiras", 2),
        Partida("Botafogo", 2, "Flamengo", 0),
        Partida("Palmeiras", 3, "Corinthians", 4),
        Partida("Sport", 2, "Cruzeiro", 3),
        Partida("Bahia", 4, "Vitoria", 0),
      ],
      [
        Desempenho("Atletico-MG", 0, 0, 0),
        Desempenho("Penapolense", 0, 0, 0),
        Desempenho("Botafogo", 0, 0, 0),
        Desempenho("Flamengo", 0, 0, 0),
        Desempenho("Palmeiras", 0, 0, 0),
        Desempenho("Corinthians", 0, 0, 0),
        Desempenho("Sport", 0, 0, 0),
        Desempenho("Cruzeiro", 0, 0, 0),
        Desempenho("Bahia", 0, 0, 0),
        Desempenho("Vitoria", 0, 0, 0),
      ],
    ),
    [
      Desempenho("Atletico-MG", 1, 0, 0),
      Desempenho("Penapolense", 3, 1, 2),
      Desempenho("Botafogo", 3, 1, 2),
      Desempenho("Flamengo", 0, 0, -2),
      Desempenho("Palmeiras", 3, 1, -2),
      Desempenho("Corinthians", 3, 1, 0),
      Desempenho("Sport", 0, 0, -1),
      Desempenho("Cruzeiro", 4, 1, 1),
      Desempenho("Bahia", 3, 1, 4),
      Desempenho("Vitoria", 0, 0, -4),
    ],
  )
}

pub fn maior(time1: Desempenho, time2: Desempenho) -> Bool {
  // Encontra o time com melhor desempenho entre dois times
  // Se o time 1 tiver melhor desempenho, retorna-se True senão retorna-se False 

  case time1.pontos > time2.pontos, time1.pontos < time2.pontos {
    True, _ -> True
    _, True -> False
    _, _ -> {
      case time1.vitorias > time2.vitorias, time1.vitorias < time2.vitorias {
        True, _ -> True
        _, True -> False
        _, _ -> {
          case time1.saldo > time2.saldo, time1.saldo < time2.saldo {
            True, _ -> True
            _, True -> False
            _, _ ->
              case string.compare(time1.time, time2.time) {
                order.Lt -> True
                order.Eq -> False
                order.Gt -> False
              }
          }
        }
      }
    }
  }
}

pub fn maior_examples() {
  check.eq(
    maior(Desempenho("Botafogo", 5, 1, 0), Desempenho("Fluminense", 7, 2, 1)),
    False,
  )
  check.eq(
    maior(Desempenho("Botafogo", 7, 2, 0), Desempenho("Fluminense", 7, 1, 1)),
    True,
  )
  check.eq(
    maior(Desempenho("Botafogo", 5, 1, -1), Desempenho("Fluminense", 5, 1, 1)),
    False,
  )
  check.eq(
    maior(Desempenho("Botafogo", 5, 1, 0), Desempenho("Fluminense", 5, 1, 0)),
    True,
  )
}

//Não conseguimos importar a função list.fold_untill sem gerar erro, então copiamos sua função

pub type ContinueOrStop(a) {
  Continue(a)
  Stop(a)
}

pub fn fold_until(
  over list: List(a),
  from initial: acc,
  with fun: fn(acc, a) -> ContinueOrStop(acc),
) -> acc {
  case list {
    [] -> initial
    [first, ..rest] ->
      case fun(initial, first) {
        Continue(next_accumulator) -> fold_until(rest, next_accumulator, fun)
        Stop(b) -> b
      }
  }
}

pub fn insere_ordenado(
  time: Desempenho,
  tabela: List(Desempenho),
) -> List(Desempenho) {
  // Insere de forma ordenada o desempenho de um time em uma lista de desempenho times já ordenada
  // Utiliza a função auxiliar maior

  let a =
    fold_until(tabela, [], fn(acc, time2) {
      case maior(time, time2) {
        False -> Continue([time2, ..acc])
        True -> Stop(acc)
      }
    })
  let b = [time, ..a] |> list.reverse
  list.drop(tabela, list.length(b) - 1)
  |> list.append(b, _)
}

pub fn insere_ordenado_examples() {
  check.eq(
    insere_ordenado(Desempenho("Palmeiras", 5, 1, 1), [
      Desempenho("Corinthians", 7, 2, 1),
      Desempenho("Sao Paulo", 5, 1, 2),
      Desempenho("Vasco", 5, 1, 1),
      Desempenho("Flamengo", 5, 1, 0),
      Desempenho("Santos", 4, 1, -1),
    ]),
    [
      Desempenho("Corinthians", 7, 2, 1),
      Desempenho("Sao Paulo", 5, 1, 2),
      Desempenho("Palmeiras", 5, 1, 1),
      Desempenho("Vasco", 5, 1, 1),
      Desempenho("Flamengo", 5, 1, 0),
      Desempenho("Santos", 4, 1, -1),
    ],
  )
  check.eq(
    insere_ordenado(Desempenho("Gremio", 7, 2, 2), [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Palmeiras", 8, 2, 3),
      Desempenho("Flamengo", 5, 1, 1),
    ]),
    [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Palmeiras", 8, 2, 3),
      Desempenho("Gremio", 7, 2, 2),
      Desempenho("Flamengo", 5, 1, 1),
    ],
  )
  check.eq(
    insere_ordenado(Desempenho("Atletico-MG", 10, 3, 5), [
      Desempenho("Vasco", 9, 3, 4),
      Desempenho("Cruzeiro", 9, 3, 3),
      Desempenho("Botafogo", 8, 2, 2),
    ]),
    [
      Desempenho("Atletico-MG", 10, 3, 5),
      Desempenho("Vasco", 9, 3, 4),
      Desempenho("Cruzeiro", 9, 3, 3),
      Desempenho("Botafogo", 8, 2, 2),
    ],
  )
  check.eq(
    insere_ordenado(Desempenho("Sport", 5, 1, 2), [
      Desempenho("Bahia", 8, 2, 5),
      Desempenho("Nautico", 5, 1, 3),
      Desempenho("Ceara", 5, 1, 2),
      Desempenho("Fortaleza", 5, 1, 1),
    ]),
    [
      Desempenho("Bahia", 8, 2, 5),
      Desempenho("Nautico", 5, 1, 3),
      Desempenho("Ceara", 5, 1, 2),
      Desempenho("Sport", 5, 1, 2),
      Desempenho("Fortaleza", 5, 1, 1),
    ],
  )
}

pub fn classificacao_final(tabela: List(Desempenho)) -> List(Desempenho) {
  // Recebe uma tabela de times(lista de estruturas desempenhos de times) e a ordena em ordem decrescente de desempenho dos times
  // Utiliza as funções auxiliares *maior* e *insere_ordenado*

  list.fold(tabela, [], fn(acc, time) { insere_ordenado(time, acc) })
}

pub fn classificacao_final_examples() {
  check.eq(classificacao_final([Desempenho("Gremio", 10, 3, 0)]), [
    Desempenho("Gremio", 10, 3, 0),
  ])

  check.eq(
    classificacao_final([
      Desempenho("Fluminense", 5, 1, 2),
      Desempenho("Bota", 5, 1, 2),
      Desempenho("America-MG", 5, 1, 2),
    ]),
    [
      Desempenho("America-MG", 5, 1, 2),
      Desempenho("Bota", 5, 1, 2),
      Desempenho("Fluminense", 5, 1, 2),
    ],
  )
  check.eq(
    classificacao_final([
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ]),
    [
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Internacional", 3, 1, 3),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
    ],
  )

  check.eq(
    classificacao_final([
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sport", 9, 2, 3),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Coritiba", 10, 3, 4),
      Desempenho("Sao Paulo", 2, 0, -2),
    ]),
    [
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Coritiba", 10, 3, 4),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Sport", 9, 2, 3),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sao Paulo", 2, 0, -2),
    ],
  )
  check.eq(classificacao_final([]), [])
}

pub fn para_string(time: Desempenho) -> String {
  // Converte a estrutura desempenho para uma string, a qual os atributos da estrutura são separados por espaços
  string.join(
    [
      time.time,
      int.to_string(time.pontos),
      int.to_string(time.vitorias),
      int.to_string(time.saldo),
    ],
    " ",
  )
}

pub fn para_string_examples() {
  check.eq(para_string(Desempenho("Vitoria", 25, 5, -8)), "Vitoria 25 5 -8")

  check.eq(para_string(Desempenho("Criciuma", 34, 8, 10)), "Criciuma 34 8 10")
}

pub fn lista_para_string(tabela: List(Desempenho)) -> List(String) {
  // Converte a lista de estruturas desempenho para uma lista de string, a qual cada elemento representa o desempenho de um time
  // Usa a função auxiliar *para_string*
  list.map(tabela, para_string)
}

pub fn lista_para_string_examples() {
  check.eq(
    lista_para_string([
      Desempenho("Internacional", 10, 3, 5),
      Desempenho("Santos", 9, 3, 2),
      Desempenho("Palmeiras", 5, 1, 0),
      Desempenho("Sport", 9, 2, 3),
      Desempenho("Corinthians", 10, 3, 4),
      Desempenho("Coritiba", 10, 3, 4),
      Desempenho("Sao Paulo", 2, 0, -2),
    ]),
    [
      "Internacional 10 3 5", "Santos 9 3 2", "Palmeiras 5 1 0", "Sport 9 2 3",
      "Corinthians 10 3 4", "Coritiba 10 3 4", "Sao Paulo 2 0 -2",
    ],
  )
  check.eq(
    lista_para_string([
      Desempenho("Vasco", 11, 3, 4),
      Desempenho("Santos", 10, 3, 2),
      Desempenho("Gremio", 1, 1, -9),
      Desempenho("Botafogo", 9, 2, 3),
      Desempenho("Corinthians", 5, 1, 2),
      Desempenho("Goias", 18, 4, -1),
      Desempenho("Flamengo", 8, 1, 1),
    ]),
    [
      "Vasco 11 3 4", "Santos 10 3 2", "Gremio 1 1 -9", "Botafogo 9 2 3",
      "Corinthians 5 1 2", "Goias 18 4 -1", "Flamengo 8 1 1",
    ],
  )
}

pub fn resultado_final(jogos: List(String)) -> List(String) {
  // A partir de strings que representam partidas, cria-se uma lista de strings que representam a classificação de desempenho dos times que disputaram as partidas
  let partidas = lista_partidas(jogos)
  lista_para_string(
    classificacao_final(tabela_completa(
      partidas,
      tabela(partidas),
    )),
  )
}

pub fn resultado_final_examples() {
  check.eq(resultado_final(["Barcelona 3 RealMadrid 2"]), [
    "Barcelona 3 1 1", "RealMadrid 0 0 -1",
  ])

  check.eq(
    resultado_final(["Barcelona 3 RealMadrid 2", "Sevilla 2 Valencia 2"]),
    ["Barcelona 3 1 1", "Sevilla 1 0 0", "Valencia 1 0 0", "RealMadrid 0 0 -1"],
  )
  check.eq(
    resultado_final([
      "Palmeiras 2 Corinthians 1", "Cruzeiro 3 Atletico-MG 3",
      "Botafogo 2 Flamengo 0", "Bahia 4 Vitoria 0", "Palmeiras 1 Cruzeiro 2",
      "Atletico-MG 4 Botafogo 4", "Palmeiras 1 Bahia 0",
    ]),
    [
      "Palmeiras 6 2 1", "Botafogo 4 1 2", "Cruzeiro 4 1 1", "Bahia 3 1 3",
      "Atletico-MG 2 0 0", "Corinthians 0 0 -1", "Flamengo 0 0 -2",
      "Vitoria 0 0 -4",
    ],
  )
  check.eq(
    resultado_final([
      "Santos -2 Corinthians 1", "Cruzeiro 3 Atletico-MG 3", "Coritiba 2",
      "Gremio 5 Internacional 0", "Vitoria a Vasco 0", "Sao Paulo 2 Santos 3",
      " Coritiba 4 Vasco 3", "Gremio 1 Santos 1", "Atletico-MG 2 Coritiba 2",
    ]),
    [
      "Gremio 4 1 5", "Atletico-MG 2 0 0", "Coritiba 1 0 0", "Cruzeiro 1 0 0",
      "Santos 1 0 0", "Internacional 0 0 -5",
    ],
  )
}
