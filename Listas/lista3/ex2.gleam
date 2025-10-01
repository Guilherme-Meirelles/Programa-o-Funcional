import sgleam/check
import gleam/io
import gleam/int

// Descobre-se quantos digitos tem um número inteiro

// O parametro de entrada e saída da função sao números inteiros

pub fn quantidade_digitos(n: Int, m: Int) -> Int {
    
    case int.absolute_value(n) / 10 > 0 || int.absolute_value(n) % 10 > 0 {

        /// Conta a quantidade de dígitos de *n*.
        /// Se *n* é 0, então devolve zero.
        /// Se *n* é menor que zero, então devolve a quantidade
        
        False -> m
        True -> quantidade_digitos(n / 10, m + 1)
    }

}
pub fn main(){
    
    io.debug(quantidade_digitos(123, 0))
}

pub fn quantidade_digitos_examples() {
    check.eq(quantidade_digitos(123, 0), 3)
    check.eq(quantidade_digitos(0,0), 1)
    check.eq(quantidade_digitos(-1519, 0), 4)
}