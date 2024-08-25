// Assume, in a single row, 10 students can sit.
sig Course {
  code: Int,
  name: String
}
sig Semester{
  program: one Program,
  offeredCourses: some Course
}
abstract sig Department {
  programs: some Program
}
sig CSE, EEE, CEE, MPE extends Department {}
abstract sig Program {
  requiredCourses: some Course
}
sig CS extends Program {}
sig SWE extends Program {}
sig MEE extends Program {}
sig IPE extends Program {}
sig Student {
  id: one Int,
  department: one Department,
  batch: one Int,
  program: one Program,
  currentSemester: one Semester,
  takenCourses: some Course
}
sig Seat{
  number: Int
}
sig Room {
  rNumber: Int,
  academicBuilding: String,
  capacity: Int,
  labelledSeat: set Seat
}
sig AssignedSeatInfo{
  room: one Room,
  labelledSeat: one Seat,
  who: one Student
}
sig Exam {
  courses: set Course,
  date: one Int,
  info: set AssignedSeatInfo
}
fact uniqueSeat {
  all s1, s2: Seat | s1 != s2
  all disj r1, r2: Room | r1.rNumber != r2.rNumber
}

fact f {
  // all students must belong to a valid department and program for an exam
  all e: Exam | all s: e.info.who | s.department in Department and s.program in Program

  // In the exam hall, students of every program can sit only for the courses that are assigned in their current semester
  all e: Exam | all s: e.info.who | all c: s.takenCourses | c in e.courses => (one sem: Semester |
                                        s.currentSemester = sem && s.program = sem.program && c in sem.offeredCourses)
  //All students in an exam must fit in the room's capacity
  all e: Exam | #e.info.who <= #e.info.room.capacity

  // No two programs of any department have the identical offered courses

  // In any given room, it is prohibited to seat two students of the same program of any department consecutively.

}

assert a1 {
  // No student is assigned to two exams at the same day
  all e: Exam | all s: e.info.who | #(s.takenCourses & e.courses)>1
}
check a1 for 10

assert a2 {
// It is allowed to have 70% similarities of the offered courses of any two programs of the same department, but 30% for the different departments.
}
check a2 for 10

assert a3 {
// For an assigned seat of a program's student, there is no any other students around him/her.
}
check a3 for 10

assert a4 {
 // Each room can only be occupied by students from a single batch.
}
check a4 for 10


assert a5 {
  // For any program, there must not any duplication of courses of different semesters
}
check a5 for 10
