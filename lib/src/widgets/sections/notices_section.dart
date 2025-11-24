import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/widgets/cards/notice_card.dart';
import 'package:polieats_frontend/src/widgets/components/empty_state.dart';
import 'package:polieats_frontend/src/widgets/components/section_header.dart';

class NoticesSection extends StatelessWidget {
  final String title;
  final List<Notice> notices;
  final Course? course;
  final Widget? headerAction;
  final Function(Notice) onNoticeTap;
  final String emptyStateTitle;
  final String emptyStateSubtitle;

  const NoticesSection({
    super.key,
    required this.title,
    required this.notices,
    required this.course,
    this.headerAction,
    required this.onNoticeTap,
    required this.emptyStateTitle,
    required this.emptyStateSubtitle,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      color: Colors.white12,
      width: size.width,
      height: 250,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        spacing: 15,
        children: [
          SectionHeader(
            title: title,
            action: headerAction,
          ),
          Expanded(
            child: notices.isEmpty
              ? EmptyState(
                  icon: Icons.campaign_outlined,
                  title: emptyStateTitle,
                  subtitle: emptyStateSubtitle,
                )
              : ListView.separated(
                  scrollDirection: Axis.horizontal,
                  physics: BouncingScrollPhysics(),
                  itemCount: notices.length,
                  separatorBuilder: (context, index) => SizedBox(width: 10),
                  itemBuilder: (context, index) {
                    final notice = notices[index];
                    
                    return NoticeCard(
                      notice: notice,
                      course: course!,
                      onTap: () => onNoticeTap(notice),
                    );
                  },
                ),
          ),
        ],
      ),
    );
  }
}
