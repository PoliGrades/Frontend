import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Message.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/privacy_policy_screen.dart';
import 'package:polieats_frontend/src/socket_service.dart';
import 'package:polieats_frontend/src/widgets/button.dart';
import 'package:polieats_frontend/src/widgets/input_with_title/InputWithTitle.dart';

SocketService socketService = SocketService();

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.professorID});

  final int professorID;
  static List<Message> messages = [];

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopChatScreen();
          } else {
            return MobileChatScreen(professorID: widget.professorID);
          }
        },
      ),
    );
  }
}

class DesktopChatScreen extends StatelessWidget {
  const DesktopChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          // logo moved to top-right and enlarged
          Positioned(
            top: 20,
            right: 20,
            child: Image.asset('assets/images/logo.png', width: 90, height: 90),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset('assets/images/shape_3.png', scale: 0.9),
                const SizedBox(width: 12),
                // pessoa ícone colocado aqui
                Icon(Icons.person, size: 36, color: Colors.grey[700]),
              ],
            ),
          ),
          SizedBox(
            width: size.width,
            height: size.height,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 200,
                start: 60,
                end: 60,
                bottom: 80,
              ),
              child: SizedBox(
                width: size.width,
                height: size.height,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
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
                    const SizedBox(width: 50),
                    SizedBox(
                      width: 450,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          InputWithTile(
                            title: '',
                            hintText: 'Digite sua senha',
                            onChanged: (value) {
                              // Handle password change
                            },
                            isPassword: true,
                          ),
                          const SizedBox(height: 20),
                          Button(
                            text: 'Entrar',
                            onPressed: () {
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
                            child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                children: [
                                  TextSpan(
                                    text:
                                        'Todas as mensagens enviadas são utilizadas de acordo com a nossa Política ',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Termos de Serviço',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 45, 176, 194),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                  TextSpan(
                                    text: ' e ',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 16,
                                      color: Colors.grey[600],
                                    ),
                                  ),
                                  TextSpan(
                                    text: 'Política de Privacidade.',
                                    style: GoogleFonts.leagueSpartan(
                                      fontSize: 16,
                                      color: Color.fromARGB(255, 45, 176, 194),
                                      decoration: TextDecoration.underline,
                                    ),
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                PrivacyPolicyScreen(),
                                          ),
                                        );
                                      },
                                  ),
                                ],
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

class MobileChatScreen extends StatefulWidget {
  const MobileChatScreen({super.key, required this.professorID});

  final int professorID;
  static const List<Message> messages = [];

  @override
  _MobileChatScreenState createState() => _MobileChatScreenState();
}

class _MobileChatScreenState extends State<MobileChatScreen> {
  @override
  Widget build(BuildContext context) {
    socketService.addListener("previousMessages", (data) {
      print("Previous Messages: $data");

      // Parse and add previous messages to the list
      List<Message> prevMessages = [];
      if (data is List) {
        for (var msgJson in data) {
          final msg = Message.fromJson(Map<String, dynamic>.from(msgJson));
          prevMessages.add(msg);
        }
      }

      setState(() {
        ChatScreen.messages = prevMessages;
      });
    });

    socketService.emit("joinChat", [widget.professorID]);

    final size = MediaQuery.of(context).size;

    return SafeArea(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 20,
            left: 8,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: Icon(
                    Icons.arrow_back,
                    size: 28,
                    color: Colors.grey[800],
                  ),
                  tooltip: 'Voltar',
                  onPressed: () => Navigator.of(context).maybePop(),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.account_circle, size: 50, color: Colors.grey),
                const SizedBox(width: 8),
                Text(
                  'Prof. Calvetti',
                  style: GoogleFonts.leagueSpartan(
                    height: 1,
                    fontSize: 20,
                    color: Colors.grey[800],
                  ),
                ),
                const SizedBox(width: 12),
              ],
            ),
          ),
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Container(height: 1, color: Colors.grey[300]),
          ),
          SizedBox(
            width: size.width,
            child: Padding(
              padding: EdgeInsetsDirectional.only(
                top: 90,
                start: 16,
                end: 16,
                bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                    Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: MobileChatScreen.messages.length,
                      itemBuilder: (context, index) {
                      final m = MobileChatScreen.messages[index];
                      final dynamic dm = m as dynamic;
                      final String text =
                        dm.text ?? dm.message ?? dm.content ?? m.toString();
                      final bool isOwn = (dm.isOwn ?? false) as bool;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Align(
                        alignment:
                          isOwn ? Alignment.centerRight : Alignment.centerLeft,
                        child: ChatBubble(text: text, isOwn: isOwn),
                        ),
                      );
                      },
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: InputWithTile(
                          title: '',
                          hintText: 'Digite sua mensagem...',
                          onChanged: (value) {},
                          bottomMargin: 4,
                          suffixIcon: IconButton(
                            tooltip: 'Enviar',
                            icon: const Icon(
                              Icons.send,
                              size: 24,
                              color: Color.fromARGB(255, 45, 176, 194),
                            ),
                            onPressed: () {
                              // ação ao pressionar o ícone
                            },
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),
                  Center(
                    child: RichText(
                      textAlign: TextAlign.center,
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text:
                                'Todas as mensagens enviadas são utilizadas de acordo com a nossa política de privacidade.',
                            style: GoogleFonts.leagueSpartan(
                              fontSize: 12,
                              color: Colors.grey[600],
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
        ],
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final String text;
  final bool isOwn;

  const ChatBubble({super.key, required this.text, this.isOwn = true});

  @override
  Widget build(BuildContext context) {
    final bgColor = isOwn ? const Color(0xFF42C9DC) : Colors.grey[200];
    final textColor = isOwn ? Colors.white : Colors.black87;

    const corner = Radius.circular(16);
    final bottomLeftRadius = isOwn ? corner : Radius.zero;
    final bottomRightRadius = isOwn ? Radius.zero : corner;

    final borderRadius = BorderRadius.only(
      topLeft: corner,
      topRight: corner,
      bottomLeft: bottomLeftRadius,
      bottomRight: bottomRightRadius,
    );

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 260),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(fontSize: 14, color: textColor),
          ),
        ),
      ),
    );
  }
}
