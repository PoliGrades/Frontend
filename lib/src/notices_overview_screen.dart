import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Courses.dart';

class NoticesOverviewScreen extends StatefulWidget {
  const NoticesOverviewScreen({super.key});

  @override
  State<NoticesOverviewScreen> createState() => _NoticesOverviewScreen();
}

class _NoticesOverviewScreen extends State<NoticesOverviewScreen> {
  final noticesController = Notices();
  final coursesController = Courses();
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
      appBar: AppBar(
        title: Text(
          "Meus Avisos",
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
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
  final coursesController = Courses();

  MobileNoticesOverview({super.key, required this.notices});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: notices.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final notice = notices[index];
        final course = coursesController.getCourseByName(notice.course);

        return GestureDetector(
          onTap: () => _openNoticeModal(context, notice, course!),
          child: Container(
            decoration: BoxDecoration(
              color: course!.accentColor,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: course.color, width: 2),
              boxShadow: [
                BoxShadow(
                  color: course.color.withOpacity(0.25),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // Ícone da matéria
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: course.color,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(course.icon, color: Colors.white, size: 26),
                ),
                const SizedBox(width: 14),

                // Título e descrição
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        notice.title,
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        notice.content,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontFamily: GoogleFonts.openSans().fontFamily,
                          fontSize: 13,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 12),

                // Data
                Text(
                  "${notice.date.day}/${notice.date.month}",
                  style: TextStyle(
                    fontFamily: GoogleFonts.openSans().fontFamily,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _openNoticeModal(BuildContext context, Notice notice, Course course) {
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      context: context,
      builder: (_) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    width: 45,
                    height: 45,
                    decoration: BoxDecoration(
                      color: course.color,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(course.icon, size: 24, color: Colors.white),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    course.name,
                    style: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close, size: 40),
                  )
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

              const SizedBox(height: 10),

              Text(
                "Publicado em: ${notice.date.day}/${notice.date.month}/${notice.date.year}\nPor: ${notice.owner}",
                style: TextStyle(
                  fontFamily: GoogleFonts.openSans().fontFamily,
                  fontSize: 14,
                  color: Colors.grey.shade700,
                ),
              ),

              const SizedBox(height: 20),

              Text(
                notice.content,
                style: TextStyle(
                  fontFamily: GoogleFonts.openSans().fontFamily,
                  fontSize: 16,
                  height: 1.4,
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        );
      },
    );
  }
}

// Desktop 
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