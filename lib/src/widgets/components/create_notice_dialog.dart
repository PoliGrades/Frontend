import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CreateNoticeDialog extends StatelessWidget {
  final TextEditingController titleController;
  final TextEditingController contentController;
  final String courseName;
  final VoidCallback onCreatePressed;
  final VoidCallback onCancelPressed;

  const CreateNoticeDialog({
    super.key,
    required this.titleController,
    required this.contentController,
    required this.courseName,
    required this.onCreatePressed,
    required this.onCancelPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      insetPadding: EdgeInsets.symmetric(
        horizontal: MediaQuery.of(context).size.width * 0.05,
        vertical: 24,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      contentPadding: EdgeInsets.all(32),
      backgroundColor: Colors.white,
      title: Text(
        "Criar novo aviso",
        style: TextStyle(
          color: Colors.black,
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
        ),
      ),
      content: SizedBox(
        width: MediaQuery.of(context).size.width * 0.8,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              ),
              decoration: InputDecoration(
                labelText: "Título",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintText: "Digite o título do aviso",
              ),
            ),
            SizedBox(height: 24),
            TextField(
              controller: contentController,
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              ),
              maxLines: 6,
              decoration: InputDecoration(
                labelText: "Conteúdo",
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintText: "Digite o conteúdo do aviso",
              ),
            ),
            SizedBox(height: 12),
            Text(
              "Atenção: O aviso será publicado imediatamente após a criação para a matéria: $courseName",
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontSize: 12,
                color: Colors.grey.shade400,
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: onCancelPressed,
          child: Text(
            "Cancelar",
            style: TextStyle(
              color: Colors.black,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            ),
          ),
        ),
        TextButton(
          onPressed: onCreatePressed,
          child: Text(
            "Criar",
            style: TextStyle(
              color: Colors.blue, // You might want to pass the actual course color
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            ),
          ),
        ),
      ],
    );
  }
}
