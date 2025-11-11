import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/input_with_title/InputWithTitle.dart';

class PasswordRecoveryScreen extends StatelessWidget {
  const PasswordRecoveryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              child: Image.asset('assets/images/shape_3.png', scale: 0.8),
            ),
            Positioned(
              top: 20,
              left: 20,
              child: Image.asset('assets/images/logo.png', width: 70, height: 70),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 80),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    spacing: 25,
                    children: [
                      Text(
                        'Recuperação de Senha',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 40,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        'Insira um e-mail e enviaremos um código para você voltar a acessar a conta:',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          color: Colors.grey[600],
                        ),
                      ),
                      InputWithTile(
                        title: 'Email',
                        hintText: 'nome@p4ed.com.br',
                        onChanged: (value) {},
                      ),
                      Button(
                        text: 'Enviar código',
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Código enviado para o e-mail informado'),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}