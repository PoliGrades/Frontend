import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/widgets/cadastro_desktop.dart';
import 'package:polieats_frontend/src/widgets/cadastro_mobile.dart';
import 'package:polieats_frontend/responsividade/responsividade.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
        home: const Responsividade(mobile: TelaCadastro(), desktop: CadastroApp()), // Responsividade das telas
    );
  }
}
