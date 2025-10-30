import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/input_field/input_field.dart';
import 'package:polieats_frontend/src/widgets/privacy_policy.dart';

class CadastroForm extends StatefulWidget {
  const CadastroForm({super.key});

  @override
  State<CadastroForm> createState() => _CadastroFormState();
}

class _CadastroFormState extends State<CadastroForm> {
  final _formKey = GlobalKey<FormState>();
  String nome = '';
  String email = '';
  String senha = '';
  String confirmaSenha = '';
  bool lembrar = false;

  void _cadastrar() { //funcao chamada quando usuário clicar em "Cadastrar"
    if (_formKey.currentState!.validate()) {
      // ADICIONAR ESTILO
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cadastro realizado com sucesso!')),
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

              //campo nome
              InputField(
                topLabel: 'Nome',
                hint: 'Digite seu nome',
                onChanged: (value) => nome = value,
              ),

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

              //campo confirmar senha
              InputField(
                topLabel: 'Confirmar Senha',
                hint: 'Confirme sua senha',
                obscureText: true,
                onChanged: (value) => confirmaSenha = value,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Confirme sua senha';
                  }
                  if (value != senha) {
                    return 'As senhas não coincidem';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              //botao
              Button(
                text: 'Entrar',
                onPressed: _cadastrar,
              ),
              const SizedBox(height: 10),

              //política de privacidade - hyperlink
              const PrivacyPolicy(),
              
            ],
          ),
        ),
      ),
    );
  }
}
