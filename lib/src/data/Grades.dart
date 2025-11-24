class Grade {
  final int submissionId;
  final String assignmentName;
  final double score;
  final double maxScore;
  final String course;
  final DateTime dateRecorded;
  final String studentName;

  Grade({
    required this.submissionId,
    required this.assignmentName,
    required this.score,
    required this.maxScore,
    required this.course,
    required this.dateRecorded,
    required this.studentName,
  });
}

class Grades {
  List<Grade> grades = [
    Grade(
      submissionId: 1,
      assignmentName: 'Trabalho de Matemática',
      score: 85,
      maxScore: 100,
      course: 'Matemática',
      dateRecorded: DateTime.now(),
      studentName: 'João Silva',
    ),
    Grade(
      submissionId: 2,
      assignmentName: 'Leitura de Material de Matemática',
      score: 92,
      maxScore: 100,
      course: 'Matemática',
      dateRecorded: DateTime.now(),
      studentName: 'Maria Santos',
    ),
    Grade(
      submissionId: 3,
      assignmentName: 'Função de segundo grau',
      score: 88,
      maxScore: 100,
      course: 'Matemática',
      dateRecorded: DateTime.now(),
      studentName: 'Pedro Costa',
    ),
    Grade(
      submissionId: 4,
      assignmentName: 'Projeto de Ciências',
      score: 90,
      maxScore: 100,
      course: 'Biologia',
      dateRecorded: DateTime.now(),
      studentName: 'Ana Paula',
    ),
    Grade(
      submissionId: 5,
      assignmentName: 'Redação de História',
      score: 78,
      maxScore: 100,
      course: 'História',
      dateRecorded: DateTime.now(),
      studentName: 'Carlos Mendes',
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