import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/input_field/input_field.dart';
import 'package:polieats_frontend/src/widgets/privacy_policy.dart';
import 'package:url_launcher/url_launcher.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String email = '';
  String senha = '';
  bool lembrar = false;

  void _login() { //funcao chamada quando usuário clicar em "Entrar"
    if (_formKey.currentState!.validate()) {
      // ADICIONAR ESTILO
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login realizado com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form( //agrupa campos InputField e permite usar _formKey para validar todos de uma vez
      key: _formKey,
      child: Center( //centralizana horizontal
        child: ConstrainedBox( //liimita tamanho widget filho
          constraints: const BoxConstraints(maxWidth: 500),
          child: Column( //um elemento embaixo do outro
            mainAxisAlignment: MainAxisAlignment.center, //alinhamento: centralizado
            children: [
              const SizedBox(height: 30),

              //campo email
              InputField(
                topLabel: 'E-mail',
                hint: 'aluno@p4ed.com.br',
                onChanged: (value) => email = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe seu e-mail';
                  }
                  if (!value.contains('@')) {
                    return 'E-mail inválido';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //campo senha
              InputField(
                topLabel: 'Senha',
                hint: 'Digite sua senha',
                obscureText: true,
                onChanged: (value) => senha = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe sua senha';
                  }
                  if (value.length < 8) {
                    return 'A senha deve ter pelo menos 8 caracteres';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //checkbox lembre-se de mim
              LembrarMe(
                lembrar: lembrar,
                onChanged: (value) {
                  setState(() {
                    lembrar = value!;
                  });
                },  
              ),

              //botao
              const SizedBox(height: 20),
              Button(
                text: 'Entrar',
                onPressed: _login,
              ),
              const SizedBox(height: 5),

              //política de privacidade - hyperlink
              const PrivacyPolicy(),

              //esqueceu senha - hyperlink
              EsqueceuSenha(
                url: ''
              ),
            ],
          ),
        ),
      ),
    );
  }
}

//checkbox lembre-se de mim
class LembrarMe extends StatelessWidget {
  final bool lembrar;
  final ValueChanged<bool?> onChanged;

  const LembrarMe({
    Key? key,
    required this.lembrar,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Checkbox(
          value: lembrar,
          onChanged: onChanged,
          side: const BorderSide(
            color: Colors.transparent,
          ),
          fillColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFF1EB4C3); //checkbox selecionado
          }
          return const Color(0xFFFD9D9D9); //checkbox não selecionado
        }),
        overlayColor: WidgetStateProperty.all(Colors.transparent), //remove focus effect
        ),
        
        const SizedBox(width: 8),
        Text('Lembre-se de mim',
          style: GoogleFonts.leagueSpartan(
            fontSize: 14,
            color: const Color(0xFFF676161),
          ),
        ),
      ],
    );
  }
}

//esqueceu senha
class EsqueceuSenha extends StatelessWidget {
  final String url; 

  EsqueceuSenha({
    super.key,
    required this.url,
  });

  Future<void> _abrirLink() async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      debugPrint('Erro ao abrir o link');
    }
  }

  @override
  Widget build(BuildContext context) {
    return RichText( //permite texto clicável
      text: TextSpan(
        text: 'Esqueceu a senha?', 
        style: GoogleFonts.leagueSpartan(
          fontSize: 14, 
          color: const Color(0xFFFF1EB4C3),
          decoration: TextDecoration.underline,
        ),
        recognizer: 
          TapGestureRecognizer()..onTap = _abrirLink, 
      ),
    );
  }
}