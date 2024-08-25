module examples/hotel
open util/ordering[Time] as TO
open util/ordering[Key] as KO

sig Key {}
sig Time {}

sig Room {
keys: set Key,
currentKey: keys one->Time
}
sig Guest {
keys: Key -> Time
}

one sig FrontDesk {
lastKey: (Room->lone Key)->Time,
occupant: (Room->Guest)->Time
}
pred show (r: Room) {some r.keys}
run show for 2 but 1 Room
