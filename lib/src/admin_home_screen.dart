import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_assignment_screen.dart';
import 'package:polieats_frontend/src/assignment_overview_screen.dart';
import 'package:polieats_frontend/src/create_assignment_screen.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';
import 'package:polieats_frontend/src/management_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';
import 'package:polieats_frontend/src/select_students_screen.dart';
import 'package:polieats_frontend/src/widgets/components/course_dropdown.dart';
import 'package:polieats_frontend/src/widgets/components/create_notice_dialog.dart';
import 'package:polieats_frontend/src/widgets/components/no_courses_state.dart';
import 'package:polieats_frontend/src/widgets/components/notice_detail_modal.dart';
import 'package:polieats_frontend/src/widgets/components/user_header.dart';
import 'package:polieats_frontend/src/widgets/sections/assignments_section.dart';
import 'package:polieats_frontend/src/widgets/sections/notices_section.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

class AdminHomeScreen extends StatefulWidget {
  const AdminHomeScreen({super.key});
  @override
  State<AdminHomeScreen> createState() => _AdminHomeScreenState();
}

class _AdminHomeScreenState extends State<AdminHomeScreen> {
  String selectedCourse = '';

  final assignmentsController = Assignments();

  // Add controllers for the notice form
  final TextEditingController _noticeTitleController = TextEditingController();
  final TextEditingController _noticeContentController = TextEditingController();

  List<Assignment> assignments = [];
  List<Notice> notices = [];
  Course? course;
  bool isLoading = true;
  bool isDataLoading = true;
  bool hasNoCourses = false;

  void onCourseChanged(String? newCourse) {
    print('Admin: Course changed from $selectedCourse to $newCourse');
    if (newCourse != null && newCourse != selectedCourse) {
      setState(() {
        selectedCourse = newCourse;
        course = globals.courseController.getSubjectByName(selectedCourse);
        if (course != null) {
          // Get all notices and filter by course if needed
          final allNotices = globals.noticesController.allNotices;
          notices = selectedCourse.isNotEmpty 
              ? globals.noticesController.getNoticesForCourse(selectedCourse)
              : allNotices;
          isLoading = true;
          
          print('Admin: Updated notices count: ${notices.length} for course: $selectedCourse');
        }
      });
      if (course != null) {
        _loadAssignments();
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() {
      isDataLoading = true;
      hasNoCourses = false;
    });

    try {
      // Load courses from API
      final fetchedCourses = await api.fetchCourses();
      globals.courseController.setSubjects(fetchedCourses);
      
      // Check if user has no courses
      if (globals.courseController.allSubjects.isEmpty) {
        setState(() {
          hasNoCourses = true;
          isDataLoading = false;
          selectedCourse = '';
          course = null;
        });
        return;
      }

      // Set the first course as default if no course is selected or if the selected course no longer exists
      final currentCourse = selectedCourse.isNotEmpty ? globals.courseController.getSubjectByName(selectedCourse) : null;
      if (currentCourse == null && globals.courseController.allSubjects.isNotEmpty) {
        setState(() {
          selectedCourse = globals.courseController.allSubjects.first.name;
          course = globals.courseController.allSubjects.first;
        });
      } else if (currentCourse != null) {
        setState(() {
          course = currentCourse;
        });
      }

      // Load notices for all courses
      globals.noticesController.fetchAllNotices();
      
      // Small delay to ensure notices are loaded
      await Future.delayed(Duration(milliseconds: 100));
      
      // Update notices for selected course
      setState(() {
        // Get all notices and filter by course if needed
        final allNotices = globals.noticesController.allNotices;
        notices = selectedCourse.isNotEmpty 
            ? globals.noticesController.getNoticesForCourse(selectedCourse)
            : allNotices;
        isDataLoading = false;
        
        print('Admin: Loaded ${notices.length} notices for course: $selectedCourse');
        print('Admin: All notices count: ${allNotices.length}');
      });

      // Load assignments for the selected course
      if (course != null) {
        await _loadAssignments();
      }
      
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

  Future<void> _loadAssignments() async {
    if (course != null) {
      try {
        setState(() {
          isLoading = true;
        });
        final fetchedAssignments = await assignmentsController.getTasksForClass(course!.id);
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
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Por favor, preencha todos os campos'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    if (course == null) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Nenhuma matéria selecionada'),
            backgroundColor: Colors.red,
          ),
        );
      }
      return;
    }

    try {
      await api.createNotice(title, content, course!.id);
      
      // Clear the form
      _noticeTitleController.clear();
      _noticeContentController.clear();

      // Close the dialog
      if (mounted) {
        Navigator.of(context).pop();
      }

      // Show success message
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Aviso criado com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );
      }

      // Refresh notices from server
      globals.noticesController.fetchAllNotices();
      
      // Small delay to ensure notices are refreshed
      await Future.delayed(Duration(milliseconds: 100));
      
      setState(() {
        // Get all notices and filter by course if needed
        final allNotices = globals.noticesController.allNotices;
        notices = selectedCourse.isNotEmpty 
            ? globals.noticesController.getNoticesForCourse(selectedCourse)
            : allNotices;
            
        print('Admin: After creating notice - notices count: ${notices.length} for course: $selectedCourse');
        print('Admin: After creating notice - all notices count: ${allNotices.length}');
      });

    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar aviso: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
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
    _loadInitialData();
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final f = DateFormat('dd/MM/yyyy');
    String selectedCourse = 'Matemática';

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
            return AdminDesktopHomeScreen(
              selectedCourse: selectedCourse,
              assignments: assignments,
              notices: notices,
              course: course,
              isLoading: isLoading,
              hasNoCourses: hasNoCourses,
              onCourseChanged: onCourseChanged,
              onReloadData: _loadInitialData,
              onCreateNotice: _createNotice,
              noticeTitleController: _noticeTitleController,
              noticeContentController: _noticeContentController,
            );
          } else {
            return AdminMobileHomeScreen(
              selectedCourse: selectedCourse,
              assignments: assignments,
              notices: notices,
              course: course,
              isLoading: isLoading,
              hasNoCourses: hasNoCourses,
              onCourseChanged: onCourseChanged,
              onReloadData: _loadInitialData,
              onCreateNotice: _createNotice,
              noticeTitleController: _noticeTitleController,
              noticeContentController: _noticeContentController,
            );
          }
        },
      ),
    );
  }
}

class AdminMobileHomeScreen extends StatelessWidget {
  final String selectedCourse;
  final List<Assignment> assignments;
  final List<Notice> notices;
  final Course? course;
  final bool isLoading;
  final bool hasNoCourses;
  final void Function(String?) onCourseChanged;
  final VoidCallback onReloadData;
  final VoidCallback onCreateNotice;
  final TextEditingController noticeTitleController;
  final TextEditingController noticeContentController;

  const AdminMobileHomeScreen({
    super.key,
    required this.selectedCourse,
    required this.assignments,
    required this.notices,
    required this.course,
    required this.isLoading,
    required this.hasNoCourses,
    required this.onCourseChanged,
    required this.onReloadData,
    required this.onCreateNotice,
    required this.noticeTitleController,
    required this.noticeContentController,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Show no courses screen
    if (hasNoCourses || course == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: NoCoursesState(
            hasNoCourses: hasNoCourses,
            onCreateCourse: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ManagementScreen(),
                ),
              ).then((_) {
                onReloadData();
              });
            },
            onRefresh: onReloadData,
          ),
        ),
        bottomNavigationBar: _buildBottomNavigationBar(context),
      );
    }

    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final dividerHeight = size.height - appBarHeight;

    // return Scaffold(
    //   backgroundColor: Colors.white,
    //   body: LayoutBuilder(
    //     builder: (context, constraints) {
    //       if (constraints.maxWidth >= 800) {
    //         return DesktopAdminScreen();
    //       } else {
    //         // return MobileAdminScreen();
    //       }
    //     },
    //   ),
    // );
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
                  courseSelector: CourseDropdown(
                    courses: globals.courseController.allSubjects,
                    selectedCourse: selectedCourse,
                    onCourseChanged: onCourseChanged,
                  ),
                  isAdmin: true,
                ),
                AssignmentsSection(
                  title: "Atividades pendentes",
                  assignments: assignments.where((a) => a.dueDate.isAfter(DateTime.now())).toList(),
                  course: course,
                  isLoading: isLoading,
                  headerAction: IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CreateAssignmentScreen(
                            courseId: course!.id,
                          ),
                        ),
                      );
                    },
                    icon: Icon(Icons.add, color: course!.colorAsFlutterColor),
                    style: IconButton.styleFrom(
                      backgroundColor: course!.accentColorAsFlutterColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onAssignmentTap: (assignment) {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => AdminAssignmentScreen(
                          assignmentId: assignment.id,
                        ),
                      ),
                    );
                  },
                  emptyStateTitle: "Nenhuma atividade pendente",
                  emptyStateSubtitle: "Crie uma nova atividade usando o botão +",
                  emptyStateIcon: Icons.assignment_outlined,
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
                            "Atividades vencidas",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                            ),
                          ),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: course!.accentColorAsFlutterColor,
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
                                color: course!.colorAsFlutterColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                      Expanded(
                        child: isLoading 
                          ? Center(
                              child: CircularProgressIndicator(color: course!.accentColorAsFlutterColor),
                            )
                          : assignments.isEmpty || assignments.every((a) => a.dueDate.isAfter(DateTime.now()))
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
                                        "Nenhuma atividade vencida",
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 16,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        "As atividades aparecerão aqui após o prazo de entrega",
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
                                              builder: (context) => AdminAssignmentScreen(
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
                                                  color: course!.colorAsFlutterColor,
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
                                                          DateFormat('dd/MM/yyyy', 'pt_BR').format(assignment.dueDate),
                                                          style: TextStyle(
                                                            fontFamily:
                                                                GoogleFonts.leagueSpartan()
                                                                    .fontFamily,
                                                            fontSize: 12,
                                                            color: course!.colorAsFlutterColor,
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
                NoticesSection(
                  title: "Quadro de avisos",
                  notices: notices,
                  course: course,
                  headerAction: IconButton(
                    onPressed: () {
                      // Open a modal to create a new notice
                      showDialog(
                        context: context,
                        builder: (context) {
                          return CreateNoticeDialog(
                            titleController: noticeTitleController,
                            contentController: noticeContentController,
                            courseName: course!.name,
                            onCreatePressed: onCreateNotice,
                            onCancelPressed: () {
                              // Clear the form and close dialog
                              noticeTitleController.clear();
                              noticeContentController.clear();
                              Navigator.of(context).pop();
                            },
                          );
                        },
                      );
                    },
                    icon: Icon(Icons.add, color: course!.colorAsFlutterColor),
                    style: IconButton.styleFrom(
                      backgroundColor: course!.accentColorAsFlutterColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                  ),
                  onNoticeTap: (notice) {
                    showModalBottomSheet(
                      isScrollControlled: true,
                      context: context,
                      builder: (context) => NoticeDetailModal(
                        notice: notice,
                        course: course!,
                      ),
                    );
                  },
                  emptyStateTitle: "Nenhum aviso publicado",
                  emptyStateSubtitle: "Publique um novo aviso usando o botão +",
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context),
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
      onTap: (value) {
        switch (value) {
          case 0:
            break;
          case 1:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ManagementScreen(),
              ),
            );
            break;
          case 2:
            break;
          case 3:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProfileScreen(),
              ),
            );
            break;
          case 4:
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SelectProfessorScreen(),
              ),
            );
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
}

class AdminDesktopHomeScreen extends StatelessWidget {
  final String selectedCourse;
  final List<Assignment> assignments;
  final List<Notice> notices;
  final Course? course;
  final bool isLoading;
  final bool hasNoCourses;
  final void Function(String?) onCourseChanged;
  final VoidCallback onReloadData;
  final VoidCallback onCreateNotice;
  final TextEditingController noticeTitleController;
  final TextEditingController noticeContentController;

  const AdminDesktopHomeScreen({
    super.key,
    required this.selectedCourse,
    required this.assignments,
    required this.notices,
    required this.course,
    required this.isLoading,
    required this.hasNoCourses,
    required this.onCourseChanged,
    required this.onReloadData,
    required this.onCreateNotice,
    required this.noticeTitleController,
    required this.noticeContentController,
  });


  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    // Show no courses screen
    if (hasNoCourses || course == null) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(32.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.school_outlined,
                  size: 80,
                  color: Colors.grey.shade400,
                ),
                SizedBox(height: 20),
                Text(
                  "Nenhuma matéria encontrada",
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 12),
                Text(
                  "Para começar a gerenciar atividades e avisos, você precisa criar pelo menos uma matéria.",
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: 16,
                    color: Colors.grey.shade600,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ManagementScreen(),
                          ),
                        ).then((_) {
                          onReloadData();
                        });
                      },
                      child: Text("Criar Matéria"),
                    ),
                    SizedBox(width: 16),
                    TextButton(
                      onPressed: onReloadData,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.refresh, color: Colors.grey.shade600),
                          SizedBox(width: 8),
                          Text(
                            "Atualizar",
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 14,
                              color: Colors.grey.shade600,
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
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        onTap: () {},
                      ),
                      ListTile(
                        leading: Icon(Icons.manage_accounts),
                        title: Text('Gerenciar'),
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
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AssignmentOverviewScreen(subjectId: course!.id),
                            ),
                          );
                        },
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
                              builder: (context) => SelectStudentsScreen(),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
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
                                'Gerencie suas matérias e atividades:',
                                style: TextStyle(
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  fontSize: 18,
                                  color: Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          CourseDropdown(
                            courses: globals.courseController.allSubjects,
                            selectedCourse: selectedCourse,
                            onCourseChanged: onCourseChanged,
                          ),
                        ],
                      ),
                      SizedBox(height: 40),
                      Row(
                        spacing: 30,
                        children: [
                          Expanded(
                            flex: 4,
                            child: Column(
                              spacing: 20,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                AssignmentsSection(
                                  title: "Atividades publicadas",
                                  assignments: assignments,
                                  course: course,
                                  isLoading: isLoading,
                                  headerAction: IconButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => CreateAssignmentScreen(
                                            courseId: course!.id,
                                          ),
                                        ),
                                      );
                                    },
                                    icon: Icon(Icons.add, color: course!.colorAsFlutterColor),
                                    style: IconButton.styleFrom(
                                      backgroundColor: course!.accentColorAsFlutterColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  onAssignmentTap: (assignment) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => AdminAssignmentScreen(
                                          assignmentId: assignment.id,
                                        ),
                                      ),
                                    );
                                  },
                                  emptyStateTitle: "Nenhuma atividade pendente",
                                  emptyStateSubtitle: "Crie uma nova atividade usando o botão +",
                                  emptyStateIcon: Icons.assignment_outlined,
                                ),
                                SizedBox(height: 20),
                                NoticesSection(
                                  title: "Quadro de avisos",
                                  notices: notices,
                                  course: course,
                                  headerAction: IconButton(
                                    onPressed: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) {
                                          return CreateNoticeDialog(
                                            titleController: noticeTitleController,
                                            contentController: noticeContentController,
                                            courseName: course!.name,
                                            onCreatePressed: onCreateNotice,
                                            onCancelPressed: () {
                                              noticeTitleController.clear();
                                              noticeContentController.clear();
                                              Navigator.of(context).pop();
                                            },
                                          );
                                        },
                                      );
                                    },
                                    icon: Icon(Icons.add, color: course!.colorAsFlutterColor),
                                    style: IconButton.styleFrom(
                                      backgroundColor: course!.accentColorAsFlutterColor,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                    ),
                                  ),
                                  onNoticeTap: (notice) {
                                    showModalBottomSheet(
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => NoticeDetailModal(
                                        notice: notice,
                                        course: course!,
                                      ),
                                    );
                                  },
                                  emptyStateTitle: "Nenhum aviso publicado",
                                  emptyStateSubtitle: "Publique um novo aviso usando o botão +",
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 16),
                          Expanded(
                            flex: 3,
                            child: Container(
                              height: 600,
                              decoration: BoxDecoration(
                                color: Colors.grey.shade50,
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.grey.shade200),
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.all(20),
                                    decoration: BoxDecoration(
                                      color: course!.colorAsFlutterColor,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                          iconMap[course!.name] ?? Icons.help,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        SizedBox(width: 12),
                                        Text(
                                          course!.name,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.all(20),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Estatísticas da Matéria',
                                            style: TextStyle(
                                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          SizedBox(height: 20),
                                          _buildStatCard('Atividades Pendentes', assignments.length.toString(), Icons.assignment),
                                          SizedBox(height: 12),
                                          _buildStatCard('Avisos Publicados', notices.length.toString(), Icons.announcement),
                                          SizedBox(height: 12),
                                          _buildStatCard('Alunos Matriculados', '0', Icons.people),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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

  // Widget _buildStatCard(String title, String value, IconData icon) {
  //   return Container(
  //     padding: EdgeInsets.all(16),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(8),
  //       border: Border.all(color: Colors.grey.shade200),
  //     ),
  //   );
  // }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: course!.accentColorAsFlutterColor,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Icon(
              icon,
              color: course!.colorAsFlutterColor,
              size: 20,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
