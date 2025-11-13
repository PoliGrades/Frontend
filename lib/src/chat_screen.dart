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
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Stack(
          alignment: Alignment.center,
          children: [
            // header
            Positioned(
              top: 30,
              left: 40,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                    tooltip: 'Voltar',
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 32,
                      color: Colors.grey,
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.account_circle,
                    size: 60,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 12),
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      'Prof. Calvetti',
                      style: GoogleFonts.leagueSpartan(
                        fontSize: 26,
                        color: Colors.grey[800],
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Positioned(
              top: 110,
              left: 0,
              right: 0,
              child: Container(height: 1, color: Colors.grey[300]),
            ),

            // conteúdo principal
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: size.width * 0.15,
                vertical: 40,
              ),
              child: Column(
                children: [
                  const Spacer(),

                  // mensagens
                  Expanded(
                    flex: 8,
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[100],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(32),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: const [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ChatBubble(
                                text:
                                    'Olá, bem-vindo ao chat! Em que posso ajudar?',
                                isOwn: false,
                              ),
                            ),
                            SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerRight,
                              child: ChatBubble(
                                text:
                                    'está responsivo Alexandre',
                                isOwn: true,
                              ),
                            ),
                            SizedBox(height: 24),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: ChatBubble(
                                text: 'Claro — diga qual dúvida você tem.',
                                isOwn: false,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 30),

                  // campo de mensagem
                  Row(
                    children: [
                      Expanded(
                        child: TextField(
                          style: GoogleFonts.leagueSpartan(fontSize: 18),
                          decoration: InputDecoration(
                            hintText: 'Digite sua mensagem...',
                            hintStyle: GoogleFonts.leagueSpartan(
                              color: Colors.grey[500],
                              fontSize: 18,
                            ),
                            filled: true,
                            fillColor: Colors.grey[100],
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 24,
                              vertical: 22,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      IconButton(
                        tooltip: 'Enviar',
                        icon: const Icon(
                          Icons.send,
                          size: 34,
                          color: Color.fromARGB(255, 45, 176, 194),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // política de privacidade
                  RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text:
                              'Todas as mensagens enviadas são utilizadas de acordo com a nossa ',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 15,
                            color: Colors.grey[600],
                          ),
                        ),
                        TextSpan(
                          text: 'Política de Privacidade.',
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 15,
                            color: const Color.fromARGB(255, 45, 176, 194),
                            decoration: TextDecoration.underline,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              // ação ao clicar
                            },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ],
        ),
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

    final screenWidth = MediaQuery.of(context).size.width;

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth >= 800 ? screenWidth * 0.4 : 260,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
          child: Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: screenWidth >= 800 ? 18 : 14,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}