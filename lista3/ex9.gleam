import sgleam/check
import gleam/string

///Analise
/// 
/// Substitue o inicio de uma string por caracteres 'x', no qual o usuário escolhe a quantidade de caracteres 'x'
/// 
/// Tipos de dados
/// 
/// A função recebe como parametro uma string palavra e um e retorna uma string

pub fn insere_x(palavra: String, n: Int) -> String {
    ///Substitue os caracteres iniciais da string *palavra* por *n* caracteres x
    
    string.append(string.repeat("x",n),string.drop_left(palavra,n))
    
}

pub fn insere_x_examples(){
    check.eq(insere_x("lula",2),"xxla")
    check.eq(insere_x("andorinha",4),"xxxxrinha")
    check.eq(insere_x("lu",5),"xxxxx")
    check.eq(insere_x("vai",2),"xxx")
}