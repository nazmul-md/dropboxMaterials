sig ID {}

abstract sig Person {}

sig Faculty extends Person {}

abstract sig Student extends Person {
	id: one ID,
	transcript: set Course
}

sig Graduate, UnderGraduate extends Student {}

sig Instructor in Person {}

sig Course {
	taughtBy: one Instructor,
	enrolled: some Student,
	waitlist: set Student,
	prerequisites: set Course
}

fact {
	//All instructors are either Faculty or Graduate Students
	all i: Instructor | i in Faculty + Graduate
	// Instructors do not teach courses they are enrolled in or waiting to enroll in
	all c: Course | c.taughtBy not in c.enrolled + c.waitlist
	// No one is waiting for a course unless someone is enrolled
	all c: Course | some c.waitlist => some c.enrolled
	// A student can only have a course for which they have the prerequisites
	// A student's transcript contains a course only if it contains the course's prerequisites
	all s: Student | s.transcript.prerequisites in s.transcript
	//// A student can only have, wait for or take a course for which they have the prerequisites
	all s: Student | (waitlist.s + enrolled.s + s.transcript).prerequisites in s.transcript 
}

assert a1 {
	// There is a graduate student who is an instructor
	// Found, no facts ensure the counterexample
	some Graduate & Instructor 
}
check a1 for 5

assert a2 {
	// A course does not have itself as a prerequisite
	// Found, no facts ensure the counterexample
	all c: Course | c !in c.^prerequisites
}
check a2 for 5

assert a3 {
	// No instructor is on the waitlist for a course that he/she teaches
	// Not found, fact 2
	all c: Course | no (c.taughtBy & c.waitlist)
}
check a3 for 5

assert a4 {
	// For every course, no student is enrolled and on the waitlist at the same time.
	// Found, no facts ensure the counterexample
	all c: Course | all s: c.enrolled | s not in c.waitlist
}
check a4 for 5

assert a5 {
	// There is a course with prerequisite and enrolled students
	// Found, no facts ensure the counterexample
	one c: Course | some c.prerequisites and some c.enrolled
}
check a5 for 5
