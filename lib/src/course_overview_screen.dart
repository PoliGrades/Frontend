import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/chat_screen.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/widgets/course_overview_card.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';


class CourseOverviewScreen extends StatefulWidget{
  const CourseOverviewScreen({super.key});
    @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreen();
}

class _CourseOverviewScreen extends State<CourseOverviewScreen> {
  late final List<Course> courses;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 45, 176, 194),
  );

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    courses = globals.courseController.allSubjects;
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  } 
  else if (index == 1) {
    return;
  }
  //add outras telas
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopCourseOverviewScreen(
              courses: courses, 
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped, 
              homeScreen: HomeScreen(),
            );
          } else {
            return MobileCourseOverviewScreen(
              courses: courses,
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            );
          }
        },
      ),
    );
  }
}

class MobileCourseOverviewScreen extends StatelessWidget {
  final List<Course> courses;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;

  const MobileCourseOverviewScreen({
    super.key, 
    required this.courses, 
    required this.selectedIndex,
    required this.onItemTapped
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Minhas Matérias",
          style: TextStyle(
            color: Colors.black,
            fontFamily:GoogleFonts.leagueSpartan().fontFamily,
            fontSize: 22
          ),
        ),              
        elevation: 0,
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero, 
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseOverviewCard(course: course);
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        onTap: onItemTapped,
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

class DesktopCourseOverviewScreen extends StatelessWidget {
  final int selectedIndex;
  final List<Course> courses;
  final ValueChanged<int> onItemTapped;
  final Widget homeScreen;

  DesktopCourseOverviewScreen({
    super.key, 
    required this.courses, 
    required this.selectedIndex, 
    required this.onItemTapped,
    required this.homeScreen,
  });
  final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 45, 176, 194),
  );
  final Color selectedTileHighlight = Color.fromARGB(255, 45, 176, 194);
  final Color primaryColor = Color.fromARGB(255, 45, 176, 194);
  final Color defaultInactiveColor = Colors.black54;
  
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
        
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        // Make it rounded
                        selected: false,
                        selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        onTap: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => globals.currentUser.role == UserRole.STUDENT ? HomeScreen() : AdminHomeScreen()),
                          );
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.book),
                        title: Text('Matérias'),
                        selected: true,
                        selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(6)),
                        ),
                        onTap: () {
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('Atividades'),
                        onTap: () {
                        },
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
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
                    height: double.infinity,
                    color: Colors.grey.shade300,
                  ),
                ),
              ),
            Expanded(
            child: Center(
              child: SizedBox(
                width: 800, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
                      child: Text(
                        "Minhas Matérias",
                        style: TextStyle(
                          fontSize: 24,
                          fontFamily:GoogleFonts.leagueSpartan().fontFamily,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16.0),
                    ),
                    Expanded(
                      child: ListView.builder(
                        padding: const EdgeInsets.only(top: 0.0), 
                        itemCount: courses.length,
                        itemBuilder: (context, index) {
                          final course = courses[index];
                          return CourseOverviewCard(course: course);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],       
      ),
    );
  }
}

