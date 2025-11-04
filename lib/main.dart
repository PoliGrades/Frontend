import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/privacy_policy_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleFonts.config.allowRuntimeFetching = true;

    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.from(alpha: 255, red: 45, green: 176, blue: 194),
        ),
        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
      ),
      home: PrivacyPolicyScreen(), // Responsividade das telas
    );
  }
}
