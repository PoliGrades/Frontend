import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyPolicy extends StatelessWidget {
  final String url;

  const PrivacyPolicy({
    super.key,
    this.url = '', //link politica de privacidade
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
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: RichText( //texto com diferentes estilos na mesma linha
        textAlign: TextAlign.center,
        text: TextSpan( //para as partes diferentes do texto
          style: GoogleFonts.leagueSpartan(
            fontSize: 12,
            color: const Color(0xFFF676161),
          ),
          children: [
            const TextSpan(
              text: 'Ao fazer login você concorda com a nossa ',
            ),
            TextSpan(
              text: 'Política de Privacidade',
              style: GoogleFonts.leagueSpartan(
                fontSize: 12,
                color: Color(0xFFF1EB4C3),
                decoration: TextDecoration.underline,
              ),
              recognizer: TapGestureRecognizer()..onTap = _abrirLink, //detecta toque usuario e aciona o metodo _abrirlink
            ),
          ],
        ),
      ),
    );
  }
}