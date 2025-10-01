import gleam/string
import sgleam/check

pub fn tamanho_medio_strings(x: List(String)) -> Int{
    
    tam_strings(x) / tam_lista(x)
}

pub fn tam_lista(x: List(String)) -> Int {
    case x {
    [_, ..resto] -> 1 + tam_lista(resto)
    [] -> 0
    }
}

pub fn tam_strings(x: List(String)) -> Int {
    case x {
    [primeiro, ..resto] -> string.length(primeiro) + tam_strings(resto)
    [] -> 0
    }
}

pub fn tamanho_medio_strings_examples() {
    check.eq(tamanho_medio_strings(["Hello","World"]), 5)
    check.eq(tamanho_medio_strings(["Hello","Beatiful","World","That","I","Love"]), 4)
    check.eq(tamanho_medio_strings([]),0)
}