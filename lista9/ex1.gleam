import gleam/io
import gleam/int
import gleam/list
import gleam/string

pub fn inteiro_para_string_dois_passos(lista: List(Int), acc: List(String)) -> List(String){

    case lista {
        [primeiro, ..resto] -> case primeiro < 10{
            True -> inteiro_para_string_dois_passos(resto, [int.to_string(primeiro), ..acc])
            False -> {
                let a = int.to_string(primeiro / 10)
                let b = int.to_string(primeiro % 10)
                inteiro_para_string_dois_passos(resto, [a <> b, ..acc])
            }
            
        }
        [] -> list.reverse(acc)
    }
}

pub fn inteiro_para_string_dois_passos_2(lista: List(Int)) -> List(String){

    list.fold_right(lista, [], fn(acc, a) {case a < 10 {
        True -> [int.to_string(a), ..acc]
        False -> {
            let b = int.to_string(a / 10)
            let c = int.to_string(a % 10)
            [b <> c, ..acc]
        }
    }})
    }

pub fn inverte_parcial(lista: List(String)) -> List(String){
    case lista {
        [primeiro,..resto] -> case string.length(primeiro) < 2 {
            True -> [primeiro, ..inverte_parcial(resto)]
            False -> { let a = string.drop_left(primeiro, 1) |> string.drop_right(_, 1) |> string.reverse()
                        let b = string.drop_right(primeiro, string.length(primeiro) - 1)
                        let c = string.drop_left(primeiro, string.length(primeiro) - 1)
                        let d = string.concat([c, a, b])
                        [d, ..inverte_parcial(resto)]
            }
        }
        [] -> []
    }
}


pub fn main(){
    io.debug(inteiro_para_string_dois_passos([5, 3, 36287, 12, 8, 76, 29], []))
    io.debug(inteiro_para_string_dois_passos_2([5, 3, 36287, 12, 8, 76, 29]))
    io.debug(inverte_parcial(["j", "amor", "augusto"]))
}