import gleam/int
import gleam/io
pub type Voto {
    Candidato1
    Candidato2
    Branco
}

pub type Contabilizacao {
    Contabilizacao(candidato1: Int, candidato2: Int, branco: Int)
}

pub fn contabilizar(x: List(Voto)) -> Contabilizacao{
    case x{
        
        [] -> Contabilizacao(0,0,0)
        [Branco, ..resto] ->  Contabilizacao(contabilizar(resto).candidato1,contabilizar(resto).candidato2,contabilizar(resto).branco + 1) 
        [Candidato1, ..resto] -> Contabilizacao(contabilizar(resto).candidato1 + 1, contabilizar(resto).candidato2, contabilizar(resto).branco)
        [Candidato2, ..resto] -> Contabilizacao(contabilizar(resto).candidato1 ,contabilizar(resto).candidato2 + 1, contabilizar(resto).branco)
        
    }

}
pub fn vencedor(x: Contabilizacao) -> String {
        case x.candidato1 > x.candidato2 && x.candidato1 + x.candidato1 >= x.branco{
            True -> "Candidato 1 é o vencedor com " <> int.to_string(x.candidato1) <> " votos"
            False -> case x.candidato1 < x.candidato2 && x.candidato1 + x.candidato1 >= x.branco{
                True -> "Candidato 2 é o vencedor com "  <> int.to_string(x.candidato2) <> " votos"
                False -> case x.candidato1 == x.candidato2 && x.candidato1 + x.candidato1 >= x.branco{
                    True -> "Empate: " <> int.to_string(x.candidato1) <> " votos para cada"
                    False -> "Novas Eleições: " <> int.to_string(x.branco) <> " votos brancos"
                }
            }
        }
       
    }

pub fn eleicao(x: List(Voto)) -> String {
    vencedor(contabilizar(x))
}

pub fn main(){
    io.debug(contabilizar([Branco, Candidato1, Candidato2, Candidato2, Candidato2, Candidato1]))
    io.debug(vencedor(Contabilizacao(4, 5, 1)))
    io.debug(eleicao([Branco, Candidato1, Candidato2, Candidato2, Candidato2, Candidato1]))
    io.debug(eleicao([Branco, Candidato2, Candidato1, Branco, Branco]))
}


//pub fn contabilizar_examples(){

    //check.eq(contabilizar([Branco, Candidato1, Candidato2]),Contabilizacao(1,1,1))

//}