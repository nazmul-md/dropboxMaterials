abstract sig Person {
	father: lone Man,
	mother: lone Woman
}

sig Man extends Person {
	wife: lone Woman
}

sig Woman extends Person {
	husband: lone Man
}

fact Biology {
	no p: Person | p in p.^(mother + father)
}

fact Terminology {
	wife = ~husband
}

fun getFather [p: Person]: Man {
	p.father
}
assert NoSelfFather {
	no m: Man | m = getFather[m]
}

check NoSelfFather for 3

fun grandpas[p:Person]: set Person {
	p.(father+mother).father
}

pred owngrandpa(p:Person) {
	p in grandpas[p]
}
run owngrandpa for 4 Person
