import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/assignment_overview_screen.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/chat_screen.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/course_screen.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/widgets/components/no_courses_state.dart';
import 'package:polieats_frontend/src/widgets/components/user_header.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:polieats_frontend/src/notices_overview_screen.dart';

import '../main.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final noticesController = Notices();
  final assignmentsController = Assignments();

  List<Assignment> assignments = [];
  List<Notice> notices = [];
  bool isDataLoading = true;
  bool hasNoCourses = false;

  Future<void> _loadInitialData() async {
    setState(() {
      isDataLoading = true;
      hasNoCourses = false;
    });

    try {
      // Load courses from API
      final fetchedCourses = await api.fetchCourses();
      globals.courseController.setSubjects(fetchedCourses);

      final fetchedClasses = await api.fetchClasses();
      globals.classController.setClasses(fetchedClasses);
      
      // Check if user has no courses
      if (globals.courseController.allSubjects.isEmpty) {
        setState(() {
          hasNoCourses = true;
          isDataLoading = false;
        });
        return;
      }

      // Load notices for all courses
      globals.noticesController.fetchAllNotices();
      
      // Load assignments
      final fetchedAssignments = await api.fetchAllTasks();
      globals.tasksController.setTasks(fetchedAssignments);
      assignments = globals.tasksController.allTasks;

      print('Fetched ${assignments.length} assignments.');

      notices = globals.noticesController.allNotices;

      setState(() {
        isDataLoading = false;
      });
      
    } catch (e) {
      setState(() {
        isDataLoading = false;
        hasNoCourses = globals.courseController.allSubjects.isEmpty;
      });
      print('Error loading initial data: $e');
      
      // Show error message to user
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao carregar dados: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    // Show loading screen while fetching initial data
    if (isDataLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "Carregando dados...",
                style: TextStyle(
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopHomeScreen(
              assignments: assignments,
              notices: notices,
              hasNoCourses: hasNoCourses,
              onReloadData: _loadInitialData,
            );
          } else {
            return MobileHomeScreen(
              assignments: assignments,
              notices: notices,
              hasNoCourses: hasNoCourses,
              onReloadData: _loadInitialData,
            );
          }
        },
      ),
    );
  }
}

class MobileHomeScreen extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Notice> notices;
  final bool hasNoCourses;
  final VoidCallback onReloadData;

  const MobileHomeScreen({
    super.key,
    required this.assignments,
    required this.notices,
    required this.hasNoCourses,
    required this.onReloadData,
  });

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    final courses = globals.courseController.allSubjects;

    // Show no courses screen
    if (hasNoCourses) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: NoCoursesState(
            hasNoCourses: hasNoCourses,
            onCreateCourse: () {
              // For student version, they can't create courses, so we just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Entre em contato com um professor para ser matriculado em uma matéria.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            onRefresh: onReloadData,
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
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => CourseOverviewScreen()));
                break;
              case 2:
                break;
              case 3:
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
                break;
              case 4:
                Navigator.of(context).push(MaterialPageRoute(builder: (context) => ChatScreen(professorID: 1234,)));
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
            BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
          ],
        ),
      );
    }

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
                UserHeader(
                  userName: globals.currentUser.name,
                  isAdmin: false,
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Minhas matérias",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push( context, MaterialPageRoute(
                                builder: (context) => CourseOverviewScreen(),
                              ),
                            );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
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
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      courses.isEmpty
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.school_outlined,
                                    size: 48,
                                    color: Colors.grey.shade400,
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Nenhuma matéria encontrada",
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      fontSize: 16,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                  Text(
                                    "Suas matérias aparecerão aqui",
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      fontSize: 12,
                                      color: Colors.grey.shade400,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : GridView.builder(
                              shrinkWrap: true,
                              itemCount: courses.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                                childAspectRatio: 1,
                              ),
                              itemBuilder: (context, index) {
                                final course = courses[index];
                                return Material(
                                  color: Colors.grey.shade50,
                                  borderRadius: BorderRadius.all(Radius.circular(10)),
                                  child: InkWell(
                                    onTap: () {
                                      // Go to the specific course page
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CourseScreen(course: course),
                                        ),
                                      );
                                    },
                                    child: SizedBox(
                                      // Adjust to max height
                                      height: 150,
                                      width: size.width * 0.3,
                                      child: Center(
                                        child: Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.all(
                                                  Radius.circular(1000),
                                                ),
                                                color: course.accentColorAsFlutterColor,
                                              ),
                                              child: Icon(
                                                iconMap[course.name] ?? Icons.help,
                                                size: 30,
                                                color: course.colorAsFlutterColor,
                                              ),
                                            ),
                                            SizedBox(height: 10),
                                            Text(
                                              course.name,
                                              style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.leagueSpartan()
                                                        .fontFamily,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
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
                    spacing: 20,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Últimas atividades",
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push( context, MaterialPageRoute(
                                builder: (context) => AssignmentOverviewScreen(),
                              ),
                            );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Ver todas",
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: assignments.isEmpty
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
                                      "Nenhuma atividade encontrada",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "Suas atividades aparecerão aqui",
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
                                  final classCourse = globals.classController.getClassById(
                                    assignment.classId
                                  );
                                  final course = globals.courseController.getSubjectById(
                                    classCourse?.subjectId ?? -1,
                                  );

                                  // Skip this assignment if course is not found
                                  if (course == null) {
                                    return SizedBox.shrink();
                                  }

                                  return Material(
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => AssignmentScreen(
                                              assignmentId: assignment.id,
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
                                                color: course.colorAsFlutterColor,
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
                                                          color: course.colorAsFlutterColor,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Positioned(
                                                    bottom: -12,
                                                    right: 8,
                                                    child: Icon(
                                                      iconMap[course.name] ?? Icons.help,
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
                                                    course.name,
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
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => NoticesOverviewScreen(),
                                ),
                              );
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Ver todos",
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue,
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
                                      "Nenhum aviso encontrado",
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 16,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      "Seus avisos aparecerão aqui",
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
                                  final Notice notice = notices[index];
                                  final course = globals.courseController.getSubjectByName(
                                    notice.course,
                                  );

                                  // Skip this notice if course is not found
                                  if (course == null) {
                                    return SizedBox.shrink();
                                  }

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
                                                        color: course.accentColorAsFlutterColor,
                                                      ),
                                                      child: Icon(
                                                        iconMap[course.name] ?? Icons.help,
                                                        size: 20,
                                                        color: course.colorAsFlutterColor,
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
                                                            color: course.accentColorAsFlutterColor,
                                                          ),
                                                          child: Icon(
                                                            iconMap[course.name] ?? Icons.help,
                                                            size: 30,
                                                            color: course.colorAsFlutterColor,
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
              Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (context) => CourseOverviewScreen()));
              break;
            case 2:
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => AssignmentOverviewScreen()));
              break;
            case 3:
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ProfileScreen()));
              break;
            case 4:
              Navigator.of(
                context,
              ).push(MaterialPageRoute(builder: (context) => ChatScreen(professorID: 1234,)));
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
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
        ],
      ),
    );
  }
}

class DesktopHomeScreen extends StatelessWidget {
  final List<Assignment> assignments;
  final List<Notice> notices;
  final bool hasNoCourses;
  final VoidCallback onReloadData;

  const DesktopHomeScreen({
    super.key,
    required this.assignments,
    required this.notices,
    required this.hasNoCourses,
    required this.onReloadData,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    final courses = globals.courseController.allSubjects;

    // Show no courses screen
    if (hasNoCourses) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: NoCoursesState(
            hasNoCourses: hasNoCourses,
            onCreateCourse: () {
              // For student version, they can't create courses, so we just show a message
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Entre em contato com um professor para ser matriculado em uma matéria.'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            onRefresh: onReloadData,
          ),
        ),
      );
    }

    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final dividerHeight = size.height - appBarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            UserIconDropdown(radius: 20),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: IntrinsicHeight(
          child: Row(
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
                        selected: true,
                        selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        title: Text('Início'),
                        // Make it rounded
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        onTap: () {
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Matérias'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => CourseOverviewScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('Atividades'),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => AssignmentOverviewScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        //selected: selectedIndex == 3,
                        selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        title: Text('Perfil'),
                        onTap: () {
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
              // Vertical divider that accounts for the AppBar height
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
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem-vindo de volta, ${globals.currentUser.name.split(" ")[0]}!',
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Aqui estão suas matérias e atividades:',
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 18,
                          color: Colors.grey.shade700,
                        ),
                      ),
                      SizedBox(height: 40),
                      // Create two columns, one that takes most of the space and the other that takes around 20/15%
                      Row(
                        spacing: 30,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'Matérias',
                                  style: TextStyle(
                                    fontFamily:
                                        GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 20,
                                  ),
                                ),
                                // Grid of courses
                                SizedBox(
                                  height: 650,
                                  child: courses.isEmpty
                                      ? Center(
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.school_outlined,
                                                size: 64,
                                                color: Colors.grey.shade400,
                                              ),
                                              SizedBox(height: 16),
                                              Text(
                                                "Nenhuma matéria encontrada",
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                                  fontSize: 18,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                              Text(
                                                "Suas matérias aparecerão aqui",
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                                  fontSize: 14,
                                                  color: Colors.grey.shade400,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : GridView.builder(
                                          gridDelegate:
                                              SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 10,
                                                mainAxisSpacing: 10,
                                                childAspectRatio: 1,
                                              ),
                                          itemCount: courses.length,
                                          itemBuilder: (context, index) {
                                            final course = courses[index];

                                            return Material(
                                              color: Colors.grey.shade50,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(10),
                                              ),
                                              child: InkWell(
                                                onTap: () {
                                                  // Go to the specific course page
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          CourseScreen(
                                                            course: course,
                                                          ),
                                                    ),
                                                  );
                                                },
                                                child: SizedBox(
                                                  // Adjust to max height
                                                  height: 200,
                                                  width: size.width * 0.3,
                                                  child: Center(
                                                    child: Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment.center,
                                                      children: [
                                                        Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius.all(
                                                                  Radius.circular(
                                                                    1000,
                                                                  ),
                                                                ),
                                                            color: course.accentColorAsFlutterColor,
                                                          ),
                                                          child: Icon(
                                                            iconMap[course.name] ?? Icons.help,
                                                            size: 30,
                                                            color: course.colorAsFlutterColor,
                                                          ),
                                                        ),
                                                        SizedBox(height: 10),
                                                        Text(
                                                          course.name,
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts.leagueSpartan()
                                                                    .fontFamily,
                                                            fontSize: 16,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ),
                                                      ],
                                                    ),
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
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // List of activities
                                SizedBox(
                                  height: 600,
                                  child: SfCalendar(
                                    dataSource: AssignmentDataSource(
                                      assignments,
                                    ),
                                    viewHeaderHeight: 50,
                                    todayHighlightColor: Color.fromARGB(255, 45, 176, 194),
                                    showDatePickerButton: true,
                                    selectionDecoration: BoxDecoration(
                                      color: Colors.transparent,
                                      border: Border.all(
                                        color: Color.fromARGB(255, 45, 176, 194),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.all(
                                        Radius.circular(4),
                                      ),
                                    ),
                                    headerStyle: CalendarHeaderStyle(
                                      backgroundColor: Colors.transparent,
                                      textAlign: TextAlign.center,
                                      textStyle: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan()
                                            .fontFamily,
                                        fontSize: 18,
                                        color: Colors.black,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    view: CalendarView.month,
                                    monthViewSettings: MonthViewSettings(
                                      showAgenda: true,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AssignmentDataSource extends CalendarDataSource {
  AssignmentDataSource(List<Assignment> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].dueDate;
  }

  @override
  bool isAllDay(int index) {
    return true;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    final assignment = appointments![index] as Assignment;
    final courseClass = globals.classController.getClassById(assignment.classId);
    final course = globals.courseController.getSubjectById(courseClass!.subjectId);
    return course?.colorAsFlutterColor ?? Colors.grey;
  }
}
