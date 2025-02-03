import gleam/string
import gleam/list
import gleam/io
import gleam/int
import gleam/order

pub fn maior_lista(numeros: List(Int)) -> Int {
    case numeros {
        [primeiro, ..resto] -> {
            let a = maior_lista(resto)
            let b = int.compare(primeiro, a)
            case b {
                order.Lt -> a
                _ -> primeiro

            }

        }
        [] -> -1
    }
}


pub fn painel(nomes: List(String)) -> List(String) {
    
    let b =  maior_lista(list.map(nomes, string.length))
    list.map(nomes, string.pad_left(_,b, " "))
      
}

pub fn main() {
    
    io.debug(painel(["Jean", "Guilherme", "Horacio", "Davi"]))
}