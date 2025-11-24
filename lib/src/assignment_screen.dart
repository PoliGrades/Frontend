import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Submissions.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
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
  CourseClass? courseClass;
  Subject? course;
  Submission? mySubmission;
  List<SubmissionAttachment> userAttachments = [];
  bool isSubmissionLoading = false;
  bool isPickingFiles = false;

  @override
  void initState() {
    super.initState();
    _loadAssignment();
  }

  Future<void> _loadAssignment() async {
    try {
      final fetchedAssignment = await api.fetchAssignmentById(widget.assignmentId);
      courseClass = globals.classController.getClassById(fetchedAssignment.classId);
      course = globals.courseController.getSubjectById(courseClass!.subjectId);
      
      // Fetch user's submission if exists
      await _loadUserSubmission();
      
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

  Future<void> _loadUserSubmission() async {
    try {
      setState(() {
        isSubmissionLoading = true;
      });
      
      final submissions = await api.fetchTaskSubmissions(widget.assignmentId);
      print('Fetched ${submissions.length} submissions for assignment ${widget.assignmentId}');
      final currentUserId = globals.currentUser.id;
      print('Current user ID: $currentUserId');
      
      // Find submission for current user
      final userSubmission = submissions.firstWhere((s) => s.studentId == currentUserId);
      print('User submission: ${userSubmission.grade}');
      
      setState(() {
        mySubmission = userSubmission;
        if (userSubmission.attachments != null) {
          userAttachments = List.from(userSubmission.attachments!);
        }
        isSubmissionLoading = false;
      });
    } catch (e) {
      debugPrint('Error loading user submission: $e');
      setState(() {
        isSubmissionLoading = false;
      });
    }
  }

  Future<void> _pickFiles() async {
    if (!mounted) return;
    
    setState(() {
      isPickingFiles = true;
    });

    try {
      final result = await FilePicker.platform.pickFiles(
        allowMultiple: true,
        type: FileType.any,
      );

      if (!mounted) return;

      if (result != null && result.files.isNotEmpty) {
        for (PlatformFile file in result.files) {
          if (file.name.isNotEmpty && file.bytes != null) {
            setState(() {
              userAttachments.add(
                SubmissionAttachment(
                  fileName: file.name,
                  filePath: file.path ?? '',
                  fileBytes: file.bytes!,
                ),
              );
            });
          }
        }

        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                '${result.files.length} arquivo(s) anexado(s) com sucesso!',
              ),
              backgroundColor: Colors.green,
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao anexar arquivo: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isPickingFiles = false;
        });
      }
    }
  }

  Future<void> _submitAssignment() async {
    if (!mounted) return;
    
    try {
      setState(() {
        isSubmissionLoading = true;
      });

      await api.submitTask(widget.assignmentId, userAttachments);
      
      // Reload submission data
      await _loadUserSubmission();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Tarefa enviada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao enviar tarefa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          isSubmissionLoading = false;
        });
      }
    }
  }

  void _removeAttachment(int index) {
    setState(() {
      userAttachments.removeAt(index);
    });
  }

  Color _getGradeColor(double grade, double maxScore) {
    final percentage = (grade / maxScore) * 100;
    if (percentage >= 70) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
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
                              color: course!.colorAsFlutterColor,
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
                        mySubmission?.isGraded == true
                            ? '${mySubmission!.grade?.toStringAsFixed(1) ?? 0}/10'
                            : mySubmission != null 
                                ? 'Aguardando nota'
                                : 'Não entregue',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: mySubmission?.isGraded == true 
                              ? _getGradeColor(mySubmission!.grade ?? 0, 10)
                              : mySubmission != null 
                                  ? Colors.orange.shade600
                                  : Colors.red.shade600,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Submission Status Section
                if (mySubmission != null) ...[
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: mySubmission!.isGraded ? Colors.green.shade50 : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: mySubmission!.isGraded ? Colors.green.shade200 : Colors.blue.shade200,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              mySubmission!.isGraded ? Icons.check_circle : Icons.upload_file,
                              color: mySubmission!.isGraded ? Colors.green : Colors.blue,
                            ),
                            SizedBox(width: 8),
                            Text(
                              mySubmission!.isGraded ? 'Atividade Avaliada' : 'Atividade Entregue',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontWeight: FontWeight.bold,
                                color: mySubmission!.isGraded ? Colors.green.shade700 : Colors.blue.shade700,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          'Entregue em: ${DateFormat('dd/MM/yyyy HH:mm').format(mySubmission!.submittedAt)}',
                          style: TextStyle(
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        if (mySubmission!.isGraded && mySubmission!.feedback != null && mySubmission!.feedback!.isNotEmpty) ...[
                          SizedBox(height: 12),
                          Text(
                            'Feedback do Professor:',
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          SizedBox(height: 4),
                          Container(
                            width: double.infinity,
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade50,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              mySubmission!.feedback!,
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 13,
                                color: Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                ],
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
                      SizedBox(height: 8),

                      // Show uploaded files if submission exists
                      if (mySubmission != null && userAttachments.isNotEmpty) ...[
                        Container(
                          padding: EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.grey.shade50,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.grey.shade200),
                          ),
                          child: Column(
                            children: userAttachments.asMap().entries.map((entry) {
                              final attachment = entry.value;
                              return ListTile(
                                leading: Icon(Icons.attach_file, color: Colors.blue),
                                title: Text(
                                  attachment.fileName,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  ),
                                ),
                                subtitle: mySubmission?.submittedAt != null 
                                    ? Text(
                                        'Enviado em: ${DateFormat('dd/MM/yyyy HH:mm').format(mySubmission!.submittedAt)}',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 12,
                                        ),
                                      )
                                    : null,
                                trailing: mySubmission == null 
                                    ? IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _removeAttachment(entry.key),
                                      )
                                    : Icon(Icons.check_circle, color: Colors.green),
                              );
                            }).toList(),
                          ),
                        ),
                        SizedBox(height: 16),
                      ],

                      // File picker container
                      if (mySubmission == null) ...[
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
                                  icon: isPickingFiles 
                                      ? SizedBox(
                                          width: 24,
                                          height: 24,
                                          child: CircularProgressIndicator(strokeWidth: 2),
                                        )
                                      : Icon(
                                          Icons.add,
                                          size: 40,
                                          color: Colors.grey,
                                        ),
                                  onPressed: isPickingFiles ? null : _pickFiles,
                                ),
                                Text(
                                  isPickingFiles ? 'Anexando arquivos...' : 'Adicionar anexo',
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
                      ] else ...[
                        Text(
                          'Tarefa já foi entregue. Para fazer alterações, entre em contato com o professor.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ],
                      SizedBox(height: 30),
                      if (mySubmission == null) ...[
                        AbsorbPointer(
                          absorbing: isSubmissionLoading || userAttachments.isEmpty,
                          child: Opacity(
                            opacity: isSubmissionLoading || userAttachments.isEmpty ? 0.6 : 1.0,
                            child: Button(
                              backgroundColor: course!.colorAsFlutterColor,
                              text: isSubmissionLoading ? 'Enviando...' : 'Enviar Tarefa',
                              onPressed: () => _submitAssignment(),
                            ),
                          ),
                        ),
                        if (userAttachments.isEmpty)
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              'Adicione pelo menos um arquivo para enviar a tarefa.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.orange.shade700,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          ),
                      ] else ...[
                        Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 16),
                          decoration: BoxDecoration(
                            color: Colors.green.shade100,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: Colors.green.shade300),
                          ),
                          child: Column(
                            children: [
                              Icon(Icons.check_circle, color: Colors.green.shade700, size: 32),
                              SizedBox(height: 8),
                              Text(
                                'Tarefa Entregue com Sucesso!',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.green.shade700,
                                  fontSize: 16,
                                ),
                              ),
                              Text(
                                mySubmission!.isGraded 
                                    ? 'Sua tarefa foi avaliada pelo professor.'
                                    : 'Aguarde a correção do professor.',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  color: Colors.green.shade600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
