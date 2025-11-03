import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/create_assignment_screen.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/profile_screen.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});

  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String selectedCourse = 'Matemática';
  final coursesController = Courses();
  final noticesController = Notices();
  final assignmentsController = Assignments();

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    var courses = coursesController.getCourseByName(selectedCourse);
    var notices = noticesController.getNoticesForCourse(selectedCourse);
    var assignments = assignmentsController.getAssignmentsForCourse(
      courses!.name,
    );

    var color = courses.color;
    var accentColor = courses.accentColor;

    return Scaffold(
      backgroundColor: Colors.white,
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
                            "Boas-vindas João!",
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
                              DropdownMenuEntry<String>(
                                value: 'Matemática',
                                label: 'Matemática',
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuEntry<String>(
                                value: 'Biologia',
                                label: 'Biologia',
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                              DropdownMenuEntry<String>(
                                value: 'História',
                                label: 'História',
                                style: ButtonStyle(
                                  textStyle: WidgetStatePropertyAll(
                                    TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                            onSelected: (String? value) {
                              setState(() {
                                selectedCourse = value!;
                              });
                            },
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
                                  builder: (context) => CreateAssignmentScreen(),
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
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: assignments.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            final assignment = assignments[index];
                            final course = coursesController.getCourseByName(
                              assignment.course,
                            );

                            // ignore: sized_box_for_whitespace
                            return Material(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignmentScreen(
                                        assignment: assignment,
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
                                                    color: course.color,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -12,
                                              right: 8,
                                              child: Icon(
                                                course.icon,
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
                                              assignment.course,
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
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: assignments.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            final assignment = assignments[index];
                            final course = coursesController.getCourseByName(
                              assignment.course,
                            );

                            // ignore: sized_box_for_whitespace
                            return Material(
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => AssignmentScreen(
                                        assignment: assignment,
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
                                                    color: course.color,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: -12,
                                              right: 8,
                                              child: Icon(
                                                course.icon,
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
                                              assignment.course,
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
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                            ),
                                            maxLines: 6,
                                            decoration: InputDecoration(
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
                                            "Atenção: O aviso será publicado imediatamente após a criação.",
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                              fontSize: 12,
                                              color: Colors.grey.shade400,
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
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
                                        onPressed: () {
                                          // Lógica para criar o aviso
                                          Navigator.of(context).pop();
                                        },
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
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: notices.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            final notice = notices[index];
                            final course = coursesController.getCourseByName(
                              notice.course,
                            );

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
                                                  course.icon,
                                                  size: 20,
                                                  color: course.color,
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
                                            notice.content,
                                            style: TextStyle(
                                              fontFamily:
                                                  GoogleFonts.leagueSpartan()
                                                      .fontFamily,
                                              fontSize: 14,
                                            ),
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
                                                      color: course.accentColor,
                                                    ),
                                                    child: Icon(
                                                      course.icon,
                                                      size: 30,
                                                      color: course.color,
                                                    ),
                                                  ),
                                                  SizedBox(width: 16),
                                                  Text(
                                                    course.name,
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
        onTap: (value) {
          switch (value) {
            case 0:
              break;
            case 1:
              break;
            case 2:
              break;
            case 3:
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
          }
        },
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
