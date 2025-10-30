import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Grades.dart';
import 'package:polieats_frontend/src/widgets/button.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key, required this.assignment});

  final Assignment assignment;

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    final gradesController = Grades();
    final grades = gradesController.getGradesForAssignment(
      widget.assignment.title,
    );

    final coursesController = Courses();
    final course = coursesController.getCourseByName(
      widget.assignment.course,
    );

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 10,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        spacing: 10,
                        children: [
                          Positioned(
                            top: 8,
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: 8,
                              ),
                              decoration: BoxDecoration(
                                color: course!.color,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(20),
                                ),
                              ),
                              child: Text(
                                f.format(widget.assignment.dueDate),
                                style: TextStyle(
                                  fontFamily:
                                      GoogleFonts.leagueSpartan().fontFamily,
                                  fontSize: 12,
                                  color: Colors.blue.shade50,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            widget.assignment.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        grades.isNotEmpty
                            ? '${grades[0].score.toString()}/${grades[0].maxScore.toString()}'
                            : '-/${grades[0].maxScore.toString()}',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade700,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Descrição:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      Text(
                        widget.assignment.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Anexos:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        child: widget.assignment.attachments!.isNotEmpty
                            ? Expanded(
                                child: ListView.builder(
                                  itemBuilder: (context, index) {
                                    final attachment =
                                        widget.assignment.attachments![index];
                                    return ListTile(
                                      leading: Icon(Icons.attach_file),
                                      title: Text(
                                        attachment.fileName,
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.blue.shade800,
                                          fontFamily:
                                              GoogleFonts.leagueSpartan()
                                                  .fontFamily,
                                        ),
                                      ),
                                      onTap: () {
                                        // Lógica para abrir o anexo
                                      },
                                    );
                                  },
                                  itemCount:
                                      widget.assignment.attachments!.length,
                                ),
                              )
                            : Text(
                                'Nenhum anexo disponível.',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey.shade800,
                                  fontFamily:
                                      GoogleFonts.leagueSpartan().fontFamily,
                                ),
                              ),
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Meus anexos:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      // A container so the user can upload their own attachments, it should have a dashed border and a plus icon in the center
                      Container(
                        height: 150,
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Colors.grey.shade400,
                            style: BorderStyle.solid,
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: IconButton(
                            icon: Icon(
                              Icons.add,
                              size: 40,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              // Lógica para adicionar anexos do usuário
                            },
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'Toque no ícone acima para adicionar seus próprios anexos para esta tarefa.',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      SizedBox(height: 10),
                      Button(
                        backgroundColor: course.color,
                        text: 'Enviar Tarefa',
                        onPressed: () {
                          // Lógica para enviar a tarefa
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        currentIndex: 2,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Matérias'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}
