import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/assignment_screen.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';


class AssignmentOverviewCard extends StatelessWidget{
  final Assignment assignment;
  const AssignmentOverviewCard({super.key, required this.assignment});

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    final classCourse = globals.classController.getClassById(assignment.classId);
    final Course? course = globals.courseController.getSubjectById(classCourse!.subjectId);
    final IconData icon = Icons.book;
    final Color iconColor = course?.colorAsFlutterColor ?? Colors.black;
    final Color cardColor = course?.accentColorAsFlutterColor ?? Colors.white;
  

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: cardColor,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: InkWell(
          onTap: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) => AssignmentScreen(assignmentId: assignment.id)));
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
                        assignment.title,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: iconColor,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        f.format(assignment.dueDate),
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(icon, size: 30, color: iconColor), 
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