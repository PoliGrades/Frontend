import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/assignment_overview_screen.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/course_screen.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late final List<Widget> _desktopScreens;
  
@override
  void initState() {
    super.initState();
    _desktopScreens = [
      const CourseOverviewScreen(),
      const AssignmentOverviewScreen(),
      const ProfileScreen(), 
    ];
  }
  
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);

    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    final coursesController = Courses();
    final courses = coursesController.allCourses;

    final noticesController = Notices();
    final notices = noticesController.notices;

    final assignmentsController = Assignments();
    final assignments = assignmentsController.assignments;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopHomeScreen(
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
              currentScreen: _desktopScreens[_selectedIndex]
            );
          } else {
            return const MobileHomeScreen();
          }
        },
      ),
    );
  }
}

class MobileHomeScreen extends StatelessWidget {
  const MobileHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    final coursesController = Courses();
    final courses = coursesController.allCourses;

    final noticesController = Notices();
    final notices = noticesController.notices;

    final assignmentsController = Assignments();
    final assignments = assignmentsController.assignments;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 45, 176, 194),
    );

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
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
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
                          Text(
                            "O que deseja estudar hoje?",
                            style: TextStyle(
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(100)),
                          color: colorScheme.primary,
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
                      GridView.builder(
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
                                          color: course.accentColor,
                                        ),
                                        child: Icon(
                                          course.icon,
                                          size: 30,
                                          color: course.color,
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
                              fontFamily:
                                  GoogleFonts.leagueSpartan().fontFamily,
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
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade100,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            child: Text(
                              "Ver todos",
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

class DesktopHomeScreen extends StatelessWidget {
  final int selectedIndex;
  final Function(int) onItemTapped; 
  final Widget currentScreen;
  
  const DesktopHomeScreen({
    super.key,
    required this.selectedIndex,
    required this.onItemTapped,
    required this.currentScreen,
  });

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy');

    final size = MediaQuery.of(context).size;

    final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 45, 176, 194),
    );
    final Color selectedTileHighlight = Color.fromARGB(255, 45, 176, 194);
    final Color primaryColor = Color.fromARGB(255, 45, 176, 194);
    final Color defaultInactiveColor = Colors.black54;

    final coursesController = Courses();
    final courses = coursesController.allCourses;

    final assignmentsController = Assignments();
    final assignments = assignmentsController.assignments;

    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final dividerHeight = size.height - appBarHeight;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            Container(
              margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: colorScheme.primary,
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
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
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
                      leading: Icon(
                       Icons.home,
                       color: selectedIndex == 0 ? Colors.white : defaultInactiveColor,
                      ),
                      title: Text(
                        'Início', 
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.white : defaultInactiveColor,
                        )
                      ),
                      selected: selectedIndex == 0,
                      selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                      selectedColor: Colors.white,
                      // Make it rounded
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      onTap: () => onItemTapped(0),
                    ),
                      ListTile(
                        leading: const Icon(Icons.home),
                        selected: selectedIndex == 1,
                        selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        title: const Text('Matérias'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onTap: () {
                          Navigator.push(         
                            context, 
                            MaterialPageRoute(
                              builder: (context) => CourseOverviewScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: const Icon(Icons.assignment),
                        selected: selectedIndex == 2,
                        selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        title: const Text('Atividades'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onTap: () {
                          Navigator.push(         
                            context, 
                            MaterialPageRoute(
                              builder: (context) => AssignmentOverviewScreen(),
                            ),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        //selected: selectedIndex == 3,
                        selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        title: Text('Perfil'),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onTap: () {
                          Navigator.push(         
                            context, 
                            MaterialPageRoute(
                              builder: (context) => ProfileScreen(),
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
                        'Bem-vindo de volta, João!',
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
                                  child: GridView.builder(
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
                                                      color: course.accentColor,
                                                    ),
                                                    child: Icon(
                                                      course.icon,
                                                      size: 30,
                                                      color: course.color,
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
    final coursesController = Courses();
    final course = coursesController.getCourseByName(assignment.course);
    return course!.color;
  }
}
