import gleam/io

pub type Coordenadas{
    Norte
    Sul
    Oeste
    Leste
}

pub fn cord_oposta(x: Coordenadas) -> Coordenadas{
    case x {
        Norte -> Sul
        Sul -> Norte
        Oeste -> Leste
        Leste -> Oeste
    }
}

pub fn sentido_horario(x: Coordenadas) -> Coordenadas{
    case x{
        Norte -> Leste
        Leste -> Sul
        Sul -> Oeste
        Oeste -> Norte
    }
}

pub fn sentido_antihorario(x: Coordenadas) -> Coordenadas{
    case x{
        Norte -> Oeste
        Leste -> Norte
        Sul -> Leste
        Oeste -> Sul
    }
}

pub fn virar_cord(x: Coordenadas, y: Coordenadas) -> Int{
    case x {
        Norte -> case y{
            Norte -> 0
            Leste -> 90
            Sul -> 180
            Oeste -> 270
        }
        Leste -> case y{
            Norte -> 270
            Leste -> 0
            Sul -> 90
            Oeste -> 180
        }
        Sul -> case y{
            Norte -> 180
            Leste -> 270
            Sul -> 0
            Oeste -> 90
        }
        Oeste -> case y{
            Norte -> 270
            Leste -> 180
            Sul -> 90
            Oeste -> 0
        }
    }
}

pub fn main(){
    io.debug(cord_oposta(Sul))
    io.debug(sentido_horario(Leste))
    io.debug(sentido_antihorario(Norte))
    io.debug(virar_cord(Sul, Sul))
}