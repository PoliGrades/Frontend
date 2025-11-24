import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class InputField extends StatefulWidget {  //parte imutável
  final String hint;
  final String? topLabel;
  final String? initialValue;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final bool obscureText; //para senha

  const InputField({
    super.key,
    required this.hint,
    this.topLabel,
    this.initialValue,
    this.onChanged,
    this.validator,
    this.obscureText = false,
  });

  @override
  _InputFieldState createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {  //parte mutável
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.topLabel != null) ...[ //exibe top label se esxistir
            Text(
              widget.topLabel!,
              style: GoogleFonts.leagueSpartan(
                fontSize: 16,
                color: Color(0xfff676161),
              ),
            ),
            const SizedBox(height: 5),
          ],
          TextFormField(
            controller: _controller,
            cursorColor: Color(0xfff1eb4c3),
            decoration: InputDecoration(
              hintText: widget.hint,
              hintStyle: GoogleFonts.leagueSpartan(
                fontSize: 14,
                color: Color(0xfff676161),
              ),
              filled: true,
              fillColor: const Color(0xfffd9d9d9),
              enabledBorder: OutlineInputBorder( //borda padrao
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.transparent),
              ),
              focusedBorder: OutlineInputBorder( //borda campo selecionado
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xfff1eb4c3),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder( //borda erro
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
              focusedErrorBorder: OutlineInputBorder( //borda erro campo selecionado
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.red, width: 1.5),
              ),
            ),
            obscureText: widget.obscureText,
            validator: widget.validator,
            onChanged: widget.onChanged,
          ),
        ],
      ),
    );
  }
}