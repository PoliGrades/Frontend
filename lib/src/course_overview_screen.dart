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

  @override
  void initState() {
    super.initState();
    courses = coursesController.allCourses;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "Minhas Matérias",
          style: TextStyle(
            color: Colors.black,
            fontFamily:GoogleFonts.leagueSpartan().fontFamily,
            fontSize: 22
          ),
        ),              
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: ListView.builder(
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
  const DesktopCourseOverviewScreen({super.key, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SizedBox(
          width: 800, 
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 10.0),
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
                  padding: const EdgeInsets.only(top: 10.0), 
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