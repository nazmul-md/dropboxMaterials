abstract sig FSObject {
	parent: lone Directory
}

sig File extends FSObject{}

sig Directory extends FSObject{
	entries: set Entry
}

sig Entry {
	name: one Name,
	object: one FSObject
}

sig Name {}

one sig Root extends Directory {}{no parent}

fact f {
File + Directory = FSObject
all fs:Entry.object | fs in Directory => fs not in fs.^parent
FSObject = Root.*(entries.object) 
all d: Directory | d not in d.^(object[entries])
all d: Directory, e1, e2: d.entries | e1 != e2 implies object[e1].parent != object[e2].parent && e1.name != e2.name

}

assert a1{
	//NF
	Root.^(entries.object) = FSObject-Root

}
check a1 for 5

assert a2{
	//F
	all disj d1,d2:Directory| # (d1.entries & d2.entries) = 0
}
check a2 for 5

assert a3{
//NF
all d:Directory, disj e1, e2:d.entries| e1.name !=e2.name
}
check a3 for 5


assert a4{
	//F
	one fs:FSObject | # fs.parent =0
}
check a4 for 5


assert a5{
//F
all d:Directory, o: entries[d].object| o.parent = d

}
check a5 for 5
