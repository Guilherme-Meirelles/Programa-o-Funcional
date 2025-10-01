import gleam/int
import gleam/order
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
    [anfitriao, gols_anfi, visitante, gols_visi] ->
      case int.parse(gols_anfi), int.parse(gols_visi) {
        Ok(a), Ok(b) ->
          case a >= 0 && b >= 0 {
            True -> Ok(Partida(anfitriao, a, visitante, b))
            False -> Error(Nil)
          }
        _, _ -> Error(Nil)
      }
    [_, _, _, _, _, ..] -> Error(Nil)
    [_, _, _] -> Error(Nil)
    [_, _] -> Error(Nil)
    [_] -> Error(Nil)
    [] -> Error(Nil)
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

  case partidas {
    [primeiro, ..resto] ->
      case jogo(primeiro) {
        Ok(a) -> [a, ..lista_partidas(resto)]
        Error(_) -> lista_partidas(resto)
      }
    [] -> []
  }
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
  case jogos {
    [primeiro, ..resto] ->
      case primeiro.anfitriao == time || primeiro.visitante == time {
        True -> True
        False -> encontra_time_partidas(time, resto)
      }
    [] -> False
  }
}

pub fn tabela(jogos: List(Partida)) -> List(Desempenho) {
  // Cria-se uma lista de estruturas *Desempenho* com a os times presentes na lista de estrutura *Partidas* (times anfitriões e visitantes)
  // Não há repetição de times na lista de saída
  // Utiliza-se as funções auxiliares desempenho e encontra_time_partidas
  case jogos {
    [primeiro, ..resto] ->
      case
        encontra_time_partidas(primeiro.anfitriao, resto),
        encontra_time_partidas(primeiro.visitante, resto)
      {
        True, True -> tabela(resto)
        False, True -> [desempenho(primeiro.anfitriao), ..tabela(resto)]
        True, False -> [desempenho(primeiro.visitante), ..tabela(resto)]
        False, False -> [
          desempenho(primeiro.anfitriao),
          desempenho(primeiro.visitante),
          ..tabela(resto)
        ]
      }

    [] -> []
  }
}

pub fn tabela_examples() {
  check.eq(
    tabela([
      Partida("Vasco", 2, "Internacional", 1),
      Partida("Internacional", 3, "Londrina", 3),
      Partida("Porto", 1, "Lisboa", 2),
    ]),
    [
      Desempenho("Vasco", 0, 0, 0),
      Desempenho("Internacional", 0, 0, 0),
      Desempenho("Londrina", 0, 0, 0),
      Desempenho("Porto", 0, 0, 0),
      Desempenho("Lisboa", 0, 0, 0),
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
  )
  check.eq(tabela([]), [])
}

pub fn atualiza_tabela(
  jogo: Partida,
  tabela: List(Desempenho),
) -> List(Desempenho) {
  // Ao analisar o resultado da estrutura *jogo*, atualizar em *tabela* (lista de estruturas desempenho) o desempenho do time anfitrião e visitantes presentes em *jogo*
  // Caso o time anfitrião de *jogo* não esteja em *tabela*, *tabela* não será atualizado
  case tabela {
    [primeiro, ..resto] ->
      case primeiro.time == jogo.anfitriao {
        True ->
          case jogo.gols_anfi > jogo.gols_visi {
            True -> [
              Desempenho(
                primeiro.time,
                primeiro.pontos + 3,
                primeiro.vitorias + 1,
                primeiro.saldo + jogo.gols_anfi - jogo.gols_visi,
              ),
              ..atualiza_tabela(jogo, resto)
            ]

            False ->
              case jogo.gols_anfi < jogo.gols_visi {
                True -> [
                  Desempenho(
                    primeiro.time,
                    primeiro.pontos,
                    primeiro.vitorias,
                    primeiro.saldo + jogo.gols_anfi - jogo.gols_visi,
                  ),
                  ..atualiza_tabela(jogo, resto)
                ]

                False -> [
                  Desempenho(
                    primeiro.time,
                    primeiro.pontos + 1,
                    primeiro.vitorias,
                    primeiro.saldo,
                  ),
                  ..atualiza_tabela(jogo, resto)
                ]
              }
          }
        False ->
          case primeiro.time == jogo.visitante {
            True ->
              case jogo.gols_visi > jogo.gols_anfi {
                True -> [
                  Desempenho(
                    primeiro.time,
                    primeiro.pontos + 3,
                    primeiro.vitorias + 1,
                    primeiro.saldo + jogo.gols_visi - jogo.gols_anfi,
                  ),
                  ..atualiza_tabela(jogo, resto)
                ]

                False ->
                  case jogo.gols_visi < jogo.gols_anfi {
                    True -> [
                      Desempenho(
                        primeiro.time,
                        primeiro.pontos,
                        primeiro.vitorias,
                        primeiro.saldo + jogo.gols_visi - jogo.gols_anfi,
                      ),
                      ..atualiza_tabela(jogo, resto)
                    ]

                    False -> [
                      Desempenho(
                        primeiro.time,
                        primeiro.pontos + 1,
                        primeiro.vitorias,
                        primeiro.saldo,
                      ),
                      ..atualiza_tabela(jogo, resto)
                    ]
                  }
              }
            False -> [primeiro, ..atualiza_tabela(jogo, resto)]
          }
      }
    [] -> []
  }
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

  case partidas {
    [primeiro, ..resto] ->
      tabela_completa(resto, atualiza_tabela(primeiro, tabela))

    [] -> tabela
  }
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

pub fn maior(time1: Desempenho, time2: Desempenho) -> Desempenho {
  // Encontra o time com melhor desempenho entre dois times 

  case time1.pontos > time2.pontos {
    True -> time1
    False ->
      case time1.pontos < time2.pontos {
        True -> time2
        False ->
          case time1.vitorias > time2.vitorias {
            True -> time1
            False ->
              case time1.vitorias < time2.vitorias {
                True -> time2
                False ->
                  case time1.saldo > time2.saldo {
                    True -> time1
                    False ->
                      case time1.saldo < time2.saldo {
                        True -> time2
                        False ->
                          case string.compare(time1.time, time2.time) {
                            order.Lt -> time1
                            order.Eq -> time1
                            order.Gt -> time2
                          }
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
    Desempenho("Fluminense", 7, 2, 1),
  )
  check.eq(
    maior(Desempenho("Botafogo", 7, 2, 0), Desempenho("Fluminense", 7, 1, 1)),
    Desempenho("Botafogo", 7, 2, 0),
  )
  check.eq(
    maior(Desempenho("Botafogo", 5, 1, -1), Desempenho("Fluminense", 5, 1, 1)),
    Desempenho("Fluminense", 5, 1, 1),
  )
  check.eq(
    maior(Desempenho("Botafogo", 5, 1, 0), Desempenho("Fluminense", 5, 1, 0)),
    Desempenho("Botafogo", 5, 1, 0),
  )
}

pub fn maior_lista(tabela: List(Desempenho)) -> Desempenho {
  // Recebe uma tabela de desempenho de times e devolve o maior valor
  // Caso a função receba uma lista vazia como parametro, a função retornará  *Desempenho("", -1, -1, -1)
  // Utiliza a função auxiliar *maior*

  case tabela {
    [primeiro, ..resto] -> maior(primeiro, maior_lista(resto))
    [] -> Desempenho("", -1, -1, -1)
  }
}

pub fn maior_lista_examples() {
  check.eq(
    maior_lista([
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ]),
    Desempenho("Palmeiras", 4, 1, -1),
  )

  check.eq(
    maior_lista([
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Corinthians", 6, 2, 0),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ]),
    Desempenho("Corinthians", 6, 2, 0),
  )

  check.eq(maior_lista([]), Desempenho("", -1, -1, -1))
}

pub fn remove_maior(tabela: List(Desempenho)) -> List(Desempenho) {
  // Remove o maior valor de uma lista de desempenho
  // Utiliza a função auxiliar *maior_lista*

  case tabela {
    [primeiro, ..resto] ->
      case maior_lista(tabela) == primeiro {
        True -> resto
        False -> [primeiro, ..remove_maior(resto)]
      }
    [] -> []
  }
}

pub fn remove_maior_examples() {
  check.eq(
    remove_maior([
      Desempenho("Palmeiras", 4, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ]),
    [
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 1, 0, -1),
      Desempenho("Internacional", 3, 1, 3),
    ],
  )

  check.eq(
    remove_maior([
      Desempenho("Palmeiras", 7, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Santos", 7, 2, -1),
      Desempenho("Internacional", 3, 1, 3),
    ]),
    [
      Desempenho("Palmeiras", 7, 1, -1),
      Desempenho("Corinthians", 3, 1, -1),
      Desempenho("Internacional", 3, 1, 3),
    ],
  )

  check.eq(remove_maior([]), [])
}

pub fn classificacao_final(tabela: List(Desempenho)) -> List(Desempenho) {
  // Recebe uma tabela de times(lista de estruturas desempenhos de times) e a ordena em ordem decrescente de desempenho dos times
  // Utiliza as funções auxiliares *maior_lista* e *classificação_final*

  case tabela {
    [_, ..] -> [
      maior_lista(tabela),
      ..classificacao_final(remove_maior(tabela))
    ]

    [] -> []
  }
}

pub fn classificacao_final_examples() {
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
  case tabela {
    [primeiro, ..resto] -> [para_string(primeiro), ..lista_para_string(resto)]
    [] -> []
  }
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

  lista_para_string(
    classificacao_final(tabela_completa(
      lista_partidas(jogos),
      tabela(lista_partidas(jogos)),
    )),
  )
}

pub fn resultado_final_examples() {
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
