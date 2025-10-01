import sgleam/check
import gleam/int


pub fn max_lista(x: List(Int)) -> Int {
    case x {
        [] -> -1000000000000000000000000000000000000000000000000000
        [primeiro, ..resto] -> int.max(primeiro, max_lista(resto))
    }
}

pub fn max_lista_examples(){

    check.eq(max_lista([1,5,8,2]), 8)
    check.eq(max_lista([5,7]), 7)
    check.eq(max_lista([-3, -4, -2, -7, -9, -10]),-2)
}