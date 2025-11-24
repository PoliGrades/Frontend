import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/widgets/cards/assignment_card.dart';
import 'package:polieats_frontend/src/widgets/components/empty_state.dart';
import 'package:polieats_frontend/src/widgets/components/loading_state.dart';
import 'package:polieats_frontend/src/widgets/components/section_header.dart';

class AssignmentsSection extends StatelessWidget {
  final String title;
  final List<Assignment> assignments;
  final Course? course;
  final bool isLoading;
  final Widget? headerAction;
  final Function(Assignment) onAssignmentTap;
  final String emptyStateTitle;
  final String emptyStateSubtitle;
  final IconData emptyStateIcon;

  const AssignmentsSection({
    super.key,
    required this.title,
    required this.assignments,
    required this.course,
    required this.isLoading,
    this.headerAction,
    required this.onAssignmentTap,
    required this.emptyStateTitle,
    required this.emptyStateSubtitle,
    required this.emptyStateIcon,
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
            child: isLoading 
              ? LoadingState(color: course?.colorAsFlutterColor)
              : assignments.isEmpty
                  ? EmptyState(
                      icon: emptyStateIcon,
                      title: emptyStateTitle,
                      subtitle: emptyStateSubtitle,
                    )
                  : ListView.separated(
                      scrollDirection: Axis.horizontal,
                      physics: BouncingScrollPhysics(),
                      itemCount: assignments.length,
                      separatorBuilder: (context, index) => SizedBox(width: 10),
                      itemBuilder: (context, index) {
                        final assignment = assignments[index];
                        
                        return AssignmentCard(
                          assignment: assignment,
                          course: course!,
                          onTap: () => onAssignmentTap(assignment),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
