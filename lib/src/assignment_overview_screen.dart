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
            return MobileAssignmenteOverviewScreen(
              assigments: assigments, 
              selectedIndex: _selectedIndex,
              onItemTapped: _onItemTapped,
            );
            // return DesktopAssignmentOverviewScreen(
            //   assigments: assigments, 
            //   selectedIndex: _selectedIndex,
            //   onItemTapped: _onItemTapped, 
            //   homeScreen: HomeScreen(),
            // );
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
      body: ListView.builder(
        padding: EdgeInsets.zero, 
        itemCount: assigments.length,
        itemBuilder: (context, index) {
          final assignment = assigments[index];
          return AssignmentOverviewCard(assignment: assignment);
        },
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