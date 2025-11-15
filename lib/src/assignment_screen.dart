import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Grades.dart';
import 'package:polieats_frontend/src/widgets/button.dart';

class AssignmentScreen extends StatefulWidget {
  const AssignmentScreen({super.key, required this.assignmentId});

  final int assignmentId; // Change this to accept an ID instead of full assignment

  @override
  _AssignmentScreenState createState() => _AssignmentScreenState();
}

class _AssignmentScreenState extends State<AssignmentScreen> {
  Assignment? assignment;
  bool isLoading = true;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    _loadAssignment();
  }

  Future<void> _loadAssignment() async {
    try {
      final fetchedAssignment = await api.fetchAssignmentById(widget.assignmentId);
      setState(() {
        assignment = fetchedAssignment;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(backgroundColor: Colors.white),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'Erro ao carregar atividade',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
              ),
              SizedBox(height: 8),
              Text(
                errorMessage!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey.shade600,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    isLoading = true;
                    errorMessage = null;
                  });
                  _loadAssignment();
                },
                child: Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    final f = DateFormat('dd/MM/yyyy', 'pt_BR');
    final gradesController = Grades();
    final grades = gradesController.getGradesForAssignment(assignment!.title);
    final course = globals.courseController.getCourseByName(assignment!.course);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
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
                              f.format(assignment!.dueDate),
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 12,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            assignment!.title,
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        grades.isNotEmpty
                            ? '${grades[0].score.toString()}/${grades[0].maxScore.toString()}'
                            : 'Não avaliado',
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
                SizedBox(height: 20),
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
                      SizedBox(height: 8),
                      Text(
                        assignment!.description,
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
                      SizedBox(height: 8),
                      SizedBox(
                        height: 100,
                        child: assignment!.attachments != null && assignment!.attachments!.isNotEmpty
                            ? ListView.builder(
                                itemBuilder: (context, index) {
                                  final attachment = assignment!.attachments![index];
                                  return ListTile(
                                    leading: Icon(Icons.attach_file),
                                    title: Text(
                                      attachment.fileName,
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.blue.shade800,
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      ),
                                    ),
                                    onTap: () {
                                      // Logic to open attachment
                                    },
                                  );
                                },
                                itemCount: assignment!.attachments!.length,
                              )
                            : Center(
                                child: Text(
                                  'Nenhum anexo disponível.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.grey.shade800,
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  ),
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
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              IconButton(
                                icon: Icon(
                                  Icons.add,
                                  size: 40,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  // Lógica para adicionar anexos do usuário
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('Funcionalidade em desenvolvimento'),
                                    ),
                                  );
                                },
                              ),
                              Text(
                                'Adicionar anexo',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade600,
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                ),
                              ),
                            ],
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
                      SizedBox(height: 30),
                      Button(
                        backgroundColor: course.color,
                        text: 'Enviar Tarefa',
                        onPressed: () {
                          // Lógica para enviar a tarefa
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Tarefa enviada com sucesso!'),
                              backgroundColor: Colors.green,
                            ),
                          );
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
