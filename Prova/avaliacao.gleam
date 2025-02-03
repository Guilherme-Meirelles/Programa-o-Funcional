import sgleam/check
import gleam/list

pub type PalavrasReptidas {
    // Estrutura auxiliar que é utilizada na função *mais_repetidas_loop*
    // para calcular a quantidade de vezes que uma string aparece na lista
    PalavrasReptidas(palavra: String, repeticoes: Int)
}

pub fn atualiza_acumulador(palavra: String,acc: List(PalavrasReptidas)) -> List(PalavrasReptidas){
    // Função auxiliar para atualizar o acumulador da função *mais_repetidas_loop*
    case acc {
        [primeiro, ..resto] -> case palavra == primeiro.palavra {
            True -> [PalavrasReptidas(primeiro.palavra, primeiro.repeticoes + 1), ..resto]
            False -> [primeiro, ..atualiza_acumulador(palavra, resto)]
        }
        [] -> [PalavrasReptidas(palavra, 1)]
    }
}

pub fn maiores_lista(acc: List(PalavrasReptidas)) -> List(PalavrasReptidas) {
    // Função auxiliar de *mais_reptidas_loop*, que encontra as strings que mais se repetiram e as devolvem junto com quantidade 
    // de vezes que se repetiram, se a lista for vazia devolve *[PalavrasReptidas("",0)]*
    case acc {
        [primeiro, ..resto] -> {
            let a = maiores_lista(resto)
            case a {
                [first, ..] -> case primeiro.repeticoes > first.repeticoes{
                    True -> [primeiro]
                    False -> case primeiro.repeticoes == first.repeticoes{
                        True -> [primeiro, ..a]
                        False -> a
                    }
                }
                [] -> [primeiro]
            }
        }
        [] -> []
    }
}

pub fn resultado(mais_reptidas: List(PalavrasReptidas)) -> List(String){
    // Função auxiliar de *mais_reptidas_loop*, que transforma as estruturas *PalavrasReptidas* em Strings
    // a partir do atributo *palavra* presente nestas estruturas 
    case mais_reptidas{
        [primeiro, ..resto] -> [primeiro.palavra, ..resultado(resto)]
        [] -> []
    }
}

pub fn mais_repetidas_loop(palavras: List(String), acc: List(PalavrasReptidas)) -> List(String) {
    // Ao receber uma lista de strings *palavras*, devolver as strings que mais se repetem na lista
    case palavras {
        [primeiro, ..resto] -> atualiza_acumulador(primeiro, acc) |> mais_repetidas_loop(resto,_)
        [] -> maiores_lista(acc) |> resultado()
            
        }
    }


pub fn mais_reptidas(palavras: List(String)) -> List(String){
    mais_repetidas_loop(palavras, [])
    // A função tem complexidade O(n^2), pois é necessário varrer todos os elementos de entrada e para cada elemento de entrada 
    // é necessário analisar os elementos do acumulador
}

pub fn mais_reptidas_examples(){
    check.eq(mais_reptidas(["amor", "casa", "amor","varanda", "casa"]), ["amor", "casa"])
    check.eq(mais_reptidas(["amor", "hotel", "amor","varanda", "casa"]), ["amor"])
    check.eq(mais_reptidas([]), [])

}

pub fn encontra_minimos(lista: List(Int)) -> List(Int){
    // Funcão auxiliar de *ordena_loop* que ajudar a encontrar os menores números de uma lista
    case lista {
        [primeiro, ..resto] -> {
            let a = encontra_minimos(resto)
            case a {
                [first, ..] -> case first < primeiro {
                    True -> a
                    False -> case first == primeiro {
                        True -> [primeiro, ..a]
                        False -> [primeiro]
                    }

                }
                [] -> [primeiro]
            }
        }
        [] -> []
    }
}

pub fn retira_minimos(lista: List(Int), minimos: List(Int)) -> List(Int){
    // Função auxiliar de *ordena_loop* que retira os números mínimos de uma lista
    case minimos {
        [primeiro, ..] -> list.filter(lista, fn(x) {x != primeiro})
        [] -> []
    }
}


pub fn ordena_loop(lista: List(Int), acc: List(Int)) -> List(Int){
    // Ordena uma lista de números através do método selection
    case lista{
        [_,..] -> { let a = encontra_minimos(lista)
                    let b = retira_minimos(lista, a)
                    let c = list.fold(a, acc, fn (acc2, e) {
                        [e, ..acc2]

                    })
                    ordena_loop(b, c)
    }
    [] -> acc
    }
}

pub fn ordena(lista: List(Int)) -> List(Int){
    // O melhor caso é quando todos os elementos da lista são iguais com a complexidade sendo omega n
    // O pior caso é quando todos os elementos são diferentes uns dos outros sendo a complexidade O(n^2)

    list.fold(ordena_loop(lista, []), [], fn(acc, a){
        [a, ..acc]
    })
}

pub fn ordena_examples(){
    check.eq(ordena([1,1,5,4,1,2]), [1,1,1,2,4,5])
    check.eq(ordena([]), [])
    check.eq(ordena([2, 2, 2, 2, 2]), [2, 2, 2, 2, 2])
}