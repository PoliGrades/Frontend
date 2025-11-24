import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Color? iconColor;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            size: 48,
            color: iconColor ?? Colors.grey.shade400,
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 16,
              color: Colors.grey.shade600,
            ),
          ),
          Text(
            subtitle,
            style: TextStyle(
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              fontSize: 12,
              color: Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }
}
