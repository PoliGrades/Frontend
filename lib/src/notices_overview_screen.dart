import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Notices.dart';

class NoticesOverviewScreen extends StatefulWidget {
  const NoticesOverviewScreen({super.key});
  @override
  State<NoticesOverviewScreen> createState() => _NoticesOverviewScreen();
}

class _NoticesOverviewScreen extends State<NoticesOverviewScreen> {
  final noticesController = Notices();
  late final List<Notice> noticesList;

  @override
  void initState() {
    super.initState();
    noticesList = noticesController.allNotices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopNoticesOverview(noticesList: noticesList);
          } else {
            return MobileNoticesOverview(noticesList: noticesList);
          }
        },
      ),
    );
  }
}

class MobileNoticesOverview extends StatelessWidget {
  final List<Notice> noticesList;
  const MobileNoticesOverview({super.key, required this.noticesList});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Teste Mobile',
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class DesktopNoticesOverview extends StatelessWidget {
  const DesktopNoticesOverview({super.key, required this.noticesList});

  final List<Notice> noticesList;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Avisos - Desktop',
        style: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black,
        ),
      ),
    );
  }
}
