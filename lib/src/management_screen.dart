import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/chat_screen.dart';
import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

class ManagementScreen extends StatefulWidget {
  const ManagementScreen({super.key});

  @override
  State<ManagementScreen> createState() => _ManagementScreenState();
}

class _ManagementScreenState extends State<ManagementScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // Controllers for forms
  final _subjectNameController = TextEditingController();
  final _subjectDescriptionController = TextEditingController();
  final _subjectColorController = TextEditingController();
  final _subjectAccentColorController = TextEditingController();

  final _classNameController = TextEditingController();

  final _studentNameController = TextEditingController();
  final _studentEmailController = TextEditingController();
  final _studentPasswordController = TextEditingController();

  List<Course> subjects = [];
  List<User> students = [];
  List<CourseClass> classes = [];
  String? selectedSubjectId;
  String? selectedClassId;
  String? selectedStudentId;

  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _subjectNameController.dispose();
    _subjectDescriptionController.dispose();
    _subjectColorController.dispose();
    _subjectAccentColorController.dispose();
    _classNameController.dispose();
    _studentNameController.dispose();
    _studentEmailController.dispose();
    _studentPasswordController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() => isLoading = true);
    try {
      // Load existing data
      subjects = globals.courseController.allSubjects;
      students = await api.fetchStudents();
      classes = await api.fetchClasses();
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _createSubject() async {
    final name = _subjectNameController.text.trim();
    final description = _subjectDescriptionController.text.trim();
    final color = _subjectColorController.text.trim();
    final accentColor = _subjectAccentColorController.text.trim();

    if (name.isEmpty || description.isEmpty) {
      _showErrorMessage('Por favor, preencha todos os campos obrigatórios');
      return;
    }

    try {
      setState(() => isLoading = true);

      await api.createSubject(name, description, color, accentColor);

      final updateCourses = await api.fetchCourses();

      globals.courseController.setSubjects(updateCourses);

      _showSuccessMessage('Matéria criada com sucesso!');
      _clearSubjectForm();
      await _loadData();
    } catch (e) {
      _showErrorMessage('Erro ao criar matéria: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _createClass() async {
    final name = _classNameController.text.trim();

    if (name.isEmpty || selectedSubjectId == null) {
      _showErrorMessage(
        'Por favor, preencha todos os campos e selecione uma matéria',
      );
      return;
    }

    try {
      setState(() => isLoading = true);

      await api.createClass(name, int.parse(selectedSubjectId!));

      _showSuccessMessage('Turma criada com sucesso!');
      _clearClassForm();
      await _loadData();
    } catch (e) {
      _showErrorMessage('Erro ao criar turma: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _createStudent() async {
    final name = _studentNameController.text.trim();
    final email = _studentEmailController.text.trim();
    final password = _studentPasswordController.text.trim();

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      _showErrorMessage('Por favor, preencha todos os campos');
      return;
    }

    if (!_isValidEmail(email)) {
      _showErrorMessage('Por favor, insira um email válido');
      return;
    }

    try {
      setState(() => isLoading = true);

      await api.createStudent(name, email, password);

      _showSuccessMessage('Estudante criado com sucesso!');
      _clearStudentForm();
      await _loadData();
    } catch (e) {
      _showErrorMessage('Erro ao criar estudante: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  Future<void> _enrollStudent() async {
    if (selectedStudentId == null || selectedClassId == null) {
      _showErrorMessage('Por favor, selecione um estudante e uma turma');
      return;
    }

    try {
      setState(() => isLoading = true);

      await api.enrollStudent(
        int.parse(selectedStudentId!),
        int.parse(selectedClassId!),
      );

      _showSuccessMessage('Estudante matriculado com sucesso!');
    } catch (e) {
      _showErrorMessage('Erro ao matricular estudante: $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _clearSubjectForm() {
    _subjectNameController.clear();
    _subjectDescriptionController.clear();
    _subjectColorController.clear();
  }

  void _clearClassForm() {
    _classNameController.clear();
    selectedSubjectId = null;
  }

  void _clearStudentForm() {
    _studentNameController.clear();
    _studentEmailController.clear();
    _studentPasswordController.clear();
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  void _showSuccessMessage(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  void _showErrorMessage(String message) {
    _scaffoldMessengerKey.currentState?.showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return _buildDesktopLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Text(
              'Gerenciamento',
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontWeight: FontWeight.bold,
              ),
            ),
            backgroundColor: Colors.white,
            elevation: 0,
            automaticallyImplyLeading: false,
            bottom: TabBar(
              controller: _tabController,
              labelStyle: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              unselectedLabelStyle: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontSize: 14,
              ),
              tabs: const [
                Tab(text: 'Matérias'),
                Tab(text: 'Turmas'),
                Tab(text: 'Alunos'),
                Tab(text: 'Matrículas'),
              ],
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              _buildSubjectsTab(),
              _buildClassesTab(),
              _buildStudentsTab(),
              _buildEnrollmentTab(),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final dividerHeight = size.height - appBarHeight;

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
          // Lateral menu
          SizedBox(
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
                        selected: true,
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
                              builder: (context) => ChatScreen(professorID: 1234),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: 20,
                child: Center(
                  child: Container(
                    width: 1,
                    height: dividerHeight > 0 ? dividerHeight : size.height,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
          // Main content
          Expanded(
            child: Column(
              children: [
                // Tab bar
                Container(
                  color: Colors.white,
                  child: TabBar(
                    controller: _tabController,
                    labelStyle: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 14,
                    ),
                    tabs: const [
                      Tab(text: 'Matérias'),
                      Tab(text: 'Turmas'),
                      Tab(text: 'Alunos'),
                      Tab(text: 'Matrículas'),
                    ],
                  ),
                ),
                // Tab content
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _buildSubjectsTab(),
                      _buildClassesTab(),
                      _buildStudentsTab(),
                      _buildEnrollmentTab(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BottomNavigationBar _buildBottomNavigationBar(BuildContext context) {
    return BottomNavigationBar(
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
      currentIndex: 1, // Management tab
      onTap: (value) {
        switch (value) {
          case 0:
            Navigator.pop(context);
            break;
          case 1:
            // Current screen
            break;
          case 2:
            // Activities - you can add navigation here
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfileScreen()),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(professorID: 1234),
              ),
            );
            break;
        }
      },
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
        BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Gerenciar'),
        BottomNavigationBarItem(
          icon: Icon(Icons.assignment),
          label: 'Atividades',
        ),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
      ],
    );
  }

  Widget _buildSubjectsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criar Nova Matéria',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  controller: _subjectNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Matéria *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Ex: Matemática',
                    prefixIcon: Icon(Icons.school, color: Colors.blue),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subjectDescriptionController,
                  decoration: InputDecoration(
                    labelText: 'Descrição *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Descrição da matéria',
                    prefixIcon: Icon(Icons.description, color: Colors.blue),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subjectColorController,
                  decoration: InputDecoration(
                    labelText: 'Cor (Hexadecimal)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Ex: FF5722',
                    prefixText: '#',
                    prefixIcon: Icon(Icons.palette, color: Colors.blue),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _subjectAccentColorController,
                  decoration: InputDecoration(
                    labelText: 'Cor de Destaque (Hexadecimal)',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.blue, width: 2),
                    ),
                    hintText: 'Ex: FF4081',
                    prefixText: '#',
                    prefixIcon: Icon(Icons.color_lens, color: Colors.blue),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _createSubject,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Criar Matéria',
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Matérias Existentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          subjects.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(48.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.school_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma matéria encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crie uma nova matéria usando o formulário acima',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: subjects.map((subject) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: subject.accentColorAsFlutterColor,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.school,
                              color: subject.colorAsFlutterColor,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  subject.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  subject.description,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey.shade600,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Editar',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Excluir',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildClassesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criar Nova Turma',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  controller: _classNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome da Turma *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    hintText: 'Ex: Matemática - Turma A',
                    prefixIcon: Icon(Icons.class_, color: Colors.green),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedSubjectId,
                  decoration: InputDecoration(
                    labelText: 'Selecione a Matéria *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.green, width: 2),
                    ),
                    prefixIcon: Icon(Icons.school, color: Colors.green),
                  ),
                  items: subjects.map((subject) {
                    return DropdownMenuItem<String>(
                      value: subject.id.toString(),
                      child: Text(
                        subject.name,
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedSubjectId = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _createClass,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Criar Turma',
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Turmas Existentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          classes.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(48.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.class_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhuma turma encontrada',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crie uma nova turma usando o formulário acima',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: classes.map((classItem) {
                    final subject = subjects.firstWhere(
                      (s) => s.id == classItem.subjectId,
                      orElse: () => Course(
                        id: 0,
                        name: 'Desconhecida',
                        description: '',
                        color: Colors.grey.toString(),
                        accentColor: Colors.grey.toString(),
                      ),
                    );
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.class_,
                              color: Colors.green,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  classItem.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  'Matéria: ${subject.name}',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 14,
                                    color: Colors.green.shade700,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey.shade600,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'view',
                                child: Row(
                                  children: [
                                    Icon(Icons.visibility, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Ver Estudantes',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.orange),
                                    SizedBox(width: 8),
                                    Text(
                                      'Editar',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Excluir',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildStudentsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Criar Novo Aluno',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                TextField(
                  controller: _studentNameController,
                  decoration: InputDecoration(
                    labelText: 'Nome Completo *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    hintText: 'Ex: João Silva',
                    prefixIcon: Icon(Icons.person, color: Colors.orange),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _studentEmailController,
                  decoration: InputDecoration(
                    labelText: 'Email *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    hintText: 'Ex: joao@p4ed.com.br',
                    prefixIcon: Icon(Icons.email, color: Colors.orange),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _studentPasswordController,
                  decoration: InputDecoration(
                    labelText: 'Senha *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.orange, width: 2),
                    ),
                    hintText: 'Senha inicial do aluno',
                    prefixIcon: Icon(Icons.lock, color: Colors.orange),
                  ),
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                  obscureText: true,
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _createStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.orange,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Criar Estudante',
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Alunos Existentes',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          students.isEmpty
              ? Container(
                  padding: const EdgeInsets.all(48.0),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Center(
                    child: Column(
                      children: [
                        Icon(
                          Icons.people_outlined,
                          size: 64,
                          color: Colors.grey.shade400,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Nenhum aluno encontrado',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey.shade600,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Crie um novo aluno usando o formulário acima',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade500,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                )
              : Column(
                  children: students.map((student) {
                    return Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade200),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade100,
                            blurRadius: 8,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(
                              Icons.person,
                              color: Colors.orange,
                              size: 24,
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  student.name,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  student.email,
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    color: Colors.grey.shade600,
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          PopupMenuButton(
                            icon: Icon(
                              Icons.more_vert,
                              color: Colors.grey.shade600,
                            ),
                            itemBuilder: (context) => [
                              PopupMenuItem(
                                value: 'edit',
                                child: Row(
                                  children: [
                                    Icon(Icons.edit, color: Colors.blue),
                                    SizedBox(width: 8),
                                    Text(
                                      'Editar',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              PopupMenuItem(
                                value: 'delete',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text(
                                      'Excluir',
                                      style: TextStyle(
                                        color: Colors.red,
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
        ],
      ),
    );
  }

  Widget _buildEnrollmentTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Matricular Estudante',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 20),
          Container(
            padding: EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.shade100,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            width: double.infinity,
            child: Column(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: selectedStudentId,
                  decoration: InputDecoration(
                    labelText: 'Selecione o Estudante *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.person, color: Colors.purple),
                  ),
                  items: students.map((student) {
                    return DropdownMenuItem<String>(
                      value: student.id.toString(),
                      child: Text(
                        '${student.name} (${student.email})',
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedStudentId = value;
                    });
                  },
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: selectedClassId,
                  decoration: InputDecoration(
                    labelText: 'Selecione a Turma *',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.purple, width: 2),
                    ),
                    prefixIcon: Icon(Icons.class_, color: Colors.purple),
                  ),
                  items: classes.map((classItem) {
                    // Find the subject name for this class
                    final subject = subjects.firstWhere(
                      (s) => s.id.toString() == classItem.subjectId,
                      orElse: () => Course(
                        id: 0,
                        name: 'Unknown',
                        description: '',
                        color: Colors.grey.toString(),
                        accentColor: Colors.grey.toString(),
                      ),
                    );
                    return DropdownMenuItem<String>(
                      value: classItem.id.toString(),
                      child: Text(
                        '${classItem.name} (${subject.name})',
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      selectedClassId = value;
                    });
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: isLoading ? null : _enrollStudent,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 2,
                    ),
                    child: isLoading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : Text(
                            'Matricular Estudante',
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 32),
          Text(
            'Matrículas Ativas',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.black87,
            ),
          ),
          SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(48.0),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
            ),
            child: Center(
              child: Column(
                children: [
                  Icon(
                    Icons.assignment_ind_outlined,
                    size: 64,
                    color: Colors.grey.shade400,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Nenhuma matrícula encontrada',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'As matrículas aparecerão aqui após serem criadas',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey.shade500,
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
