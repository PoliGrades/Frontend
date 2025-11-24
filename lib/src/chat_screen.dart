import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Message.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/privacy_policy_screen.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/socket_service.dart';
import 'package:polieats_frontend/src/widgets/input_with_title/InputWithTitle.dart';

import '../main.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key, required this.recipient});

  final User recipient;

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late SocketService socketService;
  List<Message> messages = [];
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeSocket();
  }

  void _initializeSocket() {
    socketService = SocketService();
    socketService.connect();

    // Listen for previous messages
    socketService.addListener("previousMessages", (data) {
      print("Previous Messages: $data");

      if (data is List) {
        List<Message> prevMessages = [];
        for (var msgJson in data) {
          try {
            final msg = Message.fromJson(Map<String, dynamic>.from(msgJson));
            prevMessages.add(msg);
          } catch (e) {
            print('Error parsing message: $e');
          }
        }

        setState(() {
          messages = prevMessages;
        });
        _scrollToBottom();
      }
    });

    // Listen for new messages
    socketService.addListener("newMessage", (data) {
      print("New Message: $data");
      
      try {
        final newMsg = Message.fromJson(Map<String, dynamic>.from(data));

        setState(() {
          messages.add(newMsg);
        });
        _scrollToBottom();
      } catch (e) {
        print('Error parsing new message: $e');
      }
    });

    // Join chat room
    socketService.emit("joinChat", [widget.recipient.id]);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Send message via socket
    socketService.emit("sendMessage", [{
      'professorID': widget.recipient.id,
      'message': text,
    }]);
    
    _messageController.clear();
    _scrollToBottom();
  }

  @override
  void dispose() {
    socketService.disconnect();
    socketService.removeListener("previousMessages");
    socketService.removeListener("newMessage");
    _messageController.dispose();
    _scrollController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopChatScreen(
              messages: messages,
              messageController: _messageController,
              onSendMessage: _sendMessage,
              scrollController: _scrollController,
              recipient: widget.recipient,
            );
          } else {
            return MobileChatScreen(
              messages: messages,
              messageController: _messageController,
              onSendMessage: _sendMessage,
              scrollController: _scrollController,
              recipient: widget.recipient,
            );
          }
        },
      ),
    );
  }
}

class DesktopChatScreen extends StatelessWidget {
  final List<Message> messages;
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final ScrollController scrollController;
  final User recipient;

  const DesktopChatScreen({
    super.key,
    required this.messages,
    required this.messageController,
    required this.onSendMessage,
    required this.scrollController,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 0.0,
        backgroundColor: const Color.fromARGB(255, 245, 250, 251),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            Container(
              margin: const EdgeInsets.only(left: 20),
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: Color.fromARGB(255, 45, 176, 194),
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          SizedBox(
            width: size.width * 0.20,
            child: Container(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.home),
                    title: const Text('Início'),
                    onTap: () {
                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(
                          builder: (context) => HomeScreen(user: currentUser),
                        ),
                        (route) => false,
                      );
                    },
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.book),
                    title: const Text('Matérias'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text('Atividades'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    onTap: () {},
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.chat),
                    selected: true,
                    selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                    selectedColor: Colors.white,
                    title: const Text('Chat'),
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(6)),
                    ),
                    onTap: () {},
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            width: 20,
            child: Center(
              child: Container(
                width: 1,
                height: double.infinity,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          
          // Área do chat
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.only(
                      left: 40, right: 40, top: 10, bottom: 10),
                  child: Row(
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
                      const SizedBox(width: 12),
                      const Icon(Icons.account_circle, size: 60, color: Colors.grey),
                      const SizedBox(width: 12),
                      Text(
                        'Prof. ${recipient.name}',
                        style: GoogleFonts.leagueSpartan(
                          fontSize: 26,
                          color: Colors.grey[800],
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                Container(height: 1, color: Colors.grey[300]),

                Expanded(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: size.width * 0.08,
                      vertical: 40,
                    ),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              borderRadius: BorderRadius.circular(12),
                            ),
                            padding: const EdgeInsets.all(32),
                            child: SingleChildScrollView(
                              controller: scrollController,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  ...messages.map(
                                    (message) => Padding(
                                      padding: const EdgeInsets.only(bottom: 24),
                                      child: Align(
                                        alignment: message.senderId == 
                                                currentUser.id
                                            ? Alignment.centerRight
                                            : Alignment.centerLeft,
                                        child: ChatBubble(
                                          text: message.message,
                                          timestamp: message.timestamp,
                                          isOwn: message.senderId ==
                                              currentUser.id,
                                        ),
                                      ),
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
                                controller: messageController,
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
                                onSubmitted: (_) => onSendMessage(),
                              ),
                            ),
                            const SizedBox(width: 12),
                            IconButton(
                              icon: const Icon(
                                Icons.send,
                                size: 34,
                                color: Color.fromARGB(255, 45, 176, 194),
                              ),
                              onPressed: onSendMessage,
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Center(
                          // politica de privacidade
                          child: RichText(
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const PrivacyPolicyScreen(),
                                        ),
                                      );
                                    },
                                ),
                              ],
                            ),
                          ),
                        ),
                        
                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MobileChatScreen extends StatelessWidget {
  final List<Message> messages;
  final TextEditingController messageController;
  final VoidCallback onSendMessage;
  final ScrollController scrollController;
  final User recipient;

  const MobileChatScreen({
    super.key,
    required this.messages,
    required this.messageController,
    required this.onSendMessage,
    required this.scrollController,
    required this.recipient,
  });

  @override
  Widget build(BuildContext context) {
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
                      controller: scrollController,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      itemCount: messages.length,
                      itemBuilder: (context, index) {
                        final message = messages[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Align(
                            alignment: message.senderId == globals.currentUser.id
                                ? Alignment.centerRight
                                : Alignment.centerLeft,
                            child: ChatBubble(
                              text: message.message,
                              timestamp: message.timestamp,
                              isOwn: message.senderId == globals.currentUser.id,
                            ),
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
                          controller: messageController,
                          suffixIcon: IconButton(
                            tooltip: 'Enviar',
                            icon: const Icon(
                              Icons.send,
                              size: 24,
                              color: Color.fromARGB(255, 45, 176, 194),
                            ),
                            onPressed: onSendMessage,
                          ),
                          onSubmitted: (_) => onSendMessage(),
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
  final DateTime timestamp;

  const ChatBubble({super.key, required this.text, required this.timestamp, this.isOwn = true});

  @override
  Widget build(BuildContext context) {
    final f = DateFormat('dd/MM/yyyy - HH:mm', 'pt_BR');
    final bgColor = isOwn ? const Color(0xFF42C9DC) : Colors.grey[200];
    final textColor = isOwn ? Colors.white : const Color.fromARGB(221, 0, 0, 0);
    final timeColor = isOwn ? Colors.white70 : Colors.grey[600];

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
    final messageFontSize = screenWidth >= 800 ? 18.0 : 14.0;
    final timeFontSize = screenWidth >= 800 ? 12.0 : 10.0;
    final timeString = f.format(timestamp.toLocal());

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: screenWidth >= 800 ? screenWidth * 0.4 : 260,
      ),
      child: ClipRRect(
        borderRadius: borderRadius,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(color: bgColor, borderRadius: borderRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: isOwn ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                text,
                style: GoogleFonts.leagueSpartan(
                  fontSize: messageFontSize,
                  color: textColor,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                timeString,
                style: GoogleFonts.leagueSpartan(
                  fontSize: timeFontSize,
                  color: timeColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}