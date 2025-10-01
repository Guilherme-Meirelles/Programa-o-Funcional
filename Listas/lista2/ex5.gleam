import gleam/io

pub fn tres_digitos(x: Int) -> Bool{
    99 < x  &&  x < 1000
}

pub fn main(){
    io.debug(tres_digitos(180))
}