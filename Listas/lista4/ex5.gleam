
import sgleam/check
import gleam/float

pub type  Formas{
    Retangulo(altura: Float, largura: Float)
    Circulo(raio: Float)
}

pub fn area(x: Formas){
    case x{
        Retangulo(x,y) -> x *. y
        Circulo(z) -> z *. z *. 3.14
    }
}

pub fn cabe(maior: Formas,menor: Formas){
    case maior,menor {
        Retangulo(a,b),Retangulo(c,d) -> case a >=. c, b >=. d{
            True, True -> True
            _,_ -> False

        }
        Retangulo(a,b),Circulo(c) -> case a >=. 2.0 *. c, b >=. 2.0 *.c {
            True,True -> True
            _,_ -> False
        }
        Circulo(c), Retangulo(a,b) -> case 2.0 *. c *. c >=. a *. a +. b *. b{
            True -> True
            False -> False
        }
        Circulo(a),Circulo(b) -> case a >=. b {
            True -> True
            False -> False
        }
    }
}


pub fn area_examples(){
    check.eq(area(Retangulo(5.0, 4.0)),20.0)
    check.eq(float.ceiling(area(Retangulo(6.7,4.6))),25.0)
    check.eq(area(Circulo(2.0)),12.56)
    check.eq(area(Circulo(3.5)), 20.0)
    check.eq(cabe(Retangulo(4.0, 5.0), Retangulo(3.0, 4.0)), True)
    check.eq(cabe(Circulo(6.0), Retangulo(3.0, 4.0)), True)
    check.eq(cabe(Retangulo(5.0, 6.0), Circulo(4.0)), True)
    check.eq(cabe(Circulo(5.0), Circulo(4.0)),True)

}
