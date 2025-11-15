import 'package:polieats_frontend/main.dart';

class Notice {
  final String title;
  final String content;
  final DateTime date;
  final bool isRead;
  final String owner;
  final String course;

  Notice({
    required this.title,
    required this.content,
    required this.date,
    this.isRead = false,
    required this.owner,
    required this.course,
  });
}

class Notices {
  List<Notice> notices = [
    Notice(
      title: 'Aula de História Cancelada',
      content: 'A aula de história de amanhã foi cancelada devido a um evento escolar.',
      date: DateTime.now().subtract(const Duration(days: 2)),
      isRead: false,
      owner: 'Professor de História',
      course: 'História',
    ),
    Notice(
      title: 'Exame de Matemática',
      content: 'O exame de matemática será realizado na próxima segunda-feira às 10h.',
      date: DateTime.now(),
      isRead: false,
      owner: 'Professor de Matemática',
      course: 'Matemática',
    ),
    Notice(
      title: 'Entrega de Projeto de Ciências',
      content: 'Lembrete: o projeto de ciências deve ser entregue até sexta-feira.',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isRead: true,
      owner: 'Professor de Ciências',
      course: 'Física',
    ),
  ];

  void fetchAllNotices() async {
    try {
      notices = await api.fetchNotices();
    } catch (e) {
      print('Error fetching notices: $e');
    }
  }

  List<Notice> getNoticesForCourse(String courseName) {
    fetchAllNotices();
    return notices.where((notice) => notice.course == courseName).toList();
  }
}