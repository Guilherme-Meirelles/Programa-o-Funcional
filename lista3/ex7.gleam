import gleam/string
import gleam/io


///Análise 
/// 
/// Se uma palavra não termina com ponto final, adiciona-se um ponto final
/// 
/// Tipos de Dados
/// 
/// A função recebe uma string como parametro e retorna uma string
///

pub fn ponto_final(texto: String) -> String {
    //Analisa se a string 'Texto' termina com ponto, se não adiciona-se no final
    case string.ends_with(texto,"."){
        True -> texto
        False -> string.append(texto,".")
    }

}

pub fn main(){
    io.debug(ponto_final("casa."))
    io.debug(ponto_final("meu amor"))
}