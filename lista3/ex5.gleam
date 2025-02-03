import sgleam/check
import gleam/float


///Ánalise 
/// 
/// Fazer uma função que aumente um valor, escolhendo o valor e somando com uma porcentagem escolhida sobre este valor
/// 
/// Tipos de Dados
/// 
/// A função recebe dois parametros *valor* e *porcentagem* que são representados em Float e retorna um valor em Float

pub fn aumenta(valor: Float, porcentagem: Float) -> Float {
    //
    // A função soma o parametro valor com o parametro porcentagem dividido por 100 e multiplicado com parametro valor

    float.ceiling(valor *. {1.0 +. porcentagem /. 100.0})
}

pub fn aumenta_examples(){
    check.eq(aumenta(10.0,20.0),12.0)
    check.eq(aumenta(25.0,15.0),29.0)
    check.eq(aumenta(50.0,30.0),65.0)
}
