import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SectionHeader extends StatelessWidget {
  final String title;
  final Widget? action;
  final Color? actionColor;
  final Color? backgroundColor;

  const SectionHeader({
    super.key,
    required this.title,
    this.action,
    this.actionColor,
    this.backgroundColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontSize: 18,
          ),
        ),
        if (action != null) action!,
      ],
    );
  }
}
