import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/data/Submissions.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/management_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

// Student Submission class for admin view
class StudentSubmission {
  final int id;
  final int studentId;
  final String studentName;
  final DateTime submissionDate;
  final List<SubmissionAttachment> attachments;
  final double? currentGrade;
  final String? feedback;
  final double maxScore;
  final String status; // 'submitted', 'graded', 'pending'
  
  StudentSubmission({
    required this.id,
    required this.studentId,
    required this.studentName,
    required this.submissionDate,
    required this.attachments,
    this.currentGrade,
    required this.maxScore,
    required this.status,
    this.feedback,
  });
}

class AdminAssignmentScreen extends StatefulWidget {
  const AdminAssignmentScreen({super.key, required this.assignmentId});

  final int assignmentId;

  @override
  _AdminAssignmentScreenState createState() => _AdminAssignmentScreenState();
}

class _AdminAssignmentScreenState extends State<AdminAssignmentScreen> {
  Assignment? assignment;
  List<User> students = [];
  List<StudentSubmission> submissions = [];
  bool isLoading = true;
  String? errorMessage;
  double averageGrade = 0.0;

  @override
  void initState() {
    super.initState();
    _loadAssignmentData();
  }

  Future<void> _loadAssignmentData() async {
    try {
      print('Fetching assignment with ID: ${widget.assignmentId}');
      final fetchedAssignment = await api.fetchAssignmentById(widget.assignmentId);
      print('Fetched assignment: ${fetchedAssignment.title}');

      await _loadStudents();
      await _loadSubmissions();
      await _calculateAverageGrade();
      
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

  Future<void> _loadStudents() async {
    students = await api.fetchStudents();
  }

  Future<void> _loadSubmissions() async {
    final fetchedSubmissions = await api.fetchTaskSubmissions(widget.assignmentId);

    submissions = fetchedSubmissions.map((submission) {
      final student = students.firstWhere((s) => s.id == submission.studentId, orElse: () => User(id: 0, name: 'Unknown', email: '', role: UserRole.STUDENT));

      return StudentSubmission(
        id: submission.id,
        studentId: submission.studentId,
        studentName: student.name,
        submissionDate: submission.submittedAt,
        attachments: submission.attachments ?? [],
        currentGrade: submission.grade,
        maxScore: 10,
        status: submission.isGraded ? 'graded' : 'submitted',
      );
    }).toList();
  }

  Future<void> _calculateAverageGrade() async {
    final gradedSubmissions = submissions.where((s) => s.currentGrade != null).toList();
    if (gradedSubmissions.isNotEmpty) {
      final total = gradedSubmissions.fold<double>(
        0.0, 
        (sum, submission) => sum + (submission.currentGrade ?? 0.0)
      );
      averageGrade = total / gradedSubmissions.length;
    }
  }

  void _showGradingDialog(StudentSubmission submission) {
    final TextEditingController gradeController = TextEditingController(
      text: submission.currentGrade?.toString() ?? ''
    );
    final TextEditingController feedbackController = TextEditingController(
      text: submission.feedback ?? ''
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Avaliar - ${submission.studentName}',
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Nota (máximo: ${submission.maxScore})',
                style: TextStyle(
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
              ),
              SizedBox(height: 8),
              TextField(
                controller: gradeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  hintText: 'Digite a nota',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 8),
              TextField(
                maxLines: 3,
                controller: feedbackController,
                decoration: InputDecoration(
                  hintText: 'Feedback (opcional)',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancelar'),
            ),
            ElevatedButton(
              onPressed: () {
                final grade = double.tryParse(gradeController.text);
                if (grade != null && grade >= 0 && grade <= submission.maxScore) {
                  _updateGrade(submission, grade, feedbackController.text);
                  Navigator.of(context).pop();
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Nota inválida'),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              },
              child: Text('Salvar'),
            ),
          ],
        );
      },
    );
  }

  void _updateGrade(StudentSubmission submission, double grade, String feedback) async {
    await api.gradeSubmission(submission.id, grade, feedback);

    setState(() {
      final index = submissions.indexWhere((s) => s.studentId == submission.studentId);
      if (index != -1) {
        submissions[index] = StudentSubmission(
          id: submission.id,
          studentId: submission.studentId,
          studentName: submission.studentName,
          submissionDate: submission.submissionDate,
          attachments: submission.attachments,
          currentGrade: grade,
          feedback: feedback,
          maxScore: submission.maxScore,
          status: 'graded',
        );
      }
    });
    _calculateAverageGrade();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Nota salva com sucesso!'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Consider desktop mode for screens wider than 1000px
        if (constraints.maxWidth > 1000) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png', width: 40, height: 40),
              UserIconDropdown(radius: 20),
            ],
          ),
        ),
        body: Row(
          children: <Widget>[
            _buildSidebar(context, size),
            _buildDivider(size.height, size),
            Expanded(
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ],
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset('assets/images/logo.png', width: 40, height: 40),
              UserIconDropdown(radius: 20),
            ],
          ),
        ),
        body: Row(
          children: <Widget>[
            _buildSidebar(context, size),
            _buildDivider(size.height, size),
            Expanded(
              child: Center(
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
                        _loadAssignmentData();
                      },
                      child: Text('Tentar novamente'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            UserIconDropdown(radius: 20),
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          _buildSidebar(context, size),
          _buildDivider(size.height, size),
          Expanded(
            child: _buildAdminAssignmentContent(context, isDesktop: true),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Gerenciar atividade',
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (errorMessage != null) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Gerenciar atividade',
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
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
                  _loadAssignmentData();
                },
                child: Text('Tentar novamente'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Administração da Atividade',
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildAdminAssignmentContent(context, isDesktop: false),
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

  Widget _buildSidebar(BuildContext context, Size size) {
    return SizedBox(
      width: size.width * 0.20,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
              selected: false,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => globals.currentUser.role == UserRole.STUDENT ? HomeScreen() : AdminHomeScreen(),
                ));
              },
            ),
            ListTile(
              leading: Icon(Icons.manage_accounts),
              title: Text('Gerenciar'),
              selected: false,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ManagementScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Atividades'),
              selected: true,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectProfessorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double dividerHeight, Size size) {
    return SizedBox(
      width: 20,
      child: Center(
        child: Container(
          width: 1,
          height: dividerHeight > 0 ? dividerHeight : size.height,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildAdminAssignmentContent(BuildContext context, {required bool isDesktop}) {
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');
    final timeFormat = DateFormat('dd/MM/yyyy HH:mm', 'pt_BR');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Assignment Header with Average Grade
              Container(
                padding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              vertical: 4,
                              horizontal: 8,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade700,
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
                              fontSize: isDesktop ? 24 : 20,
                              fontWeight: FontWeight.bold,
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        Text(
                          'Média da Turma',
                          style: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            color: Colors.grey.shade600,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        ),
                        Text(
                          averageGrade > 0 ? '${averageGrade.toStringAsFixed(1)}/10' : 'Sem notas',
                          style: TextStyle(
                            fontSize: isDesktop ? 28 : 24,
                            fontWeight: FontWeight.bold,
                            color: averageGrade >= 7 ? Colors.green.shade700 : 
                                   averageGrade >= 5 ? Colors.orange.shade700 : Colors.red.shade700,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),

              // Assignment Description and Attachments (same as student view)
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descrição:',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      width: isDesktop ? MediaQuery.of(context).size.width : null,
                      child: Text(
                        assignment!.description,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade800,
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'Anexos da Atividade:',
                      style: TextStyle(
                        fontSize: isDesktop ? 18 : 16,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      ),
                    ),
                    SizedBox(height: 8),
                    SizedBox(
                      height: 100,
                      width: isDesktop ? MediaQuery.of(context).size.width : null,
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
                                    api.downloadFile(attachment.filePath);
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
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Statistics Section
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Estatísticas da Turma:',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      ),
                    ),
                    SizedBox(height: 15),
                    SizedBox(
                      width: isDesktop ? MediaQuery.of(context).size.width : null,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: _buildStatCard('Total de Alunos', submissions.length.toString(), Icons.people, isDesktop),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard('Enviados', submissions.where((s) => s.status != 'pending').length.toString(), Icons.assignment_turned_in, isDesktop),
                          ),
                          SizedBox(width: 8),
                          Expanded(
                            child: _buildStatCard('Avaliados', submissions.where((s) => s.status == 'graded').length.toString(), Icons.grade, isDesktop),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 30),

              // Student Submissions List
              Container(
                padding: EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Envios dos Alunos:',
                      style: TextStyle(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      ),
                    ),
                    SizedBox(height: 15),
                    if (submissions.isEmpty || students.isEmpty)
                      Center(
                        child: Text(
                          'Nenhuma envio disponível.',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.grey.shade800,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        ),
                      )
                    else
                    SizedBox(
                      width: isDesktop ? MediaQuery.of(context).size.width : null,
                      child: ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: submissions.length,
                        itemBuilder: (context, index) {
                          final submission = submissions[index];
                          return Card(
                            margin: EdgeInsets.only(bottom: 12),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: _getStatusColor(submission.status),
                                child: Text(
                                  submission.studentName.substring(0, 1).toUpperCase(),
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              title: Text(
                                submission.studentName,
                                style: TextStyle(
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Enviado em: ${timeFormat.format(submission.submissionDate)}',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      fontSize: 12,
                                    ),
                                  ),
                                  if (submission.attachments.isNotEmpty)
                                    Text(
                                      '${submission.attachments.length} arquivo(s) anexado(s)',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 12,
                                        color: Colors.blue,
                                      ),
                                    ),
                                ],
                              ),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (submission.currentGrade != null)
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: _getGradeColor(submission.currentGrade!, submission.maxScore),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        '${submission.currentGrade!.toStringAsFixed(1)}/${submission.maxScore.toInt()}',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    )
                                  else
                                    Container(
                                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        'Não avaliado',
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ),
                                  SizedBox(width: 8),
                                  IconButton(
                                    icon: Icon(Icons.grade, color: Colors.blue.shade700),
                                    onPressed: () => _showGradingDialog(submission),
                                  ),
                                ],
                              ),
                              onTap: () {
                                // Show submission details
                                _showSubmissionDetails(submission);
                              },
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: Colors.blue.shade700, size: isDesktop ? 28 : 24),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 28 : 24,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.blue.shade700,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 14 : 12,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'graded':
        return Colors.green;
      case 'submitted':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  Color _getGradeColor(double grade, double maxScore) {
    final percentage = (grade / maxScore) * 100;
    if (percentage >= 70) return Colors.green;
    if (percentage >= 50) return Colors.orange;
    return Colors.red;
  }

  void _showSubmissionDetails(StudentSubmission submission) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          height: MediaQuery.of(context).size.height * 0.7,
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Envio - ${submission.studentName}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                'Data de envio: ${DateFormat('dd/MM/yyyy HH:mm').format(submission.submissionDate)}',
                style: TextStyle(
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  color: Colors.grey.shade600,
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Arquivos anexados:',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
              ),
              SizedBox(height: 8),
              Expanded(
                child: ListView.builder(
                  itemCount: submission.attachments.length,
                  itemBuilder: (context, index) {
                    final attachment = submission.attachments[index];
                    return ListTile(
                      leading: Icon(Icons.attach_file),
                      title: Text(
                        attachment.fileName,
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                      trailing: Icon(Icons.download),
                      onTap: () {
                        api.downloadFile(attachment.filePath);
                      },
                    );
                  },
                ),
              ),
              SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                    _showGradingDialog(submission);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                  child: Text(
                    submission.currentGrade != null ? 'Editar Nota' : 'Avaliar envio',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
