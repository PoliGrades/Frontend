import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/widgets/course_overview_card.dart';
import 'package:polieats_frontend/src/profile_screen.dart';


class CourseOverviewScreen extends StatefulWidget{
  const CourseOverviewScreen({super.key});
    @override
  State<CourseOverviewScreen> createState() => _CourseOverviewScreen();
}

class _CourseOverviewScreen extends State<CourseOverviewScreen> {
  final coursesController = Courses();
  late final List<Course> courses;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 45, 176, 194),
  );

  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    courses = coursesController.allCourses;
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
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Lateral menu
              SizedBox(
                width: size.width * 0.20,
                child: Container(
                  padding: EdgeInsets.all(20),
                  child: SingleChildScrollView(
                  child: Column(
                    spacing: 20,
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                        leading: Icon(
                          Icons.book,
                          color: selectedIndex == 1 ? Colors.white : defaultInactiveColor,
                        ),
                        title: Text(
                          'Matérias', 
                          style: TextStyle(
                            color: selectedIndex == 1 ? Colors.white : defaultInactiveColor,
                          )
                        ),
                        selected: selectedIndex == 1,
                        selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                        onTap: () => onItemTapped(1),
                      ),
                      ListTile(
                        leading: Icon(Icons.assignment),
                        title: Text('Atividades'),
                      ),
                      ListTile(
                        leading: Icon(Icons.person),
                        title: Text('Perfil'),
                      ),
                    ],
                  ),
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

