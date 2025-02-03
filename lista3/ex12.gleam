import gleam/string
import gleam/io

///Análise
/// 
/// Mostrar qual letras aparecerão em um letreiro em um determinado momento
/// 
/// Tipo de dados
/// 
/// O parametro da função é uma string e ela retorna uma string
/// 

pub fn letreiro(mensagem: String,letreiro_tam: Int, momento: Int) -> String {
    ///A partir do tamanho do letreiro e do *momento* mostra-se quais caracteres da String *mensagem* aparecerão na mensagem
    /// Por exemplo: mensagem: 'Ola mundo ' , letreiro_tam: 5, momento: 0 -> Ola m
    ///                                                       momento: 2 -> a mun
    ///                                                       momento: 4 -> mundo
    ///                                                       momento: 7 -> do Ol
    
    let y = string.length(mensagem) - letreiro_tam
    let momento_p = momento % string.length(mensagem)

    case y >= momento_p {
       True -> string.slice(mensagem, momento_p, letreiro_tam)
       False -> string.append(string.drop_left(mensagem, momento_p), string.slice(mensagem, 0, momento_p - y))
    }
   
}

pub fn main(){
    io.debug(letreiro("Hello World ",6,0))
    io.debug(letreiro("Hello World ",6,4))
    io.debug(letreiro("Hello World ", 6, 10))
    io.debug(letreiro("Hello World ", 6, 20))
}