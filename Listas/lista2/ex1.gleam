import gleam/io
import gleam/float

pub fn area( a :Float, b: Float) -> Float {  
    a *. b
}
pub fn main(){
    io.debug(float.ceiling(area(15.5, 10.1)))
}