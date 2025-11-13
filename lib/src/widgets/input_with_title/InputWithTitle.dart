import 'package:flutter/material.dart';

class InputWithTile extends StatefulWidget {
  const InputWithTile({
    super.key,
    required this.title,
    required this.hintText,
    required this.onChanged,
    this.onSubmitted,
    this.controller,
    this.isPassword = false,
    this.suffixIcon,
    this.prefixIcon,
    this.bottomMargin = 20,
  });

  final String title;
  final String hintText;
  final TextEditingController? controller;
  final Function(String)? onSubmitted;
  // onChanged function
  final Function(String) onChanged;
  // obscureText boolean
  final bool isPassword;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  // bottom margin for the whole widget (allow mobile to reduce gap)
  final double bottomMargin;

  @override
  _InputWithTileState createState() => _InputWithTileState();
}

class _InputWithTileState extends State<InputWithTile> {
  bool _isVisible = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: widget.bottomMargin),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: widget.controller,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
            style: const TextStyle(fontSize: 16),
            obscureText: widget.isPassword && !_isVisible,
            enableSuggestions: !widget.isPassword,
            autocorrect: !widget.isPassword,
            decoration: InputDecoration(
              suffixIcon:
                  widget.suffixIcon ??
                  (widget.isPassword
                      ? IconButton(
                          onPressed: () {
                            setState(() {
                              // Toggle password visibility
                              _isVisible = !_isVisible;
                            });
                          },
                          icon: Icon(
                            _isVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                        )
                      : null),
              prefixIcon: widget.prefixIcon,
              hintText: widget.hintText,
              hintStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 216, 216, 216),
                  width: 1.0,
                ),
              ),
              enabledBorder: const OutlineInputBorder(
                borderSide: BorderSide(
                  color: Color.fromARGB(255, 216, 216, 216),
                  width: 1.0,
                ),
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
