import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/create_assignment_screen.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';
import 'package:polieats_frontend/src/widgets/home_screen_scaffold.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String selectedCourse = 'Matemática';

  final noticesController = Notices();
  final assignmentsController = Assignments();

  // Add controllers for the notice form
  final TextEditingController _noticeTitleController = TextEditingController();
  final TextEditingController _noticeContentController = TextEditingController();

  List<Assignment> assignments = [];
  List<Notice> notices = [];
  Course? course;
  bool isLoading = true;

  void onCourseChanged(String? newCourse) {
    if (newCourse != null) {
      setState(() {
        selectedCourse = newCourse;
        course = globals.courseController.getCourseByName(selectedCourse)!;
        notices = noticesController.getNoticesForCourse(selectedCourse);
        isLoading = true;
      });
      _loadAssignments();
    }
  }

  Future<void> _loadAssignments() async {
    if (course != null) {
      try {
        final fetchedAssignments = await assignmentsController.getAssignmentsForCourse(course!.id);
        setState(() {
          assignments = fetchedAssignments;
          isLoading = false;
        });
      } catch (e) {
        setState(() {
          assignments = [];
          isLoading = false;
        });
        print('Error loading assignments: $e');
      }
    }
  }

  Future<void> _createNotice() async {
    final title = _noticeTitleController.text.trim();
    final content = _noticeContentController.text.trim();

    if (title.isEmpty || content.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Por favor, preencha todos os campos'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final newNotice = await api.createNotice(title, content, course!.id);
      
      // Update the notices list
      setState(() {
        notices = noticesController.getNoticesForCourse(selectedCourse);
      });

      // Clear the form
      _noticeTitleController.clear();
      _noticeContentController.clear();

      // Close the dialog
      Navigator.of(context).pop();

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Aviso criado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      // Refresh notices from server
      noticesController.fetchAllNotices();
      setState(() {
        notices = noticesController.getNoticesForCourse(selectedCourse);
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erro ao criar aviso: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  void dispose() {
    _noticeTitleController.dispose();
    _noticeContentController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    course = globals.courseController.getCourseByName('Matemática')!;
    noticesController.fetchAllNotices();
    _loadAssignments();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    var notices = noticesController.getNoticesForCourse(selectedCourse);

    var color = course!.color;
    var accentColor = course!.accentColor;

    return HomeScreenScaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 20,
              children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        spacing: 12,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Boas-vindas ${globals.currentUser.name.split(" ")[0]}!",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          DropdownMenu(
                            label: Text(
                              "Selecione a matéria",
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                            textStyle: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                            ),
                            enableSearch: false,
                            initialSelection: selectedCourse,
                            dropdownMenuEntries: <DropdownMenuEntry<String>>[
                              for (var course in globals.courseController.allCourses)
                                DropdownMenuEntry<String>(
                                  value: course.name,
                                  label: course.name,
                                ),
                            ],
                            onSelected: onCourseChanged,
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          gradient: RadialGradient(
                            colors: [Colors.blueAccent, Colors.blue],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.white,
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                        child: CircleAvatar(
                          radius: 30,
                          backgroundColor: Colors.transparent,
                          child: Icon(
                            Icons.person,
                            size: 30,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Atividades pendentes",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      CreateAssignmentScreen(
                                        courseId: course!.id,
                                      ),
                                ),
                              );
                            },
                            icon: Icon(Icons.add, color: color),
                            style: IconButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: isLoading 
                          ? Center(
                              child: CircularProgressIndicator(color: color),
                            )
                          : assignments.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.assignment_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Nenhuma atividade pendente",
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "Crie uma nova atividade usando o botão +",
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: assignments.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final assignment = assignments[index];
                                    
                                    // ignore: sized_box_for_whitespace
                                    return Material(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AssignmentScreen(
                                                assignmentId: assignment.id!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: size.width * 0.60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: Colors.grey.shade50,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: course!.color,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                  ),
                                                ),
                                                child: Stack(
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
                                                          color: Colors.white70,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(20),
                                                              ),
                                                        ),
                                                        child: Text(
                                                          f.format(assignment.dueDate),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts.leagueSpartan()
                                                                    .fontFamily,
                                                            fontSize: 12,
                                                            color: course!.color,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: -12,
                                                      right: 8,
                                                      child: Icon(
                                                        iconMap[course!.name] ?? Icons.help,
                                                        size: 64,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      assignment.title,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.leagueSpartan()
                                                                .fontFamily,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      course!.name,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.leagueSpartan()
                                                                .fontFamily,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Atividades avaliadas",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Ver todas",
                              style: TextStyle(
                                fontFamily:
                                    GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: isLoading 
                          ? Center(
                              child: CircularProgressIndicator(color: color),
                            )
                          : assignments.isEmpty
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.grade_outlined,
                                        size: 48,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Nenhuma atividade avaliada",
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "As atividades aparecerão aqui após serem corrigidas",
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 12,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  physics: BouncingScrollPhysics(),
                                  itemCount: assignments.length,
                                  separatorBuilder: (context, index) {
                                    return SizedBox(width: 10);
                                  },
                                  itemBuilder: (context, index) {
                                    final assignment = assignments[index];

                                    // ignore: sized_box_for_whitespace
                                    return Material(
                                      child: InkWell(
                                        onTap: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => AssignmentScreen(
                                                assignmentId: assignment.id!,
                                              ),
                                            ),
                                          );
                                        },
                                        child: Container(
                                          width: size.width * 0.60,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.all(
                                              Radius.circular(10),
                                            ),
                                            color: Colors.grey.shade50,
                                          ),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                height: 100,
                                                decoration: BoxDecoration(
                                                  color: course!.color,
                                                  borderRadius: BorderRadius.only(
                                                    topLeft: Radius.circular(10),
                                                    topRight: Radius.circular(10),
                                                  ),
                                                ),
                                                child: Stack(
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
                                                          color: Colors.white70,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                Radius.circular(20),
                                                              ),
                                                        ),
                                                        child: Text(
                                                          f.format(assignment.dueDate),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts.leagueSpartan()
                                                                    .fontFamily,
                                                            fontSize: 12,
                                                            color: course!.color,
                                                            fontWeight: FontWeight.bold,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Positioned(
                                                      bottom: -12,
                                                      right: 8,
                                                      child: Icon(
                                                        iconMap[course!.name] ?? Icons.help,
                                                        size: 64,
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Container(
                                                padding: EdgeInsets.only(left: 10),
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      assignment.title,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.leagueSpartan()
                                                                .fontFamily,
                                                        fontSize: 14,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                    Text(
                                                      course!.name,
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.leagueSpartan()
                                                                .fontFamily,
                                                        fontSize: 12,
                                                        color: Colors.grey,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    },
                                  ),
                                ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Quadro de avisos",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // Open a modal to create a new notice
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    insetPadding: EdgeInsets.symmetric(
                                      horizontal:
                                          MediaQuery.of(context).size.width *
                                          0.05,
                                      vertical: 24,
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(10),
                                      ),
                                    ),
                                    contentPadding: EdgeInsets.all(32),
                                    backgroundColor: Colors.white,
                                    title: Text(
                                      "Criar novo aviso",
                                      style: TextStyle(
                                        color: Colors.black,
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                      ),
                                    ),
                                    // Make the dialog wider by constraining the content width
                                    content: SizedBox(
                                      width:
                                          MediaQuery.of(context).size.width *
                                          0.8,
                                      child: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller: _noticeTitleController,
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                            ),
                                            decoration: InputDecoration(
                                              labelText: "Título",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              hintText:
                                                  "Digite o título do aviso",
                                            ),
                                          ),
                                          SizedBox(height: 24),
                                          TextField(
                                            controller: _noticeContentController,
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                            ),
                                            maxLines: 6,
                                            decoration: InputDecoration(
                                              labelText: "Conteúdo",
                                              contentPadding:
                                                  EdgeInsets.symmetric(
                                                    horizontal: 12,
                                                    vertical: 8,
                                                  ),
                                              hintText:
                                                  "Digite o conteúdo do aviso",
                                            ),
                                          ),
                                          SizedBox(height: 12),
                                          Text(
                                            "Atenção: O aviso será publicado imediatamente após a criação para a matéria: ${course!.name}",
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          // Clear the form and close dialog
                                          _noticeTitleController.clear();
                                          _noticeContentController.clear();
                                          Navigator.of(context).pop();
                                        },
                                        child: Text(
                                          "Cancelar",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily:
                                                GoogleFonts.leagueSpartan()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                        onPressed: _createNotice,
                                        child: Text(
                                          "Criar",
                                          style: TextStyle(
                                            color: color,
                                            fontFamily:
                                                GoogleFonts.leagueSpartan()
                                                    .fontFamily,
                                          ),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                            icon: Icon(Icons.add, color: color),
                            style: IconButton.styleFrom(
                              backgroundColor: accentColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: notices.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.campaign_outlined,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(height: 8),
                                    Text(
                                      "Nenhum aviso publicado",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "Publique um novo aviso usando o botão +",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 12,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : ListView.separated(
                                scrollDirection: Axis.horizontal,
                                physics: BouncingScrollPhysics(),
                                itemCount: notices.length,
                                separatorBuilder: (context, index) {
                                  return SizedBox(width: 10);
                                },
                                itemBuilder: (context, index) {
                                  final notice = notices[index];

                                  // ignore: sized_box_for_whitespace
                                  return GestureDetector(
                                    child: Container(
                                      width: size.width * 0.60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(10),
                                        ),
                                        color: Colors.grey.shade50,
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(12.0),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Container(
                                                      width: 30,
                                                      height: 30,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius.all(
                                                              Radius.circular(1000),
                                                            ),
                                                        color: course!.accentColor,
                                                      ),
                                                      child: Icon(
                                                        iconMap[course!.name] ?? Icons.help,
                                                        size: 20,
                                                        color: course!.color,
                                                      ),
                                                    ),
                                                    Text(
                                                      f.format(notice.date),
                                                      style: TextStyle(
                                                        fontFamily:
                                                            GoogleFonts.leagueSpartan()
                                                                .fontFamily,
                                                        fontSize: 12,
                                                        color: Colors.grey.shade700,
                                                        fontWeight: FontWeight.bold,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 12),
                                                Text(
                                                  notice.title,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.leagueSpartan()
                                                            .fontFamily,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 4),
                                                Text(
                                                  notice.content.length > 100 
                                                    ? '${notice.content.substring(0, 100)}...'
                                                    : notice.content,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.leagueSpartan()
                                                            .fontFamily,
                                                    fontSize: 14,
                                                  ),
                                                  maxLines: 3,
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    onTap: () {
                                      showModalBottomSheet(
                                        isScrollControlled: true,
                                        context: context,
                                        builder: (context) {
                                          return Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius: BorderRadius.vertical(
                                                top: Radius.circular(16),
                                              ),
                                            ),
                                            height:
                                                MediaQuery.of(context).size.height *
                                                0.95,
                                            padding: EdgeInsets.all(16),
                                            child: Column(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Row(
                                                      children: [
                                                        Container(
                                                          width: 40,
                                                          height: 40,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    1000,
                                                                  ),
                                                                ),
                                                            color: course!.accentColor,
                                                          ),
                                                          child: Icon(
                                                            iconMap[course!.name] ?? Icons.help,
                                                            size: 30,
                                                            color: course!.color,
                                                          ),
                                                        ),
                                                        SizedBox(width: 16),
                                                        Text(
                                                          course!.name,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts.leagueSpartan()
                                                                    .fontFamily,
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                    IconButton(
                                                      icon: Icon(Icons.close),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  notice.title,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.leagueSpartan()
                                                            .fontFamily,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                SizedBox(height: 10),
                                                Text(
                                                  'Publicado em: ${f.format(notice.date)},\npor ${notice.owner}',
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.leagueSpartan()
                                                            .fontFamily,
                                                    fontSize: 14,
                                                    color: Colors.grey.shade700,
                                                  ),
                                                ),
                                                SizedBox(height: 20),
                                                Text(
                                                  notice.content,
                                                  style: TextStyle(
                                                    fontFamily:
                                                        GoogleFonts.leagueSpartan()
                                                            .fontFamily,
                                                    fontSize: 16,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          );
                                        },
                                      );
                                    },
                                  );
                                },
                              ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}