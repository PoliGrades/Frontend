import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const CadastroApp());
}

class CadastroApp extends StatelessWidget {
  const CadastroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cadastro',
      debugShowCheckedModeBanner: false,
      home: const CadastroPage(),
    );
  }
}

class CadastroPage extends StatefulWidget {
  const CadastroPage({super.key});

  @override
  State<CadastroPage> createState() => _CadastroPageState();
}

class _CadastroPageState extends State<CadastroPage> {
  final _formKey = GlobalKey<FormState>();
  final _nomeController = TextEditingController();
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();
  final _confirmarSenhaController = TextEditingController();

  void _cadastrar() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Cadastro realizado com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }

  OutlineInputBorder _getBorder({Color color = Colors.black26}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: 2),
    );
  }

  void _abrirPolitica() async {
    const url = ''; //ainda a colocar
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
  }

  @override
  Widget build(BuildContext context) {
    const azulBotao = Color(0xFF20B4C4);

    final screenWidth = MediaQuery.of(context).size.width;
    final formWidth = screenWidth < 600 ? screenWidth * 0.9 : 500.0;

    return Scaffold(
      backgroundColor: const Color(0x3320B4C4),
      body: Stack(
        children: [
          Positioned(
            top: 24,
            left: 24,
            child: Image.asset(
              'assets/logo.png',
              height: 80,
            ),
          ),
          Center(
            child: SingleChildScrollView(
              child: Container(
                width: formWidth,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Cadastro',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo Nome
                      Text(
                        'Nome',
                        style: GoogleFonts.leagueSpartan(
                          color: const Color(0xFF6D6D6D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _nomeController,
                        cursorColor: azulBotao,
                        decoration: InputDecoration(
                          hintText: 'Digite seu nome',
                          hintStyle: GoogleFonts.leagueSpartan(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(color: azulBotao),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (v) =>
                            v!.isEmpty ? 'Informe seu nome' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo E-mail
                      Text(
                        'E-mail',
                        style: GoogleFonts.leagueSpartan(
                          color: const Color(0xFF6D6D6D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _emailController,
                        cursorColor: azulBotao,
                        decoration: InputDecoration(
                          hintText: 'aluno@p4ed.com.br',
                          hintStyle: GoogleFonts.leagueSpartan(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(color: azulBotao),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (v) {
                          if (v!.isEmpty) return 'Informe seu e-mail';
                          if (!v.contains('@')) return 'E-mail inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),

                      // Campo Senha
                      Text(
                        'Senha',
                        style: GoogleFonts.leagueSpartan(
                          color: const Color(0xFF6D6D6D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _senhaController,
                        cursorColor: azulBotao,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Digite sua senha',
                          hintStyle: GoogleFonts.leagueSpartan(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(color: azulBotao),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (v) =>
                            v!.length < 6 ? 'Mínimo de 6 caracteres' : null,
                      ),
                      const SizedBox(height: 16),

                      // Campo Confirmar Senha
                      Text(
                        'Confirmar Senha',
                        style: GoogleFonts.leagueSpartan(
                          color: const Color(0xFF6D6D6D),
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      TextFormField(
                        controller: _confirmarSenhaController,
                        cursorColor: azulBotao,
                        obscureText: true,
                        decoration: InputDecoration(
                          hintText: 'Confirme sua senha',
                          hintStyle: GoogleFonts.leagueSpartan(
                            color: Colors.black26,
                            fontSize: 14,
                          ),
                          filled: true,
                          fillColor: Colors.white,
                          border: _getBorder(),
                          enabledBorder: _getBorder(),
                          focusedBorder: _getBorder(color: azulBotao),
                        ),
                        style: const TextStyle(color: Colors.black87),
                        validator: (v) {
                          if (v != _senhaController.text) {
                            return 'As senhas não coincidem';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),

                      // Botão Cadastrar
                      ElevatedButton(
                        onPressed: _cadastrar,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: azulBotao,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: Text(
                          'Cadastrar',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Política de Privacidade
                      GestureDetector(
                        onTap: _abrirPolitica,
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            text: 'Ao fazer cadastro você concorda com a nossa ',
                            style: GoogleFonts.leagueSpartan(
                              color: Colors.black87,
                              fontSize: 12,
                            ),
                            children: [
                              TextSpan(
                                text: 'Política de Privacidade',
                                style: GoogleFonts.leagueSpartan(
                                  color: azulBotao,
                                  fontSize: 12,
                                  decoration: TextDecoration.underline,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
