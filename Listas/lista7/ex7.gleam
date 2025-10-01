import gleam/io
import gleam/list
pub type Alternativas{
    A
    B
    C
    D
    E
}

pub fn prova(assinalidas: List(Alternativas), gabarito: List(Alternativas)) -> Int{

    case assinalidas, gabarito {
        [marcada, ..resto], [resposta, ..restante] -> case marcada == resposta {
            True -> 1 + prova(resto, restante)
            False -> prova(resto, restante)
        }
        [_, ..],[] -> 0
        [],[_, ..] -> 0
        [],[] -> 0
    }
}

pub fn livros_repetidos(livros1: List(String), livros2: List(String)) -> Int {

    case livros1, livros2 {
        [a, ..ra],[b, ..rb] -> case a == b{
            True -> 1 + livros_repetidos(ra, livros2)
            False -> livros_repetidos(livros1, rb)
        }
        [a, ..ra], [] -> 0
        [], [b, ..rb] -> 0
        [], [] -> 0
    
}
}



pub fn prova2(assinaladas: List(Alternativas), gabarito: List(Alternativas)) -> Int{

    list.count(list.map2(assinaladas, gabarito, fn(x,y){x==y}), fn(a) {a == True})
}

pub fn main(){

    io.debug(prova([A,B,A,D,E,C,E,D,A,A,C,C,E,B,D],[A,A,C,D,E,C,B,D,A,B,D,D,E,B,C]))
    io.debug(livros_repetidos(["Ola", "O", "Va", "Cabe", "Sonha"], ["Ola", "A", "Va", "Ca", "Sonha"]))
    io.debug(prova2([A,B,A,D,E,C,E,D,A,A,C,C,E,B,D],[A,A,C,D,E,C,B,D,A,B,D,D,E,B,C]))
}