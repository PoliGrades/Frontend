import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/widgets/course_overview_card.dart';

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

  @override
  void initState() {
    super.initState();
    courses = coursesController.allCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopCourseOverviewScreen(courses: courses);
          } else {
            return MobileCourseOverviewScreen(courses: courses);
          }
        },
      ),
    );
  }
}

class MobileCourseOverviewScreen extends StatelessWidget {
  final List<Course> courses;
  const MobileCourseOverviewScreen({super.key, required this.courses});

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
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero, 
        itemCount: courses.length,
        itemBuilder: (context, index) {
          final course = courses[index];
          return CourseOverviewCard(course: course);
        },
      ),
    );
  }
}

class DesktopCourseOverviewScreen extends StatelessWidget {
  final List<Course> courses;
  DesktopCourseOverviewScreen({super.key, required this.courses});
  final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 45, 176, 194),
    );

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: SizedBox(
          width: 800, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(10.0, 30.0, 20.0, 0.0),
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
    );
  }
}