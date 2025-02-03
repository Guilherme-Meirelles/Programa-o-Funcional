import gleam/string
import gleam/io
import gleam/list
import sgleam/check

////Inverte o dia com o ano em um texto que representa uma data


/// A função receberá uma string como parâmentro e retornará uma string também


pub fn dma_para_amd(data: String) -> String {

    /// Transforma a string *data* que está no formato "dia/mes/ano"
    /// para o formato "ano/mes/dia".
    ///
    /// Requer que o dia e o mês tenham dois dígitos e que
    /// o ano tenha quatro dígitos.
    string.join(list.reverse(string.split(data,"/")),"/")


}

pub fn main(){
    io.debug(dma_para_amd("12/11/2013"))
}

pub fn dma_para_amd_examples() {
    check.eq(dma_para_amd("19/07/2023"), "2023/07/19")
    check.eq(dma_para_amd("01/01/1980"), "1980/01/01")
    check.eq(dma_para_amd("02/02/2002"), "2002/02/20")
}