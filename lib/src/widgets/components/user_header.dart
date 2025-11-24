import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

class UserHeader extends StatelessWidget {
  final String userName;
  final Widget? courseSelector;
  final bool isAdmin;

  const UserHeader({
    super.key,
    required this.userName,
    this.courseSelector,
    this.isAdmin = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              spacing: 12,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Boas-vindas ${userName.split(" ")[0]}!",
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (courseSelector != null)
                  Row(
                    children: [
                      Expanded(child: courseSelector!),
                    ],
                  ),
              ],
            ),
          ),
          UserIconDropdown(),
        ],
      ),
    );
  }
}
