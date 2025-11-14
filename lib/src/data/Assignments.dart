



class Attachment {
  final String fileName;
  final String filePath;
  final List<int> fileBytes;

  Attachment({required this.fileName, required this.filePath, required this.fileBytes});
}

class Assignment {
  final String title;
  final String description;
  final DateTime dueDate;
  final String course;
  final bool isCompleted;
  final List<Attachment>? attachments;

  Assignment({
    required this.title,
    required this.description,
    required this.dueDate,
    required this.course,
    this.isCompleted = false,
    this.attachments,
  });
}

class Assignments {
  List<Assignment> assignments = [
  Assignment(
    title: 'Trabalho de Matemática',
    description: 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Vivamus lacinia odio vitae vestibulum vestibulum. Cras venenatis euismod malesuada.',
    dueDate: DateTime.now().add(const Duration(days: 3)),
    course: 'Matemática',
    attachments: [
      Attachment(
      fileName: 'math_homework.pdf',
      filePath: 'path/to/math_homework.pdf',
      fileBytes: List.empty()
    ),
      Attachment(
      fileName: 'formulas_sheet.pdf',
      filePath: 'path/to/formulas_sheet.pdf',
      fileBytes: List.empty()
    ),
  ],
  ),
  Assignment(
    title: 'Leitura de Material de Matemática',
    description: 'Ler o material sobre álgebra linear.',
    dueDate: DateTime.now().add(const Duration(days: 2)),
    course: 'Matemática',
    attachments: [
      Attachment(
        fileName: 'linear_algebra_reading.pdf',
        filePath: 'path/to/linear_algebra_reading.pdf',
        fileBytes: List.empty(),
      ),
    ],
  ),
  Assignment(
    title: 'Projeto de Ciências',
    description: 'Montar o experimento sobre plantas.',
    dueDate: DateTime.now().add(const Duration(days: 5)),
    course: 'Biologia',
    attachments: [Attachment(
      fileName: 'science_project_instructions.pdf',
      filePath: 'path/to/science_project_instructions.pdf',
      fileBytes: List.empty(),
    )],
  ),
  Assignment(
    title: 'Redação de História',
    description: 'Escrever uma redação sobre a Revolução Francesa.',
    dueDate: DateTime.now().add(const Duration(days: 7)),
    course: 'História',
    attachments: 
    [Attachment(
      fileName: 'french_revolution_guidelines.pdf',
      filePath: 'path/to/french_revolution_guidelines.pdf',
      fileBytes: List.empty(),
    )],
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