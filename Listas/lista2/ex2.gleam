import gleam/io

pub fn produto_anterior_posterior(a : Int) -> Int {
    {a - 1} * a * {a + 1}
}

pub fn main() {
    io.debug(produto_anterior_posterior(5))
}