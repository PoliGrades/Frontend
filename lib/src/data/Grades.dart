class Grade {
  final String assignmentName;
  final double score;
  final double maxScore;
  final String course;
  final DateTime dateRecorded;

  Grade({
    required this.assignmentName,
    required this.score,
    required this.maxScore,
    required this.course,
    required this.dateRecorded,
  });
}

class Grades {
  List<Grade> grades = [
    Grade(
      assignmentName: 'Trabalho de Matemática',
      score: 85,
      maxScore: 100,
      course: 'Matemática',
      dateRecorded: DateTime.now(),
    ),
    Grade(
      assignmentName: 'Leitura de Material de Matemática',
      score: 92,
      maxScore: 100,
      course: 'Matemática',
      dateRecorded: DateTime.now(),
    ),
    Grade(
      assignmentName: 'Projeto de Ciências',
      score: 90,
      maxScore: 100,
      course: 'Biologia',
      dateRecorded: DateTime.now(),
    ),
    Grade(
      assignmentName: 'Redação de História',
      score: 78,
      maxScore: 100,
      course: 'História',
      dateRecorded: DateTime.now(),
    ),
  ];

  List<Grade> getGradesForCourse(String courseName) {
    return grades.where((grade) => grade.course == courseName).toList();
  }

  List<Grade> getGradesForAssignment(String assignmentName) {
    return grades.where((grade) => grade.assignmentName == assignmentName).toList();
  }

  List<Grade> getAllGrades() {
    return grades;
  }
}