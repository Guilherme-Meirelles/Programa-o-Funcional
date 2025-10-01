import gleam/string
import sgleam/check

///Analise 
/// 
/// Verificar se uma string tem espaços extras
/// 
/// Tipos de dados
/// 
/// A função recebe uma string como parametro  e devolve o bool
/// 
pub fn sem_espacos_extras(palavra: String) -> Bool {
    /// Se há string *palavra* começa ou termina com um espaço então a função retorna False, caso contrário retorna True
    
    case string.ends_with(palavra, " ") || string.ends_with(string.reverse(palavra), " ") {
        True -> False
        False -> True
    }
}

pub fn sem_espacos_extras_examples(){
    check.eq(sem_espacos_extras("lula"), True)
    check.eq(sem_espacos_extras(" lula  "), False)
    check.eq(sem_espacos_extras("vai vai"), False)
}