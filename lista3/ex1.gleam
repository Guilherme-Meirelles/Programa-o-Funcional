import sgleam/check

pub fn isento_tarifa(idade: Int) -> Bool {
    case idade < 18 || idade >= 65 {
        True -> True
        False -> False
    }
}

pub fn isento_tarifa_examples() {
check.eq(isento_tarifa(17), True)
check.eq(isento_tarifa(18), True)
check.eq(isento_tarifa(50), False)
check.eq(isento_tarifa(65), True)
check.eq(isento_tarifa(70), True)
}