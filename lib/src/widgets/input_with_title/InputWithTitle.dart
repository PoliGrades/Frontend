import 'package:flutter/material.dart';

class InputWithTile extends StatefulWidget {
  const InputWithTile({super.key,
    required this.title,
    required this.hintText,
    required this.onChanged,
    this.isPassword = false,
  });

  final String title;
  final String hintText;
  // onChanged function
  final Function(String) onChanged;
  // obscureText boolean
  final bool isPassword;

  @override
  _InputWithTileState createState() => _InputWithTileState();
}

class _InputWithTileState extends State<InputWithTile> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            onChanged: widget.onChanged,
            style: const TextStyle(
              fontSize: 16,
            ),
            obscureText: widget.isPassword && !_isVisible,
            enableSuggestions: !widget.isPassword,
            autocorrect: !widget.isPassword,
            decoration: InputDecoration(
              suffixIcon: widget.isPassword ? IconButton(
                onPressed: () {
                  setState(() {
                    // Toggle password visibility
                    _isVisible = !_isVisible;
                  });
                },
                icon: Icon(
                  _isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
              ) : null,
              hintText: widget.hintText,
              hintStyle: const TextStyle(
                color: Colors.grey,
              ),
              border: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 216, 216, 216), width: 1.0),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Color.fromARGB(255, 216, 216, 216), width: 1.0),
              ),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.blue, width: 2.0),
              ),
            ),
          ),
        ],
      ),
    );
  }
}