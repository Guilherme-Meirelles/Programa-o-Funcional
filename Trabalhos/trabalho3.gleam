// Alunos: Guilherme Grecco Bononi (RA 134754), Guilherme José Monteiro Meirelles (RA 133995)

import gleam/int

import gleam/list
import gleam/string
import sgleam/check

//Analise

//O programa desenvolvido tem a finalidade de calcular e encontrar o resultado de uma expressão numérica .
// A expressão numérica está na notação infixa e é representada na forma de de uma string.
// Dentro da string há números inteiros e operadores de soma, subtração, multiplicação e divisão, portanto a partir desta
// representação deve-se encontrar o resulta da expressão.

//Tipos de Dados

// O programa recebe uma string que representa uma expressão matemática que está na notação infixa, esta string é
// transformada em uma lista de estruturas 'Simbolo' que representa a expressão ,
// depois gera-se novamente uma lista de estruturas 'Simbolo' só que representando a expressão na notação pós-fixa,
// por fim gera-se um número inteiro que representa o resultado da expressão.

pub type Simbolo {

  // Representa os símbolos presentes em uma expressão matemática, os simbolos podem ser um operando ou operador.
  Operador(String)
  Operando(Int)
}

pub fn empilha(a: Int, acc: List(Int)) -> List(Int) {
  // Insere um valor *a* na lista *acc*.
  [a, ..acc]
}

pub fn primeiro(acc: List(Int)) -> Int {
  // retorna o primeiro valor de uma lista   
  case acc {
    [] -> 0
    [a, ..] -> a
  }
}

pub fn desempilha(acc: List(Int)) -> List(Int) {
  // Retira-se o primeiro valor de uma lista
  case acc {
    [] -> []
    [_, ..resto] -> resto
  }
}

pub fn avalia_expressao_posfixa_loop(
  simbolos: List(Simbolo),
  acc: List(Int),
) -> Int {
  // Avalia a variável *expressao* que uma lista de estrutura 'Simbolo'
  // na notação pós-fixa e devolve o resultado da expressão.
  // Caso a pilha de inteiros esteja vazia e ainda houver operadores para processar, 
  // será realizadas operações com operandos sendo igual a 0

  case simbolos {
    [] ->
      case acc {
        [primeiro, ..] -> primeiro
        [] -> 0
      }

    [Operando(a), ..resto] ->
      empilha(a, acc)
      |> avalia_expressao_posfixa_loop(resto, _)

    [Operador(c), ..resto] -> {
      let a = primeiro(acc)
      let acc2 = desempilha(acc)
      let b = primeiro(acc2)
      let acc3 = desempilha(acc2)
      let d = case c {
        "+" -> b + a
        "-" -> b - a
        "x" -> b * a
        "/" -> b / a
        _ -> 0
      }
      empilha(d, acc3)
      |> avalia_expressao_posfixa_loop(resto, _)
    }
  }
}

pub fn avalia_expressao_posfixa(simbolos: List(Simbolo)) {
  avalia_expressao_posfixa_loop(simbolos, [])
}

pub fn avalia_expressao_posfixa_examples() {
  check.eq(
    avalia_expressao_posfixa([
      Operando(2),
      Operando(4),
      Operador("x"),
      Operando(5),
      Operador("-"),
    ]),
    3,
  )

  check.eq(
    avalia_expressao_posfixa([Operando(2), Operando(2), Operador("+")]),
    4,
  )
  check.eq(
    avalia_expressao_posfixa([Operando(3), Operando(4), Operador("x")]),
    12,
  )
  check.eq(
    avalia_expressao_posfixa([Operando(8), Operando(2), Operador("/")]),
    4,
  )
  check.eq(
    avalia_expressao_posfixa([
      Operando(24),
      Operando(2),
      Operando(10),
      Operador("+"),
      Operador("/"),
    ]),
    2,
  )
  check.eq(avalia_expressao_posfixa([]), 0)
}

fn precedencia(a: Simbolo, b: Simbolo) -> Bool {
  // Função auxiliar de infixa_para_posfixa_loop que define se o elemento *a* que está no
  // topo de uma pilha tem maior ou igual procedencia que o elemento *b* que vai ser adicionado na pilha
  // Se o retornar falso então o elemento *a* não deve ser desempilhado, se retornar *true* então o elemento *a*
  // deve ser desempilhado
  case a, b {
    Operador("-"), Operador("x") -> False
    Operador("-"), Operador("/") -> False
    Operador("+"), Operador("x") -> False
    Operador("+"), Operador("/") -> False
    _, Operador("(") -> False
    Operador("("), _ -> False
    _, _ -> True
  }
}

pub fn atualiza_pilha(pilha: List(Simbolo), operador: Simbolo) -> List(Simbolo) {
  // Função auxiliar da função *infixa_para_posfixa_loop* que atualiza a pilha de operadores a partir do operador que
  // vai ser adicionado na pilha
  case pilha {
    [] -> [operador]
    [primeiro, ..resto] ->
      case operador == Operador(")") {
        True ->
          case primeiro != Operador("(") {
            True -> atualiza_pilha(resto, operador)
            False -> resto
          }

        False ->
          case precedencia(primeiro, operador) {
            False -> [operador, ..pilha]
            True -> [operador, ..resto]
          }
      }
  }
}

pub fn retorna_pilha(
  pilha: List(Simbolo),
  operador: Simbolo,
  acc: List(Simbolo),
) -> List(Simbolo) {
  // Função auxiliar da função *infixa_para_posfixa_loop* que retorna os elementos que serão desempilhados da pilha
  // antes de empilhar um elemento

  case pilha {
    [] -> []
    [primeiro, ..resto] ->
      case operador == Operador(")") {
        True ->
          case primeiro == Operador("(") {
            False -> retorna_pilha(resto, operador, [primeiro, ..acc])
            True -> list.reverse(acc)
          }

        False ->
          case precedencia(primeiro, operador) {
            False -> []
            True -> [primeiro]
          }
      }
  }
}

pub fn infixa_para_posfixa_loop(
  expressao: List(Simbolo),
  pilha: List(Simbolo),
  acc: List(Simbolo),
) -> List(Simbolo) {
  // Transforma uma lista de estruras Simbolos que representa um expressão numérica na notação infixa em 
  // uma lista de estruturas Simbolos que representa uma notação pós-fixa
  case expressao {
    [] ->
      case pilha {
        [] -> acc
        [primeiro, ..resto] ->
          infixa_para_posfixa_loop([], resto, [primeiro, ..acc])
      }
    [Operando(a), ..resto] ->
      infixa_para_posfixa_loop(resto, pilha, [Operando(a), ..acc])
    [Operador(b), ..resto] ->
      infixa_para_posfixa_loop(
        resto,
        atualiza_pilha(pilha, Operador(b)),
        list.append(retorna_pilha(pilha, Operador(b), []), acc),
      )
  }
}

pub fn infixa_para_posfixa(expressao: List(Simbolo)) -> List(Simbolo) {
  list.reverse(infixa_para_posfixa_loop(expressao, [], []))
}

pub fn infixa_para_posfixa_examples() {
  check.eq(infixa_para_posfixa([Operando(2), Operador("+"), Operando(6)]), [
    Operando(2),
    Operando(6),
    Operador("+"),
  ])

  check.eq(
    infixa_para_posfixa([
      Operando(2),
      Operador("+"),
      Operando(6),
      Operador("x"),
      Operando(3),
    ]),
    [Operando(2), Operando(6), Operando(3), Operador("x"), Operador("+")],
  )

  check.eq(
    infixa_para_posfixa([
      Operador("("),
      Operando(1),
      Operador("+"),
      Operando(2),
      Operador(")"),
      Operador("x"),
      Operador("("),
      Operando(3),
      Operador("-"),
      Operando(4),
      Operador(")"),
      Operador("/"),
      Operando(5),
    ]),
    [
      Operando(1),
      Operando(2),
      Operador("+"),
      Operando(3),
      Operando(4),
      Operador("-"),
      Operador("x"),
      Operando(5),
      Operador("/"),
    ],
  )
  check.eq(
    infixa_para_posfixa([
      Operador("("),
      Operando(1),
      Operador("+"),
      Operando(2),
      Operador(")"),
      Operador("x"),
      Operando(3),
    ]),
    [Operando(1), Operando(2), Operador("+"), Operando(3), Operador("x")],
  )
  check.eq(
    infixa_para_posfixa([
      Operador("-"),
      Operando(7),
      Operador("x"),
      Operador("("),
      Operador("-"),
      Operando(10),
      Operador("+"),
      Operando(4),
      Operador(")"),
    ]),
    [
      Operando(7),
      Operando(10),
      Operador("-"),
      Operando(4),
      Operador("+"),
      Operador("x"),
      Operador("-"),
    ],
  )
}

pub fn join(strings: List(String), separador: List(String)) -> List(String) {
  // Função auxiliar que junta caracteres de uma lista de strings que não estão separados
  // por um separador (operadores ou espaço), ou seja, junta os caracteres que representam 
  // um número ´por exemplo: (1 e 2 = 12), (-, 4 e 5 = -45)

  list.fold(strings, [], fn(acc, c) {
    case acc {
      [primeiro, ..resto] ->
        case primeiro == "(", c == "-" {
          True, True -> [string.concat([primeiro, c]), ..resto]
          _, _ ->
            case list.contains(separador, primeiro) {
              True -> [c, ..acc]
              False ->
                case list.contains(separador, c) {
                  True -> [c, ..acc]
                  False ->
                    case primeiro == "(-" {
                      True -> [string.concat(["-", c]), "(", ..resto]

                      False -> [string.concat([primeiro, c]), ..resto]
                    }
                }
            }
        }
      [] -> [c]
    }
  })
}

pub fn string_para_simbolos(expressao: String) -> List(Simbolo) {
  // Converte uma String *expressao* na notação infixa para uma lista de símbolos.
  // Dica: converta a string para uma lista de strings de 1
  // caractere e processe a lista.
  // Para números negativos é recomendado que ele seja representado desta forma: (-x)
  // Se houver algum símbolo inválido na string, ele será descartado

  let lista_caracteres =
    string.split(expressao, " ")
    |> string.concat()
    |> string.split("")
    |> join(["+", "-", "x", "/", "(", ")"])
    |> list.reverse()

  list.fold_right(lista_caracteres, [], fn(acc, c) {
    case c {
      "+" -> [Operador("+"), ..acc]
      "-" -> [Operador("-"), ..acc]
      "x" -> [Operador("x"), ..acc]
      "/" -> [Operador("/"), ..acc]
      "(" -> [Operador("("), ..acc]
      ")" -> [Operador(")"), ..acc]
      _ -> {
        let n = int.parse(c)
        case n {
          Ok(a) -> [Operando(a), ..acc]
          Error(Nil) -> acc
        }
      }
    }
  })
}

pub fn resultado_final(expressao: String) -> Int {
  // Função que transforma uma string que representa uma expressão numérica no seu resultado inteiro
  string_para_simbolos(expressao)
  |> infixa_para_posfixa()
  |> avalia_expressao_posfixa()
}

pub fn resultado_final_examples() {
  check.eq(resultado_final("2 + 4 x 5 - 7"), 15)
  check.eq(resultado_final("-10 + 4 x 5 - 28"), -18)
  check.eq(resultado_final("(10 + 4) x 5 - 7"), 63)
  check.eq(resultado_final("-7 x (-10 + 4)"), 42)
  check.eq(resultado_final("-8"), -8)
}

pub fn string_para_simbolos_examples() {
  check.eq(string_para_simbolos("2+4"), [
    Operando(2),
    Operador("+"),
    Operando(4),
  ])
  check.eq(string_para_simbolos("2 x4"), [
    Operando(2),
    Operador("x"),
    Operando(4),
  ])
  check.eq(string_para_simbolos("(2-3)/4"), [
    Operador("("),
    Operando(2),
    Operador("-"),
    Operando(3),
    Operador(")"),
    Operador("/"),
    Operando(4),
  ])
  check.eq(string_para_simbolos("(-7) x (-10 + 4)"), [
    Operador("("),
    Operando(-7),
    Operador(")"),
    Operador("x"),
    Operador("("),
    Operando(-10),
    Operador("+"),
    Operando(4),
    Operador(")"),
  ])
}
