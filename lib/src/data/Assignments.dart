class Assignment {
  final String title;
  final String description;
  final DateTime dueDate;
  final String course;
  final bool isCompleted;

  Assignment({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.course,
    this.isCompleted = false,
  });
}

class Assignments {
  List<Assignment> assignments = [
  Assignment(
    title: 'Trabalho de Matemática',
    description: 'Resolver os exercícios do capítulo 5.',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    course: 'Matemática',
  ),
  Assignment(
    title: 'Leiture de Material de Matemática',
    description: 'Ler o material sobre álgebra linear.',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    course: 'Matemática',
  ),
  Assignment(
    title: 'Projeto de Ciências',
    description: 'Montar o experimento sobre plantas.',
    dueDate: DateTime.now().add(const Duration(days: 5)),
    course: 'Biologia',
  ),
  Assignment(
    title: 'Redação de História',
    description: 'Escrever uma redação sobre a Revolução Francesa.',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    course: 'História',
  ),
];

  List<Assignment> getAssignmentsForCourse(String courseName) {
    return assignments.where((assignment) => assignment.course == courseName).toList();
  }

  Assignment? getAssignmentByName(String name) {
    try {
      return assignments.firstWhere((assignment) => assignment.title == name);
    } catch (e) {
      return null;
    }
  }
}