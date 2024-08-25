sig Account {
	// Every Account has 0 or more Resources
	resources: set Resource,
	// Every Account has 0 or more Users
	users: set User
}

sig User {
	// Every User has direct access to 0 or more Resources
	resources: set Resource
}

sig Resource {
	// Every Resource has 0 or 1 parent Resource
	parent: lone Resource
}

run {} for 2 but exactly 2 Account
