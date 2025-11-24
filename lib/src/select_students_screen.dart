import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/assignment_overview_screen.dart';
import 'package:polieats_frontend/src/chat_screen.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

import '../main.dart';

class SelectStudentsScreen extends StatefulWidget {
  const SelectStudentsScreen({super.key});

  @override
  _SelectStudentsScreenState createState() => _SelectStudentsScreenState();
}

class _SelectStudentsScreenState extends State<SelectStudentsScreen> {
  late Future<List<User>> _studentsFuture;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      isLoading = true;
    });
    
    _studentsFuture = api.fetchStudents();
    
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(color: Colors.blue),
              SizedBox(height: 20),
              Text(
                "Carregando estudantes...",
                style: TextStyle(
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  fontSize: 16,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopSelectStudentsScreen(studentsFuture: _studentsFuture);
          } else {
            return MobileSelectStudentsScreen(studentsFuture: _studentsFuture);
          }
        },
      ),
    );
  }
}

class MobileSelectStudentsScreen extends StatelessWidget {
  final Future<List<User>> studentsFuture;

  const MobileSelectStudentsScreen({
    super.key,
    required this.studentsFuture,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                    SizedBox(width: 8),
                    Text(
                      'Chat com Estudantes',
                      style: TextStyle(
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                FutureBuilder<List<User>>(
                  future: studentsFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Column(
                          children: [
                            CircularProgressIndicator(),
                            SizedBox(height: 16),
                            Text(
                              'Carregando estudantes...',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(Icons.error, size: 64, color: Colors.red),
                            SizedBox(height: 16),
                            Text(
                              'Erro ao carregar estudantes',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red,
                              ),
                            ),
                            Text(
                              '${snapshot.error}',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    final students = snapshot.data ?? [];

                    if (students.isEmpty) {
                      return Center(
                        child: Column(
                          children: [
                            Icon(Icons.person_outline, size: 64, color: Colors.grey.shade400),
                            SizedBox(height: 16),
                            Text(
                              'Nenhum estudante disponível',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 18,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            Text(
                              'Tente novamente mais tarde',
                              style: TextStyle(
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                fontSize: 14,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: students.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 12),
                      itemBuilder: (context, index) {
                        final student = students[index];
                        return Card(
                          elevation: 0,
                          color: Colors.grey.shade50,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(recipient: student),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
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
                                          student.name,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          student.email,
                                          style: TextStyle(
                                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                            fontSize: 14,
                                            color: Colors.grey.shade600,
                                          ),
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
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
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
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(builder: (context) => 
                          globals.currentUser.role == UserRole.STUDENT
                            ? HomeScreen()
                            : AdminHomeScreen()),
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

class DesktopSelectStudentsScreen extends StatelessWidget {
  final Future<List<User>> studentsFuture;

  const DesktopSelectStudentsScreen({
    super.key,
    required this.studentsFuture,
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
                      Navigator.of(context).pushReplacement(
                        MaterialPageRoute(builder: (context) => 
                          globals.currentUser.role == UserRole.STUDENT
                            ? HomeScreen()
                            : AdminHomeScreen()),
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
                    title: const Text('Chat'),
                    selected: true,
                    selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                    selectedColor: Colors.white,
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
                height: dividerHeight > 0 ? dividerHeight : size.height,
                color: Colors.grey.shade300,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Chat com Estudantes',
                    style: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Selecione um estudante para iniciar uma conversa.',
                    style: TextStyle(
                      fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  SizedBox(height: 40),
                  Expanded(
                    child: FutureBuilder<List<User>>(
                      future: studentsFuture,
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                CircularProgressIndicator(color: const Color.fromARGB(255, 45, 176, 194)),
                                SizedBox(height: 20),
                                Text(
                                  'Carregando estudantes...',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 18,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        } else if (snapshot.hasError) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.error, size: 80, color: Colors.red),
                                SizedBox(height: 20),
                                Text(
                                  'Erro ao carregar estudantes',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.red,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  '${snapshot.error}',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        final students = snapshot.data ?? [];

                        if (students.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.person_outline, size: 80, color: Colors.grey.shade400),
                                SizedBox(height: 20),
                                Text(
                                  'Nenhum estudante disponível',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text(
                                  'Tente novamente mais tarde',
                                  style: TextStyle(
                                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                    fontSize: 16,
                                    color: Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.separated(
                          itemCount: students.length,
                          separatorBuilder: (_, __) => const SizedBox(height: 16),
                          itemBuilder: (context, index) {
                            final student = students[index];
                            return FractionallySizedBox(
                              widthFactor: 0.6,
                              alignment: Alignment.centerLeft,
                              child: Card(
                                elevation: 0,
                                color: Colors.grey.shade50,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(16),
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ChatScreen(recipient: student),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(24),
                                    child: Row(
                                      children: [
                                        CircleAvatar(
                                          radius: 40,
                                          backgroundColor: const Color.fromARGB(255, 45, 176, 194),
                                          child: Icon(Icons.person, size: 40, color: Colors.white),
                                        ),
                                        const SizedBox(width: 24),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                student.name,
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 8),
                                              Text(
                                                student.email,
                                                style: TextStyle(
                                                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                                                  fontSize: 16,
                                                  color: Colors.grey.shade600,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Icon(
                                          Icons.chat,
                                          size: 36,
                                          color: const Color.fromARGB(255, 45, 176, 194),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        );
                      },
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
