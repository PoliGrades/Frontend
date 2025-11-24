import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/course_screen.dart';
import 'package:polieats_frontend/src/data/Courses.dart';

class CourseOverviewCard extends StatelessWidget {
  final Course course;

  const CourseOverviewCard({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: course.accentColorAsFlutterColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => CourseScreen(course: course)));
          },
          borderRadius: BorderRadius.circular(15),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        course.name,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: course.colorAsFlutterColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        course.name,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.book, size: 30, color: course.colorAsFlutterColor),
                const SizedBox(width: 15),
                const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
              ],
            ),
          ),
        ),
      ),
    );
  }
}