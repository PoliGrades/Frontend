import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';

class NoticeDetailModal extends StatelessWidget {
  final Notice notice;
  final Course course;

  const NoticeDetailModal({
    super.key,
    required this.notice,
    required this.course,
  });

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(16),
        ),
      ),
      height: MediaQuery.of(context).size.height * 0.95,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(1000)),
                      color: course.accentColorAsFlutterColor,
                    ),
                    child: Icon(
                      iconMap[course.name] ?? Icons.help,
                      size: 30,
                      color: course.colorAsFlutterColor,
                    ),
                  ),
                  SizedBox(width: 16),
                  Text(
                    course.name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
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
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Publicado em: ${f.format(notice.date)},\npor ${notice.owner}',
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 20),
          Text(
            notice.content,
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}
