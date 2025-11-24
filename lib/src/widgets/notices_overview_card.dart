import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';

class NoticesOverviewCard extends StatelessWidget {
  final Notice notice;
  final Course? courseData;
  const NoticesOverviewCard({super.key, required this.notice, this.courseData});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        color: courseData?.accentColorAsFlutterColor ?? Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: courseData?.colorAsFlutterColor ?? Colors.grey, width: 2),
        ),
        child: ListTile(
          leading: Icon(Icons.book, color: courseData?.colorAsFlutterColor, size: 32),
          title: Text(
            notice.title,
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: courseData?.colorAsFlutterColor,
            ),
          ),
          subtitle: Text(
            notice.content,
            style: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontSize: 14,
            ),
          ),
          trailing: Text(
            '${notice.date.day}/${notice.date.month}/${notice.date.year}',
            style: TextStyle(
              fontFamily: GoogleFonts.openSans().fontFamily,
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ),
      ),
    );
  }
}
