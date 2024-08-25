sig User {
    id: Int,
    userName: String,
    emails: Email,
    posts: set Post,
    friends: set User
}
enum Provider {Google, MicroSoft}
sig Email {
    address: String,
    provider: Provider
}
sig Post {
    id: Int,
    content: String,
    timeStamp: Int,
    author: one User,
    likes: set Like
}

sig Like {
    id: Int,
    timestamp: Int,
    liker: one User
}

fact{
    // Every user must have a unique ID and a non-empty username and email.
    all u1, u2: User | u1.id = u2.id implies u1 = u2
    all u: User | #u.userName > 0 and #u.emails > 0
    // Friendship is symmetric; if User A is friends with User B, then User B is also friends with User A.
    all u1: User, u2: User | u1 in u2.friends implies u2 in u1.friends
    // Each post must belong to a single user's posts.
    all p: Post | one p.author and p in p.author.posts
    // Users can have multiple email addresses, but each email address must be unique.
    all u: User | no disj e1, e2: Email | e1 in u.emails and e2 in u.emails and e1.address = e2.address
    // Friendship is transitive; if User A is friends with User B, and User B is friends with User C, then User A is friends with User C.
    all disj u1: User, u2: User, u3: User | u1 in u2.friends and u2 in u3.friends implies u1 in u3.friends

}

assert a1 {
    // Every user must have at least one post, and each post must have at least one like.
    all u: User | some u.posts and all p: u.posts | some p.likes
}
check a1 for 5

assert a2 {
    // There should be no friendship between users who haven't liked each other's posts.
    all u1: User, u2: User | u1 in u2.friends implies some p: u2.posts | u1 in p.likes.liker
}
check a2 for 15

assert a3 {
    // Users can not like their own posts
    all u: User | some u.posts and all p: u.posts | some p.likes
}
check a3 for 5

assert a4 {
    // Every user of the social network is somehow connected
    all u: User | User = u.*friends
}
check a4 for 5

assert a5 {
    // Users with email addresses from Google's service provider have a higher count of posts compared to users with email addresses from Microsoft's service provider.
}
check a5 for 5
