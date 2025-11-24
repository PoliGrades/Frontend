import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';

class PrivacyPolicyScreen extends StatefulWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  State<PrivacyPolicyScreen> createState() => _PrivacyPolicyScreenState();
}

class _PrivacyPolicyScreenState extends State<PrivacyPolicyScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return const DesktopPrivacyPolicyScreen();
          } else {
            return const MobilePrivacyPolicyScreen();
          }
        },
      ),
    );
  }
}

class MobilePrivacyPolicyScreen extends StatelessWidget {
  const MobilePrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: false,
        backgroundColor: Colors.white,
        // Faz com que a appbar não mude de cor quando a página é rolada
        scrolledUnderElevation: 0.0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: SizedBox(
          width: size.width,
          child: Stack(
            children: [
              SizedBox(
                child: Padding(
                  padding: const EdgeInsets.only(top: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Política de Privacidade',
                        style: GoogleFonts.leagueSpartan(
                          height: 1,
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Última atualização: ${DateFormat.yMMMMd().format(DateTime.now())}',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Esta é uma política de privacidade genérica. Aqui você pode descrever como os dados são coletados, usados e protegidos. Ajuste o texto conforme necessário para refletir as práticas reais do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Coleta de dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Os dados são utilizados para fornecer funcionalidades do app, melhorar a experiência do usuário e para comunicação relacionada ao serviço. Não compartilhamos dados com terceiros sem consentimento, exceto quando exigido por lei.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Segurança',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adotamos medidas técnicas e organizacionais apropriadas para proteger os dados contra acesso não autorizado, perda ou alteração.',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 16,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DesktopPrivacyPolicyScreen extends StatelessWidget {
  const DesktopPrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        toolbarHeight: 100,
        centerTitle: false,
        title: Padding(
          padding: const EdgeInsets.only(top: 20, left: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Image.asset('assets/images/logo.png', height: 50),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.only(left: 25),
        child: SizedBox(
          width: size.width,
          height: size.height,
          child: Stack(
            children: [
              SizedBox(
                width: size.width * 0.5,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Política de Privacidade',
                        style: GoogleFonts.openSans(
                          fontSize: 45,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Última atualização: ${DateFormat.yMMMMd().format(DateTime.now())}',
                        style: GoogleFonts.openSans(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Esta é uma política de privacidade genérica. Aqui você pode descrever como os dados são coletados, usados e protegidos. Ajuste o texto conforme necessário para refletir as práticas reais do aplicativo.',
                        style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Coleta de dados',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Coletamos apenas as informações necessárias para oferecer e melhorar nossos serviços. Isso pode incluir dados de conta, preferências e informações de uso do aplicativo.',
                        style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Uso dos dados',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Os dados são utilizados para fornecer funcionalidades do app, melhorar a experiência do usuário e para comunicação relacionada ao serviço. Não compartilhamos dados com terceiros sem consentimento, exceto quando exigido por lei.',
                        style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Segurança',
                        style: GoogleFonts.openSans(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Adotamos medidas técnicas e organizacionais apropriadas para proteger os dados contra acesso não autorizado, perda ou alteração.',
                        style: GoogleFonts.openSans(fontSize: 16, height: 1.5),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 0,
                child: Image.asset('assets/images/shape_4.png', scale: 0.9),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
