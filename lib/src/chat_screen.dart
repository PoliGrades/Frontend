import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/assignment_overview_screen.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/data/Message.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/privacy_policy_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';
import 'package:polieats_frontend/src/socket_service.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

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
    socketService.emit("joinChat", [globals.currentUser.role == UserRole.STUDENT
        ? widget.recipient.id
        : globals.currentUser.id]);
  }

  void _sendMessage() {
    final text = _messageController.text.trim();
    if (text.isEmpty) return;

    // Send message via socket
    socketService.emit("sendMessage", [{
      'professorID': globals.currentUser.role == UserRole.STUDENT
          ? widget.recipient.id
          : globals.currentUser.id,
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
    final appBarHeight = kToolbarHeight + MediaQuery.of(context).padding.top;
    final dividerHeight = size.height - appBarHeight;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            UserIconDropdown(radius: 20),
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
                        MaterialPageRoute(builder: (context) => 
                          globals.currentUser.role == UserRole.STUDENT
                            ? HomeScreen()
                            : AdminHomeScreen()
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
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => CourseOverviewScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.assignment),
                    title: const Text('Atividades'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => AssignmentOverviewScreen()),
                      );
                    },
                  ),
                  const SizedBox(height: 20),
                  ListTile(
                    leading: const Icon(Icons.person),
                    title: const Text('Perfil'),
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => ProfileScreen()),
                      );
                    },
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
                    onTap: () {
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => SelectProfessorScreen()),
                      );
                    },
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
                height: dividerHeight > 0 ? dividerHeight : size.height,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          
          // Área do chat
          Expanded(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        tooltip: 'Voltar',
                        icon: const Icon(
                          Icons.arrow_back,
                          size: 28,
                          color: Colors.grey,
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const SizedBox(width: 16),
                      CircleAvatar(
                        radius: 30,
                        backgroundColor: const Color.fromARGB(255, 45, 176, 194),
                        child: Icon(Icons.person, size: 30, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              recipient.name,
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey[800],
                              ),
                            ),
                            Text(
                              recipient.email,
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),

                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(32),
                    child: Column(
                      children: [
                        Expanded(
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: Colors.grey.shade200),
                            ),
                            padding: const EdgeInsets.all(24),
                            child: messages.isEmpty 
                              ? Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.chat_bubble_outline,
                                        size: 64,
                                        color: Colors.grey.shade400,
                                      ),
                                      SizedBox(height: 16),
                                      Text(
                                        'Nenhuma mensagem ainda',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey.shade600,
                                        ),
                                      ),
                                      Text(
                                        'Envie uma mensagem para iniciar a conversa',
                                        style: TextStyle(
                                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                          fontSize: 16,
                                          color: Colors.grey.shade400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : ListView.builder(
                                  controller: scrollController,
                                  padding: EdgeInsets.zero,
                                  itemCount: messages.length,
                                  itemBuilder: (context, index) {
                                    final message = messages[index];
                                    return Padding(
                                      padding: const EdgeInsets.only(bottom: 16),
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
                        ),
                        const SizedBox(height: 24),
                        // Campo de mensagem
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(color: Colors.grey.shade300),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.1),
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: messageController,
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 16,
                                  ),
                                  decoration: InputDecoration(
                                    hintText: 'Digite sua mensagem...',
                                    hintStyle: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                      color: Colors.grey[500],
                                      fontSize: 16,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 20,
                                      vertical: 16,
                                    ),
                                    border: InputBorder.none,
                                  ),
                                  onSubmitted: (_) => onSendMessage(),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.send,
                                    size: 24,
                                    color: Color.fromARGB(255, 45, 176, 194),
                                  ),
                                  onPressed: onSendMessage,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: RichText(
                            textAlign: TextAlign.center,
                            text: TextSpan(
                              children: [
                                TextSpan(
                                  text: 'Todas as mensagens enviadas são utilizadas de acordo com a nossa ',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 14,
                                    color: Colors.grey[600],
                                  ),
                                ),
                                TextSpan(
                                  text: 'Política de Privacidade.',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 14,
                                    color: const Color.fromARGB(255, 45, 176, 194),
                                    decoration: TextDecoration.underline,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const PrivacyPolicyScreen(),
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
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 20,
              left: 8,
              right: 8,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: Row(
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
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    const SizedBox(width: 12),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: const Color.fromARGB(255, 45, 176, 194),
                      child: Icon(Icons.person, size: 25, color: Colors.white),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            recipient.name,
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[800],
                            ),
                          ),
                          Text(
                            recipient.email,
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    Icon(
                      Icons.chat,
                      size: 24,
                      color: const Color.fromARGB(255, 45, 176, 194),
                    ),
                  ],
                ),
              ),
            ),
            Positioned(
              top: 100,
              left: 0,
              right: 0,
              bottom: 0,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  16,
                  16,
                  16,
                  MediaQuery.of(context).viewInsets.bottom + 16,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: messages.isEmpty 
                          ? Center(
                              child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.chat_bubble_outline,
                                      size: 48,
                                      color: Colors.grey.shade400,
                                    ),
                                    SizedBox(height: 16),
                                    Text(
                                      'Nenhuma mensagem ainda',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey.shade600,
                                      ),
                                    ),
                                    Text(
                                      'Envie uma mensagem para iniciar',
                                      style: TextStyle(
                                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                        fontSize: 14,
                                        color: Colors.grey.shade400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            )
                          : ListView.builder(
                              controller: scrollController,
                              padding: const EdgeInsets.all(16),
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                final message = messages[index];
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
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
                    ),
                    SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: Colors.grey.shade300),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.1),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: TextField(
                              controller: messageController,
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 16,
                              ),
                              decoration: InputDecoration(
                                hintText: 'Digite sua mensagem...',
                                hintStyle: TextStyle(
                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                  color: Colors.grey[500],
                                  fontSize: 16,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                border: InputBorder.none,
                              ),
                              onSubmitted: (_) => onSendMessage(),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: IconButton(
                              tooltip: 'Enviar',
                              icon: const Icon(
                                Icons.send,
                                size: 20,
                                color: Color.fromARGB(255, 45, 176, 194),
                              ),
                              onPressed: onSendMessage,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Center(
                      child: RichText(
                        textAlign: TextAlign.center,
                        text: TextSpan(
                          children: [
                            TextSpan(
                              text: 'Todas as mensagens são utilizadas de acordo com a nossa ',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 11,
                                color: Colors.grey[600],
                              ),
                            ),
                            TextSpan(
                              text: 'política de privacidade.',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 11,
                                color: const Color.fromARGB(255, 45, 176, 194),
                                decoration: TextDecoration.underline,
                              ),
                              recognizer: TapGestureRecognizer()
                                ..onTap = () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => const PrivacyPolicyScreen(),
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
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: const Color.fromARGB(255, 45, 176, 194),
        currentIndex: 4,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        onTap: (value) {
          switch (value) {
            case 0:
              Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => 
                          globals.currentUser.role == UserRole.STUDENT
                            ? HomeScreen()
                            : AdminHomeScreen()),
                (route) => false,
              );
              break;
            case 1:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => CourseOverviewScreen()),
              );
              break;
            case 2:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => AssignmentOverviewScreen()),
              );
              break;
            case 3:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => ProfileScreen()),
              );
              break;
            case 4:
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => SelectProfessorScreen()),
              );
              break;
          }
        },
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Matérias'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
          BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
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