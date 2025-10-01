import gleam/io
import gleam/string

pub fn primeira_maiuscula(x: String) -> String {
    string.capitalise(x)
}

pub fn main(){
    io.debug(primeira_maiuscula("rOgErio"))
}