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
  late final List<Notice> notices;

  @override
  void initState() {
    super.initState();
    notices = noticesController.allNotices;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopNoticesOverview(notices: notices);
          } else {
            return MobileNoticesOverview(notices: notices);
          }
        },
      ),
    );
  }
}

class MobileNoticesOverview extends StatelessWidget {
  final List<Notice> notices;
  const MobileNoticesOverview({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Meus Avisos',
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
  const DesktopNoticesOverview({super.key, required this.notices});

  final List<Notice> notices;

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