import sgleam/check
import gleam/string

pub fn concatena_string(x: List(String)) -> String {

    case x {
        [] -> ""
        [primeiro, ..resto] -> string.append(primeiro, concatena_string(resto))
    }
}

pub fn concatena_string_examples(){
    check.eq(concatena_string(["Hello"," World"]),"Hello World")
    check.eq(concatena_string(["Hello","Beatiful","World","That","I","Love"]),"HelloBeatifulWorldThatILove")
    check.eq(concatena_string([]),"")
}