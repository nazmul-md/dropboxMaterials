abstract sig Program {
    required: some Course
}
one sig CSE, SWE extends Program {}
sig Course {
    enrolled: some Student,
    prerequisite: set Course
}
sig Student {
    id: one ID,
    batch: one Batch,
    program: one Program,
    transcript: Course -> Grade
}
sig RecordBook {
    students: set Student
}

abstract sig Grade {}
one sig A, B, C, D, F extends Grade{}

sig ID, Batch {}

fact {
    all disj s1, s2: Student | s1.id != s2.id
    all s: Student | all p: s.program | (p in CSE => p not in SWE) and (p in SWE => p not in CSE)
    all s: Student, r: RecordBook | s in r.students => s.program.required in s.transcript.Grade
    all disj s1,s2: Student | s1.program != s2.program => s1.transcript != s2.transcript
    all s: Student | s.transcript.Grade.^prerequisite in s.transcript.Grade
    CSE.required != SWE.required
}

assert a1 {
    // The number of students in the record book is equal to the sum of the number of students in each batch.
    #RecordBook.students = sum b: Batch | #b.students
}
assert a2 {
    some c: Course, disj s1, s2: c.enrolled | s1.batch = s2.batch and s1.program != s2.program
}
assert a3 {
    some c: Course | #c.enrolled.program =2
}
assert a4 {
    some c: Course | c in CSE.required and c in SWE.required
}
assert a5 {
    //  each student is enrolled in a course at most once.
    all s: Student, c: Course | one c.enrolled & s
}

check a1 for 3
check a2 for 5
check a3 for 5
check a4 for 5
check a5 for 5