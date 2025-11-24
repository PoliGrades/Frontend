import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';

class AssignmentCard extends StatelessWidget {
  final Assignment assignment;
  final Course course;
  final VoidCallback onTap;
  final double? width;

  const AssignmentCard({
    super.key,
    required this.assignment,
    required this.course,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');
    
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Container(
          width: width ?? size.width * 0.60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: Colors.grey.shade50,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                          borderRadius: BorderRadius.all(Radius.circular(20)),
                        ),
                        child: Text(
                          f.format(assignment.dueDate),
                          style: TextStyle(
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      assignment.title,
                      style: TextStyle(
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      course.name,
                      style: TextStyle(
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
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
  }
}
