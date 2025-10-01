import gleam/io

pub type Pagamento{

    Pix
    Dinheiro
    Boleto
    Parcelado(n_vezes: Int)

}


pub fn compra(valor: Float, forma_de_pagamento: Pagamento) -> Float {

    case forma_de_pagamento {
        Pix -> valor -. valor *. 1.0 /. 10.0
        Dinheiro -> valor -. valor *. 1.0 /.10.0
        Boleto -> valor -. valor *.  2.0 /.25.0
        Parcelado(a) -> case a <= 3 {
            
            True -> valor
            False -> valor +. valor *. 3.0/.25.0
        }

    }
}

pub fn main(){

    io.debug(compra(100.0, Pix))
    io.debug(compra(78.0, Dinheiro))
    io.debug(compra(156.0, Boleto))
    io.debug(compra(78.0, Parcelado(2)))
    io.debug(compra(56.0, Parcelado(10)))
}