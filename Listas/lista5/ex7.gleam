
import sgleam/check

pub fn ordem_decrescente(x: List(Int)) -> Bool {
    case x{
        [primeiro,segundo, ..resto] -> primeiro >= segundo && ordem_decrescente([segundo, ..resto])
        [_] -> ordem_decrescente([])
        [] -> True
        
    }
}

pub fn ordem_descrescente_examples(){
    
    check.eq(ordem_decrescente([5,3,2,1]), True)
    check.eq(ordem_decrescente([3,5,2,1]), False)
}