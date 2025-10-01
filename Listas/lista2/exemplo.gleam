import gleam/io
import gleam/int

fn p() {
    p()
}

fn teste(x, y) {
    case x == 0 {
        True -> 0
        False -> y
    }
}

fn a_plus_abs_b(a, b) {
    case b > 0 {
    
        True -> int.add
        False -> int.subtract
    }   (a, b)
}

pub fn main(){
    io.debug(a_plus_abs_b(4,-6))
}

