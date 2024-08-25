// Assume a virtual networking system prototype where there are a set of nodes and messages. Every node has a unique name, ip address, port number,
// location from where it is situated, and status whether it is active, inactive or suspicious. In this system, the status of the node 
// is determined by the activity of the node. As it is a prototype, to monitor and track the system easily, the location has been fixed 
// into three places: Dhaka, Rajshahi, and Chattogram. Any node can send and receive messages. 
// So, every message has a source and destination nodes with a specific timestamp and a payload.

abstract sig Location {}
one sig Dhaka, Rajshahi, Chattogram extends Location {}
// signature for a node in the network
sig Node {
  name: String,
  ip: Int,
  port: Int,
  location: Location,
  status: Status
} 
fact uniqueAddress {
  all disj n1, n2: Node |
    n1.name != n2.name && n1.ip != n2.ip && n1.port != n2.port
}

// signature for the status of a node
abstract sig Status {}

// signatures for different node status types
one sig Active, Inactive, Suspicious extends Status {}

// signature for a message being sent between nodes
sig Message {
  source: Node,
  destination: Node,
  payload: String,
  timestamp: Int
} 

// signature for the network as a collection of nodes and messages
sig Network {
  nodes: set Node,
  messages: set Message
}

// all messages in the network must have a valid source and destination node
fact validMessageNodes {
  all m: Message | m.source in Network.nodes && m.destination in Network.nodes
}
// all messages must be sent between nodes within the same location
fact messageLocation {
  all m: Message |
    m.source.location = m.destination.location
}

// all active nodes in the network must be able to send and receive messages
fact activeNodeCommunication {
  all n: Node |
    n.status = Active =>
    (all m: Message | m.source = n => m.destination.status = Active) &&
    (all m: Message | m.destination = n => m.source.status = Active)
}

// all suspicious and inactive nodes in the network must not be able to send or receive messages
fact suspiciousAndInactiveNodeCommunication {
  all n: Node |
    n.status = Suspicious =>
    (all m: Message | m.source = n implies m.destination.status = Suspicious) &&
    (all m: Message | m.destination = n implies m.source.status = Suspicious)
  all n: Node |
    n.status = Inactive =>
    (all m: Message | m.source = n implies m.destination.status = Inactive) &&
    (all m: Message | m.destination = n implies m.source.status = Inactive)
}
// all nodes must be within a certain distance from at least one other node in the network
fact networkConnectivity {
  all n: Node |
    (some n2: Network.nodes | n != n2 && n.location = n2.location)
}
// all nodes must be able to send and receive messages
assert networkCommunication {
  all n: Node |
    (all m: Message | m.source = n implies (some n2: Network.nodes | m.destination = n2 && n2 != n)) &&
    (all m: Message | m.destination = n implies (some n2: Network.nodes | m.source = n2 && n2 != n))
}

check networkCommunication for 10

// There are some messages whose source and destination nodes are same
assert self {
    some n: Node | some m: Message | m.source = n and m.destination = n
}
check self for 10

// There may have some active nodes whose IP address, port, and location are not valid
assert validActiveNode {
  some n: Node |
    n.status = Active => n.ip >= 0 && n.ip <= 255 && n.port > 0 && n.location not in Location
}
check validActiveNode for 5

// all nodes with an inactive or suspicious status must not have a location
assert inactiveOrSuspiciousNodeLocation {
  all n: Node |
    (n.status = Inactive or n.status = Suspicious) => n.location = none
}
check inactiveOrSuspiciousNodeLocation for 10

// all messages sent to a node in Rajshahi must have a timestamp between 1000 and 2000 with "checksum: OKAY" payload.
assert rajshahiTimestamp {
all m: Message |
  m.destination.location = Rajshahi =>
  m.timestamp >= 1000 && m.timestamp < 2000 and m.payload = "checksum: OKAY"
}
check rajshahiTimestamp for 10



