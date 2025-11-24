import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Courses.dart';

class CourseDropdown extends StatelessWidget {
  final List<Course> courses;
  final String? selectedCourse;
  final Function(String?) onCourseChanged;
  final String labelText;

  const CourseDropdown({
    super.key,
    required this.courses,
    required this.selectedCourse,
    required this.onCourseChanged,
    this.labelText = "Selecione a matéria",
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      label: Text(
        labelText,
        style: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
        ),
      ),
      textStyle: TextStyle(
        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
      ),
      enableSearch: false,
      initialSelection: selectedCourse?.isNotEmpty == true ? selectedCourse : null,
      dropdownMenuEntries: courses.map((course) =>
        DropdownMenuEntry<String>(
          value: course.name,
          label: course.name,
        ),
      ).toList(),
      onSelected: onCourseChanged,
    );
  }
}
