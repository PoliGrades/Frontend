import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Submissions.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  final assignmentsController = Assignments();
  // TODO: Implement grading through submissions system
  
  List<Assignment> assignments = [];
  List<Submission> submissions = []; // Grading now handled through submissions
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      final fetchedAssignments = await assignmentsController.getTasksForClass(widget.course.id);
      // TODO: Implement grading through submissions system
      
      setState(() {
        assignments = fetchedAssignments;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        assignments = [];
        isLoading = false;
      });
      print('Error loading course data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy');

    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(
            color: widget.course.colorAsFlutterColor,
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.course.colorAsFlutterColor,
        title: Text(
          widget.course.name,
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}