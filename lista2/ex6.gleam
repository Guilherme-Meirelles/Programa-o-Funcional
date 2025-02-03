import gleam/io

pub fn maximo(a: Int, b: Int) -> Int {
    case a >= b{
        True -> a
        False -> b
    }
}

pub fn main() {
    io.debug(maximo(8,5))
}