import gleam/io
import gleam/string
import gleam/int


pub type Data{
    Data(x: Int, y: Int, z: Int)
}
pub fn aux(x: String) -> List(String){
    string.split(x, "/")
}

pub fn data(x: String) -> Result(Data, String) {
    case int.parse(string.slice(x,0,2)), int.parse(string.slice(x, 3, 2)), int.parse(string.slice(x,6,4)){
        Ok(x),Ok(y),Ok(z) -> Ok(Data(x,y,z))
        _,_,_ ->  Error("Erro")
    }
}

pub fn data2(x: String) -> Data{
    case data(x){
        Ok(y) -> y
        _ -> Data(0,0,0)
    }
}

pub fn ultimo_dia(a: String) -> Bool{
    case data2(a).x{
        31 -> case data2(a).y {
            12 -> True
            _ -> False
        }
        _ -> False
    }
}

pub fn primeira_data_antes(primeira: String, segunda: String){
    case data2(primeira).z < data2(segunda).z{
        True -> True
        False -> case data2(primeira).z == data2(segunda).z{
            True -> case data2(primeira).y < data2(segunda).y{
                True -> True
                False -> case data2(primeira).y == data2(segunda).y{
                    True ->  case data2(primeira).x < data2(segunda).x{
                        True -> True
                        False -> False
                    }
                    False -> False
                }  
            }
            False -> False
        }
    }
}






pub fn main(){
    io.debug(data2("02/12/2004"))
    io.debug(ultimo_dia("31/12/2010"))
    io.debug(primeira_data_antes("01/12/1990", "02/12/1990"))
    
}