import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';

class NoticeCard extends StatelessWidget {
  final Notice notice;
  final Course course;
  final VoidCallback onTap;
  final double? width;

  const NoticeCard({
    super.key,
    required this.notice,
    required this.course,
    required this.onTap,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');
    
    return GestureDetector(
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
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        width: 30,
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(1000)),
                          color: course.accentColorAsFlutterColor,
                        ),
                        child: Icon(
                          iconMap[course.name] ?? Icons.help,
                          size: 20,
                          color: course.colorAsFlutterColor,
                        ),
                      ),
                      Text(
                        f.format(notice.date),
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
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
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    notice.content.length > 60 
                      ? '${notice.content.substring(0, 60)}...'
                      : notice.content,
                    style: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 14,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
