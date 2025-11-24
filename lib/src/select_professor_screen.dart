import 'package:flutter/material.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/helpers/api.dart';
import 'package:polieats_frontend/src/chat_screen.dart';

class SelectProfessorScreen extends StatefulWidget {
  const SelectProfessorScreen({super.key});

  @override
  _SelectProfessorScreenState createState() => _SelectProfessorScreenState();
}

class _SelectProfessorScreenState extends State<SelectProfessorScreen> {
  late Future<List<User>> _professorsFuture;

  @override
  void initState() {
    super.initState();
    _professorsFuture = Api().fetchProfessors();
  }

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
                    onTap: () => Navigator.of(context).popUntil((route) => route.isFirst),
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
                    title: const Text('Chat'),
                    selected: true,
                    selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                    selectedColor: Colors.white,
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(32),
              child: FutureBuilder<List<User>>(
                future: _professorsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text('Erro ao carregar professores: ${snapshot.error}'),
                    );
                  }

                  final professors = snapshot.data ?? [];

                  if (professors.isEmpty) {
                    return const Center(child: Text('Nenhum professor disponível'));
                  }

                  return ListView.separated(
                    itemCount: professors.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (context, index) {
                      final prof = professors[index];
                      return FractionallySizedBox(
                        widthFactor: 0.45,
                        alignment: Alignment.centerLeft,
                        child: Card(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(16),
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ChatScreen(recipient: prof),
                                ),
                              );
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                              child: Row(
                                children: [
                                  const Icon(Icons.person, size: 36, color: Color.fromARGB(255, 45, 176, 194)),
                                  const SizedBox(width: 20),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prof.name,
                                          style: const TextStyle(
                                            fontSize: 26,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          prof.email,
                                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const Icon(Icons.chat, size: 32, color: Color.fromARGB(255, 45, 176, 194)),
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
          ),
        ],
      ),
    );
  }
}