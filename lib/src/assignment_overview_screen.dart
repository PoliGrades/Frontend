import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/widgets/assignment_overview_card.dart';
import 'package:intl/date_symbol_data_local.dart';

class AssignmentOverviewScreen extends StatefulWidget{
  const AssignmentOverviewScreen({super.key});
    @override
  State<StatefulWidget> createState() => _AssignmentOverviewScreen();    
}

class _AssignmentOverviewScreen extends State<AssignmentOverviewScreen> {
  final assignmentController = Assignments();
  late final List<Assignment> assigments;
  final colorScheme = ColorScheme.fromSeed(
    seedColor: Color.fromARGB(255, 45, 176, 194),
  );

  int _selectedIndex = 2;

  @override
  void initState(){
    super.initState();
    assigments = assignmentController.assignments;
  }

  void _onItemTapped(int index){
    setState(() {
      _selectedIndex = index;
    });
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } 
    else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const CourseOverviewScreen()),
      );
    } 
    else if (index == 2) {
      return;
    } 
    else if (index == 3){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    initializeDateFormatting('pt_BR', null);
    final f = DateFormat('dd/MM/yyyy', 'pt_BR');

    return Scaffold(
      backgroundColor: colorScheme.primary,
      body: LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth >= 800) {
            return DesktopAssignmentOverviewScreen(
              assignments: assigments, 
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped, 
              homeScreen: HomeScreen(),
            );
          } else {
            return MobileAssignmenteOverviewScreen(
              assigments: assigments, 
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            );
          }
        },
      ),
    );
  }
}

class MobileAssignmenteOverviewScreen extends StatelessWidget{
  final List<Assignment> assigments;
  final int selectedIndex;
  final ValueChanged<int> onItemTapped;
  

  const MobileAssignmenteOverviewScreen({
     super.key, 
    required this.assigments, 
    required this.selectedIndex,
    required this.onItemTapped
  });

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final futureAssignments = assigments.where((a) => a.dueDate.isAfter(now)).toList();
    final pastAssignments = assigments.where((a) => a.dueDate.isBefore(now)).toList();
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 100,
        title: Text(
          "Minhas atividades",
          style: TextStyle(
            color: Colors.black,
            fontFamily:GoogleFonts.leagueSpartan().fontFamily,
            fontSize: 22
          ),
        ),              
        elevation: 0,
      ),
      body: ListView(
      padding: EdgeInsets.zero,
      children: [
        if (futureAssignments.isNotEmpty) ...[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text("Atividades futuras",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                )),
          ),
          ...futureAssignments.map((a) => AssignmentOverviewCard(assignment: a)),
        ],
        if (pastAssignments.isNotEmpty) ...[
          Padding(
            //padding: const EdgeInsets.all(16.0),
            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
            child: Text("Atividades passadas",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                )),
          ),
          ...pastAssignments.map((a) => AssignmentOverviewCard(assignment: a)),
        ],
      ],
    ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: selectedIndex,
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.grey,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        onTap: onItemTapped,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Matérias'),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Atividades',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }
}

class DesktopAssignmentOverviewScreen extends StatelessWidget{
  final int selectedIndex;
  final List<Assignment> assignments;
  final ValueChanged<int> onItemTapped;
  final Widget homeScreen;

  DesktopAssignmentOverviewScreen({
    super.key, 
    required this.assignments, 
    required this.selectedIndex, 
    required this.onItemTapped,
    required this.homeScreen,
  });
  final colorScheme = ColorScheme.fromSeed(
      seedColor: Color.fromARGB(255, 45, 176, 194),
  );
  final Color selectedTileHighlight = Color.fromARGB(255, 45, 176, 194);
  final Color primaryColor = Color.fromARGB(255, 45, 176, 194);
  final Color defaultInactiveColor = Colors.black54;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final now = DateTime.now();
    final futureAssignments = assignments.where((a) => a.dueDate.isAfter(now)).toList();
    final pastAssignments = assignments.where((a) => a.dueDate.isBefore(now)).toList();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            Container(
              margin: EdgeInsets.only(left: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100)),
                color: colorScheme.primary,
                boxShadow: [
                  BoxShadow(
                    color: Colors.white,
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.transparent,
                child: Icon(Icons.person, size: 20, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Lateral menu
            SizedBox(
              width: size.width * 0.20,
              child: Container(
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                child: Column(
                  spacing: 20,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      leading: Icon(
                       Icons.home,
                       color: selectedIndex == 0 ? Colors.white : defaultInactiveColor,
                      ),
                      title: Text(
                        'Início', 
                        style: TextStyle(
                          color: selectedIndex == 0 ? Colors.white : defaultInactiveColor,
                        )
                      ),
                      selected: selectedIndex == 0,
                      selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                      selectedColor: Colors.white,
                      // Make it rounded
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(6)),
                      ),
                      onTap: () => onItemTapped(0),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.book,
                        color: selectedIndex == 1 ? Colors.white : defaultInactiveColor,
                      ),
                      title: Text(
                        'Matérias', 
                        style: TextStyle(
                          color: selectedIndex == 1 ? Colors.white : defaultInactiveColor,
                        )
                      ),
                      selected: selectedIndex == 1,
                      selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                      selectedColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6)),
                      onTap: () => onItemTapped(1),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.assignment,
                        color: selectedIndex == 2 ? Colors.white : defaultInactiveColor,
                        ),
                      title: Text(
                        'Atividades',
                        style: TextStyle(
                          color: selectedIndex == 2 ? Colors.white : defaultInactiveColor,
                        )
                      ),
                      selected: selectedIndex == 2,
                      selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      onTap: () => onItemTapped(2),
                    ),
                    ListTile(
                      leading: Icon(
                        Icons.person,
                        color: selectedIndex == 3 ? Colors.white : defaultInactiveColor,
                        ),
                      title: Text(
                        'Perfil',
                        style: TextStyle(
                          color: selectedIndex == 3 ? Colors.white : defaultInactiveColor,
                        )
                      ),
                      selected: selectedIndex == 3,
                      selectedTileColor: const Color.fromARGB(255, 45, 176, 194),
                        selectedColor: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(6)),
                      onTap: () => onItemTapped(3),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Vertical divider that accounts for the AppBar height
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
            child: Center(
              child: SizedBox(
                width: 800, 
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Text(
                      "Minhas Atividades",
                      style: TextStyle(
                          fontSize: 24,
                          fontFamily:GoogleFonts.leagueSpartan().fontFamily,
                          color: Colors.black87,
                      ),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.0),
                  ),
                  Expanded(
                    child: ListView(
                      padding: const EdgeInsets.only(top: 0.0),
                      children: [
                        if (futureAssignments.isNotEmpty) ...[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
                            child: Text(
                              "Atividades futuras",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                          ),
                          ...futureAssignments.map((a) => AssignmentOverviewCard(assignment: a)),
                        ],
                        if (pastAssignments.isNotEmpty) ...[
                          Padding(
                            padding: const 
                            EdgeInsets.fromLTRB(16.0, 30.0, 16.0, 16.0),
                            child: Text(
                              "Atividades passadas",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                          ),
                          ...pastAssignments.map((a) => AssignmentOverviewCard(assignment: a)),
                        ],
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ]),   
    );
  }
}


