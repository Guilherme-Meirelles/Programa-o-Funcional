import gleam/io
import gleam/int
import gleam/list

pub fn multiplica_dois(x: Int) -> Int{
    x * 2 
}


pub fn main(){
    io.debug(duas_vezes(fn(x) {x + 1})(3))
    io.debug(duas_vezes(fn(x) {list.map(x, multiplica_dois)})([3, 5, 10, 2]))
    
    
}

pub fn duas_vezes(pred: fn(x) -> x) -> fn(x) -> x {
    fn(x) {pred(pred(x))}
}