import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingState extends StatelessWidget {
  final String? message;
  final Color? color;

  const LoadingState({
    super.key,
    this.message,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(color: color ?? Colors.blue),
          if (message != null) ...[
            SizedBox(height: 20),
            Text(
              message!,
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontSize: 16,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
