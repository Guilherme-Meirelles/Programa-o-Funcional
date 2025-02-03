import gleam/io

pub fn ordem(x: Int, y: Int, z: Int) -> String{
    case x < y {
        True -> case y < z {
            True -> "crescente"
            False -> "sem ordem"
        }
        False -> case y > z {
            True -> "decrescente"
            False -> "sem ordem"
        }
    }
}

pub fn main(){
    io.debug(ordem(5,5,4))
}