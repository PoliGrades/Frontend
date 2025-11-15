import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/widgets/button.dart';

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
  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    final f = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, scrolledUnderElevation: 0.0,),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
                          fontSize: 26,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Título da Atividade',
                          border: OutlineInputBorder(),
                        ),
                        controller: CreateAssignmentScreen.titleController,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextField(
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        ),
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 20,
                        minLines: 10,
                        controller:
                            CreateAssignmentScreen.descriptionController,
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      DropdownMenu(dropdownMenuEntries: const [
                        DropdownMenuEntry(value: 'turma1', label: 'Turma 1'),
                        DropdownMenuEntry(value: 'turma2', label: 'Turma 2'),
                      ], width: w, controller: CreateAssignmentScreen.classController,),
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
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () async {
                          await FilePicker.platform.pickFiles(allowMultiple: true).then((value) {
                            if (value != null) {
                              List files = value.files;

                              for (PlatformFile file in files) {
                                print(file.name);
                                print(file.bytes);
                                print(file.size);
                                print(file.extension);
                                print(file.path);

                                // file.path is a blob URL in web, need to convert to File
                                if (file.path != null) {
                                  setState(() {
                                    CreateAssignmentScreen.attachedFiles!.add(Attachment(fileName: file.name, filePath: file.path!, fileBytes: file.bytes ?? List.empty()));
                                  });
                                }
                              }
                            }
                            return null;
                          });
                        },
                        child: Text('Anexar Arquivo'),
                      ),
                      const SizedBox(height: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: CreateAssignmentScreen.attachedFiles != null
                            ? CreateAssignmentScreen.attachedFiles!.map((file) => Text(file.fileName, style: TextStyle(color: Colors.grey.shade600))).toList()
                            : [Text('Nenhum arquivo anexado')],
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
                          fontSize: 18,
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
                      // Implement assignment creation logic
                      api.createAssignment(
                        CreateAssignmentScreen.titleController.text,
                        CreateAssignmentScreen.descriptionController.text,
                        CreateAssignmentScreen.dueDate ?? DateTime.now(),
                          widget.courseId,
                        CreateAssignmentScreen.attachedFiles!,
                      );
                    },
                    backgroundColor: Colors.blue,
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
