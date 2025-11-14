import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed; 
  final Color backgroundColor;
  final Color textColor;
  final double borderRadius;
  final double height;

  const Button({
    super.key,
    required this.text,
    required this.onPressed,
    this.backgroundColor = const Color(0xfff1eb4c3),
    this.textColor = Colors.white,
    this.borderRadius = 10,
    this.height = 50,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius),
        ),
        backgroundColor: backgroundColor,
        foregroundColor: textColor, //cor do conteúdo do botao
        minimumSize: Size(double.infinity, height),
        textStyle: GoogleFonts.leagueSpartan(
          fontSize: 16,
        ),
      ),
      child: Text(text),
    );
  }
}