import gleam/io
import gleam/int
import gleam/list

pub fn conta(lista: List(a), pred: fn(a) -> Bool) -> Int {
    case lista {
        [primeiro, ..resto] -> case pred(primeiro) {
            True -> 1 + conta(resto, pred)
            False -> conta(resto, pred)
        }
        [] -> 0
    }
}

pub fn conta2(lista: List(a), pred: fn(a) -> Bool) -> Int {
    list.length(list.filter(lista, pred))
}

pub fn main(){
    io.debug(conta([3,2,1,4,5], int.is_odd))
    io.debug(conta2([3,2,1,4,5], int.is_odd))
}