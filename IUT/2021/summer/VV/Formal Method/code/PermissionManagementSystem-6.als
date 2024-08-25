sig Account {
	resources: set Resource,
	users: set User
}

sig User {
	resources: set Resource
}

sig Resource {
	parent: lone Resource
}

fact "no shared users" {
	all u: User |
		one a:Account | 
			u in a.users
}

fact "parent resource in same account" {
	all r:Resource |
		some r.parent implies
			(one a:Account |
				r in a.resources and r.parent in a.resources)
}

fact "No_cycles" {
	no r:Resource |
		r in r.^parent
}

fact "only permit owning resources in same account" {
	all u: User, a:Account |
		u in a.users implies u.resources in a.resources
}

run {} for 2 but exactly 2 Account
