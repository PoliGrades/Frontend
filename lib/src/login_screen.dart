import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/input_with_title/InputWithTitle.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return const DesktopLoginScreen();
          } else {
            return const MobileLoginScreen();
          }
        },
      ),
    );
  }
}

class DesktopLoginScreen extends StatelessWidget {
  const DesktopLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 70, height: 70),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Image.asset('assets/images/shape_3.png', scale: 0.9),
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 200,
                start: 60,
                end: 60,
                bottom: 80,
              ),
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Row(
                  spacing: 50,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Bem vindo ao\nPoliGrades',
                            style: GoogleFonts.leagueSpartan(
                              height: 1,
                              fontSize: 52,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.only(top: 20),
                            child: Text(
                              'A plataforma que facilita a gestão acadêmica 📚',
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 24,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Push the button section to the bottom
                    // const Spacer(),

                    // Bottom section: button and warning text
                    SizedBox(
                      width: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        spacing: 20,
                        children: [
                          InputWithTile(
                            title: 'Email',
                            hintText: 'nome@p4ed.com.br',
                            onChanged: (value) {
                              // Handle email change
                            },
                          ),
                          InputWithTile(
                            title: 'Senha',
                            hintText: 'Digite sua senha',
                            onChanged: (value) {
                              // Handle password change
                            },
                            isPassword: true,
                          ),
                          Button(
                            text: 'Entrar',
                            onPressed: () {
                              // Handle login button press
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeScreen(),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 20),
                          Center(
                            child: Text(
                              'Ao entrar, você concorda com nossos\n Termos de Serviço e Política de Privacidade.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.leagueSpartan(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class MobileLoginScreen extends StatelessWidget {
  const MobileLoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        alignment: AlignmentGeometry.center,
        children: [
          Positioned(
            top: 20,
            left: 20,
            child: Image.asset('assets/images/logo.png', width: 70, height: 70),
          ),
          SizedBox(
            width: size.width,
            child: Padding(
              padding: EdgeInsetsGeometry.directional(
                top: 120,
                start: 30,
                end: 30,
                bottom: 80,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Top section: title, description and inputs
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Bem vindo ao\nPoliGrades',
                        style: GoogleFonts.leagueSpartan(
                          height: 1,
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.only(top: 20),
                        child: Text(
                          'A plataforma que facilita a gestão acadêmica 📚',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 16,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      InputWithTile(
                        title: 'Email',
                        hintText: 'nome@p4ed.com.br',
                        onChanged: (value) {
                          // Handle email change
                        },
                      ),
                      InputWithTile(
                        title: 'Senha',
                        hintText: 'Digite sua senha',
                        onChanged: (value) {
                          // Handle password change
                        },
                        isPassword: true,
                      ),
                    ],
                  ),

                  // Push the button section to the bottom
                  // const Spacer(),

                  // Bottom section: button and warning text
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Button(
                        text: 'Entrar',
                        onPressed: () {
                          // Handle login button press
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => HomeScreen(),
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      Center(
                        child: Text(
                          'Ao entrar, você concorda com nossos\n Termos de Serviço e Política de Privacidade.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
