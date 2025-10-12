import 'package:flutter/material.dart';

class Responsividade extends StatelessWidget {
  final Widget mobile; 
  final Widget desktop;

  const Responsividade({super.key, required this.mobile, required this.desktop});
  
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if(constraints.maxWidth > 500){
        return desktop;
      }
      return mobile;
    });
  }
}