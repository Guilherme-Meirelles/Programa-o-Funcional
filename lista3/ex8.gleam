import gleam/string
import gleam/io
///Analise 

///Verifica se há '-' no meio da string
/// 
///Tipo de dados
/// 
/// A função tem como parametro uma string e retorna um bool

pub fn verifica_traco(palavra: String) -> Bool {
    ///Verifica se há '-' na string *palavra*
    string.contains(palavra,"-")
}

pub fn main(){
    io.debug(verifica_traco("quero-quero"))
    io.debug(verifica_traco("loucalouca"))
    io.debug(verifica_traco("esqueça-se"))
}