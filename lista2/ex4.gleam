import gleam/io


pub fn par(x: Int) -> String{
    case x % 2 == 0{
        True -> "é par"
        False -> "é ímpar"
    }
}

pub fn main(){
    io.debug(par(4))
}