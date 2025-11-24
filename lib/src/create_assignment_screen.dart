import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/management_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

class CreateAssignmentScreen extends StatefulWidget {
  const CreateAssignmentScreen({super.key, required this.courseId});
  final int courseId;

  static List<Attachment> ? attachedFiles = [];
  static DateTime ? dueDate;
  static TextEditingController titleController = TextEditingController();
  static TextEditingController descriptionController = TextEditingController();
  static TextEditingController classController = TextEditingController();

  @override
  _CreateAssignmentScreenState createState() => _CreateAssignmentScreenState();
}

class _CreateAssignmentScreenState extends State<CreateAssignmentScreen> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  List<CourseClass> availableClasses = [];
  bool isLoadingClasses = true;
  bool isPickingFiles = false;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadInitialState();
  }

  Future<void> loadInitialState() async {
    try {
      setState(() {
        isLoadingClasses = true;
        errorMessage = null;
      });

      final allClasses = await api.fetchClasses();

      // Filter classes by the current courseId (subjectId)
      final List<CourseClass> filteredClasses = allClasses.where((courseClass) => 
        courseClass.subjectId == widget.courseId
      ).toList();

      print(filteredClasses[0].id);

      setState(() {
        availableClasses = filteredClasses;
        isLoadingClasses = false;
      });
    } catch (e) {
      setState(() {
        errorMessage = e.toString();
        isLoadingClasses = false;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Consider desktop mode for screens wider than 1000px
          if (constraints.maxWidth > 1000) {
            return _buildDesktopLayout(context);
          } else {
            return _buildMobileLayout(context);
          }
        },
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final dividerHeight = size.height * 0.8;

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
            child: _buildCreateAssignmentForm(context, isDesktop: true),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        scrolledUnderElevation: 0.0,
      ),
      body: _buildCreateAssignmentForm(context, isDesktop: false),
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

  Widget _buildCreateAssignmentForm(BuildContext context, {required bool isDesktop}) {
    final w = MediaQuery.of(context).size.width;
    final f = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              // Title + Title Input
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Criar Nova Atividade',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: isDesktop ? 32 : 26,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      child: TextField(
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Título da Atividade',
                          border: OutlineInputBorder(),
                        ),
                        controller: CreateAssignmentScreen.titleController,
                      ),
                    ),
                  ],
                ),
              ),

              // Description
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Descrição',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      child: TextField(
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: isDesktop ? 15 : 20,
                        minLines: isDesktop ? 8 : 10,
                        controller: CreateAssignmentScreen.descriptionController,
                      ),
                    ),
                  ],
                ),
              ),

              // Class
              Container(
                width: w,
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Turma',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    isLoadingClasses 
                      ? SizedBox(
                          child: Container(
                            height: 56,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Center(
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    'Carregando turmas...',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : errorMessage != null
                        ? SizedBox(
                            child: Container(
                              height: 56,
                              decoration: BoxDecoration(
                                border: Border.all(color: Colors.red),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(Icons.error, color: Colors.red),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Erro ao carregar turmas: $errorMessage',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          color: Colors.red,
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: loadInitialState,
                                      child: Text('Tentar novamente'),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        : availableClasses.isEmpty
                          ? SizedBox(
                              child: Container(
                                height: 56,
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Center(
                                  child: Text(
                                    'Nenhuma turma encontrada para esta matéria',
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : DropdownMenu<String>(
                            width: w,
                              dropdownMenuEntries: availableClasses.map((courseClass) => 
                                DropdownMenuEntry(
                                  value: courseClass.id.toString(),
                                  label: courseClass.name,
                                )
                              ).toList(),
                              onSelected: (String? value) {
                                setState(() {
                                  CreateAssignmentScreen.classController.text = value ?? '';
                                });
                              },
                              hintText: 'Selecione uma turma',
                              textStyle: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                  ],
                ),
              ),

              // Attachments
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anexos',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed: isPickingFiles ? null : () async {
                        setState(() {
                          isPickingFiles = true;
                        });

                        try {
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: true,
                            type: FileType.any,
                          );

                          if (result != null && result.files.isNotEmpty) {
                            for (PlatformFile file in result.files) {
                              // Validate file
                              if (file.name.isNotEmpty && file.bytes != null) {
                                setState(() {
                                  CreateAssignmentScreen.attachedFiles ??= [];
                                  CreateAssignmentScreen.attachedFiles!.add(
                                    Attachment(
                                      fileName: file.name,
                                      filePath: file.path ?? '',
                                      fileBytes: file.bytes!,
                                    ),
                                  );
                                });
                              }
                            }

                            _scaffoldMessengerKey.currentState?.showSnackBar(
                              SnackBar(
                                content: Text(
                                  '${result.files.length} arquivo(s) anexado(s) com sucesso!',
                                ),
                                backgroundColor: Colors.green,
                              ),
                            );
                          }
                        } catch (e) {
                          _scaffoldMessengerKey.currentState?.showSnackBar(
                            SnackBar(
                              content: Text('Erro ao anexar arquivo: $e'),
                              backgroundColor: Colors.red,
                            ),
                          );
                        } finally {
                          setState(() {
                            isPickingFiles = false;
                          });
                        }
                      },
                      child: isPickingFiles
                          ? Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(width: 8),
                                Text('Selecionando...'),
                              ],
                            )
                          : Text('Anexar Arquivo'),
                    ),
                    const SizedBox(height: 8),
                    CreateAssignmentScreen.attachedFiles == null || CreateAssignmentScreen.attachedFiles!.isEmpty
                        ? Container(
                            padding: EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(
                                'Nenhum arquivo anexado',
                                style: TextStyle(
                                  color: Colors.grey.shade600,
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                ),
                              ),
                            ),
                          )
                        : Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey.shade300),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Column(
                              children: [
                                ...CreateAssignmentScreen.attachedFiles!.asMap().entries.map((entry) {
                                  final index = entry.key;
                                  final file = entry.value;
                                  return ListTile(
                                    leading: Icon(
                                      Icons.attach_file,
                                      color: Colors.blue,
                                    ),
                                    title: Text(
                                      file.fileName,
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      ),
                                    ),
                                    subtitle: Text(
                                      '${(file.fileBytes.length / 1024).toStringAsFixed(1)} KB',
                                      style: TextStyle(
                                        color: Colors.grey.shade600,
                                        fontSize: 12,
                                      ),
                                    ),
                                    trailing: IconButton(
                                      icon: Icon(Icons.remove_circle, color: Colors.red),
                                      onPressed: () {
                                        setState(() {
                                          CreateAssignmentScreen.attachedFiles!.removeAt(index);
                                        });
                                        _scaffoldMessengerKey.currentState?.showSnackBar(
                                          SnackBar(
                                            content: Text('Arquivo removido'),
                                            backgroundColor: Colors.orange,
                                          ),
                                        );
                                      },
                                    ),
                                  );
                                }),
                              ],
                            ),
                          ),
                  ],
                ),
              ),

              // Due Date
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Data de Entrega',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: isDesktop ? 20 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            CreateAssignmentScreen.dueDate != null
                                ? f.format(CreateAssignmentScreen.dueDate!)
                                : 'Nenhuma data selecionada',
                            style: TextStyle(color: Colors.grey.shade600),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () async {
                            // Implement date picker
                            DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(2000),
                              lastDate: DateTime(2100),
                            );

                            if (pickedDate != null) {
                              setState(() {
                                CreateAssignmentScreen.dueDate = pickedDate;
                              });
                            }
                          },
                          child: Text('Selecionar Data'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // Submit Button
              Center(
                child: Button(
                  text: 'Criar Atividade',
                  onPressed: () {
                    print(CreateAssignmentScreen.classController.text);

                    // Validate form before submitting
                    if (CreateAssignmentScreen.titleController.text.isEmpty) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Por favor, insira um título para a atividade'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (CreateAssignmentScreen.descriptionController.text.isEmpty) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Por favor, insira uma descrição para a atividade'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (CreateAssignmentScreen.classController.text.isEmpty) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Por favor, selecione uma turma'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    if (CreateAssignmentScreen.dueDate == null) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Por favor, selecione uma data de entrega'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    // Get the selected class ID
                    final selectedClassId = int.tryParse(CreateAssignmentScreen.classController.text);
                    print(selectedClassId);
                    if (selectedClassId == null) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Erro: ID da turma inválido'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      // Implement assignment creation logic
                      api.createAssignment(
                        CreateAssignmentScreen.titleController.text,
                        CreateAssignmentScreen.descriptionController.text,
                        CreateAssignmentScreen.dueDate!,
                        selectedClassId,
                        CreateAssignmentScreen.attachedFiles ?? [],
                      );
                      
                      // Show success message
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Atividade criada com sucesso!'),
                          backgroundColor: Colors.green,
                        ),
                      );

                      // Clear the form
                      CreateAssignmentScreen.titleController.clear();
                      CreateAssignmentScreen.descriptionController.clear();
                      CreateAssignmentScreen.classController.clear();
                      CreateAssignmentScreen.dueDate = null;
                      CreateAssignmentScreen.attachedFiles?.clear();
                      
                      // Navigate back
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(
                          builder: (context) => AdminHomeScreen(),
                        ),
                      );
                    } catch (e) {
                      _scaffoldMessengerKey.currentState?.showSnackBar(
                        SnackBar(
                          content: Text('Erro ao criar atividade: $e'),
                          backgroundColor: Colors.red,
                        ),
                      );
                    }
                  },
                  backgroundColor: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
