import gleam/string
import sgleam/check

/// O estado de um editor de linha.
/// - esquerda é o conteúdo da linha a esquerda do cursor
/// - direita é o conteúdo da linha a direita do cursor
pub type Editor {
  Editor(esquerda: String, direita: String)
}

// Enumeração que representa possíveis comandos executaveis pelo cursor em um editor de linha
// Os comandos são: mover o cursor um caracter para direita, mover o cursor um caracter para esquerda,
// apagar o caracter anterior ao cursor e adicionar um novo caracter na posição do cursor
pub type Comando {

  Direita
  Esquerda
  Apagar
  Inserir(caracter: String)
}

// Tipos de Dados: A função recebe uma enumeração Comando e uma estrutura Editor e devolve uma estrutura Editor
pub fn comandos_cursor(comando: Comando, linha: Editor) -> Editor {
  //Executa o comando de cursor presente em *comando* no parâmetro *linha* e devolve *linha* atualizado

  case comando {
    Direita ->
      Editor(
        linha.esquerda <> string.slice(linha.direita, 0, 1),
        string.slice(linha.direita, 1, string.length(linha.direita)),
      )
    Esquerda ->
      Editor(
        string.slice(linha.esquerda, 0, string.length(linha.esquerda) - 1),
        string.slice(linha.esquerda, -1, 1) <> linha.direita,
      )
    Apagar ->
      Editor(
        string.slice(linha.esquerda, 0, string.length(linha.esquerda) - 1),
        linha.direita,
      )
    Inserir(a) -> Editor(linha.esquerda <> a, linha.direita)
  }
}

pub fn comandos_cursor_examples() {
  check.eq(
    comandos_cursor(Direita, Editor("Hello", "World")),
    Editor("HelloW", "orld"),
  )
  check.eq(
    comandos_cursor(Direita, Editor("Feliz", " Natal")),
    Editor("Feliz ", "Natal"),
  )
  check.eq(
    comandos_cursor(Direita, Editor("HelloWorld", "")),
    Editor("HelloWorld", ""),
  )
  check.eq(comandos_cursor(Direita, Editor("", "")), Editor("", ""))
  check.eq(
    comandos_cursor(Esquerda, Editor("Hello", "World")),
    Editor("Hell", "oWorld"),
  )
  check.eq(
    comandos_cursor(Esquerda, Editor("Feliz", " Natal")),
    Editor("Feli", "z Natal"),
  )
  check.eq(
    comandos_cursor(Esquerda, Editor("", "HelloWorld")),
    Editor("", "HelloWorld"),
  )
  check.eq(comandos_cursor(Esquerda, Editor("", "")), Editor("", ""))
  check.eq(
    comandos_cursor(Apagar, Editor("Hello", "World")),
    Editor("Hell", "World"),
  )
  check.eq(
    comandos_cursor(Apagar, Editor("Feliz", " Natal")),
    Editor("Feli", " Natal"),
  )
  check.eq(
    comandos_cursor(Apagar, Editor("", "HelloWorld")),
    Editor("", "HelloWorld"),
  )
  check.eq(comandos_cursor(Apagar, Editor("", "")), Editor("", ""))
  check.eq(
    comandos_cursor(Inserir("!"), Editor("Hello", "World")),
    Editor("Hello!", "World"),
  )
  check.eq(
    comandos_cursor(Inserir("z"), Editor("Feliz", " Natal")),
    Editor("Felizz", " Natal"),
  )
  check.eq(
    comandos_cursor(Inserir("!"), Editor("", "HelloWorld")),
    Editor("!", "HelloWorld"),
  )
  check.eq(
    comandos_cursor(Inserir("!"), Editor("HelloWorld", "")),
    Editor("HelloWorld!", ""),
  )
  check.eq(comandos_cursor(Inserir("!"), Editor("", "")), Editor("!", ""))
}

// Tipos de Dados: a função recebe recebe um inteiro e uma lista de interos e devolve um inteiro
pub fn repeticoes(numero: Int, lista_de_numeros: List(Int)) -> Int {
  // A função analisa a quantidade de vezes que um número aparece em uma lista de numeros

  case lista_de_numeros {
    [primeiro, ..resto] ->
      case primeiro == numero {
        True -> 1 + repeticoes(numero, resto)
        False -> repeticoes(numero, resto)
      }
    [] -> 0
  }
}

pub fn repeticoes_examples() {
  check.eq(repeticoes(4, [4, 1, 2, 3, 5, 1, 4, 2, 4]), 3)
  check.eq(repeticoes(1, [4, 1, 2, 3, 5, 1, 4, 2, 4]), 2)
  check.eq(repeticoes(5, [4, 1, 2, 3, 5, 1, 4, 2, 4]), 1)
  check.eq(repeticoes(8, [4, 1, 2, 3, 5, 1, 4, 2, 4]), 0)
  check.eq(
    repeticoes(1, [5, 2, 1, 0, 10, 2, 7, 1, 2, 1, 4, 1, 3, 2, 2, 6, 7]),
    4,
  )
  check.eq(repeticoes(4, []), 0)
}

// Tipos de Dados: A função recebe uma lista de Inteiros e devolve um inteiro
pub fn maxima_repeticao(lista_de_numeros: List(Int)) -> Int {
  //Encontra a máxima repetição em uma lista, ou seja, a maior quantidade de vezes que qualquer elemento da lista se repete.
  //Usa a função auxiliar *repeticoes*
  
  case lista_de_numeros {
    [primeiro, ..resto] ->
      case repeticoes(primeiro, lista_de_numeros) > maxima_repeticao(resto) {
        True -> repeticoes(primeiro, lista_de_numeros)
        False -> maxima_repeticao(resto)
      }
    [] -> 0
  }
}

pub fn maxima_repeticao_examples() {
  check.eq(maxima_repeticao([4, 2, 2, 4, 1, 3, 7, 2, 1, 5]), 3)
  check.eq(maxima_repeticao([4, 1, 2, 3, 5, 1, 4, 2, 4, 4, 1, 7, 5, 3, 0]), 4)
  check.eq(maxima_repeticao([1, 2, 3, 4, 5, 6, 7, 8, 9, 10]), 1)
  check.eq(
    maxima_repeticao([5, 2, 1, 0, 10, 2, 7, 1, 2, 1, 4, 1, 3, 2, 2, 6, 7]),
    5,
  )
  check.eq(maxima_repeticao([]), 0)
}
