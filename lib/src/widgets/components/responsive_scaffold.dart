import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/management_screen.dart';
import 'package:polieats_frontend/src/profile_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';

enum NavigationItem {
  home,
  management,
  activities,
  profile,
  chat,
}

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.currentIndex = NavigationItem.home,
    this.appBar,
    this.isAdmin = false,
  });

  final Widget body;
  final NavigationItem currentIndex;
  final PreferredSizeWidget? appBar;
  final bool isAdmin;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 800) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar,
      body: body,
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        type: BottomNavigationBarType.fixed,
        iconSize: 24,
        selectedItemColor: Colors.blue,
        selectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        unselectedLabelStyle: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
          fontSize: 12,
        ),
        currentIndex: _getBottomNavIndex(),
        onTap: (value) => _onNavigationTap(context, value),
        items: _getNavigationItems(),
      ),
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;
    
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: appBar ?? AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Colors.transparent,
              child: Icon(Icons.person, size: 20, color: Colors.blue),
            ),
            SizedBox(width: 12),
            Text(
              globals.currentUser.name,
              style: TextStyle(
                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
      body: Row(
        children: [
          // Sidebar
          SizedBox(
            width: size.width * 0.20,
            child: Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                border: Border(
                  right: BorderSide(color: Colors.grey.shade200, width: 1),
                ),
              ),
              child: Column(
                spacing: 12,
                children: _getSidebarItems(context),
              ),
            ),
          ),
          // Main content
          Expanded(
            child: body,
          ),
        ],
      ),
    );
  }

  List<Widget> _getSidebarItems(BuildContext context) {
    return [
      _buildSidebarItem(
        context,
        icon: Icons.home,
        title: 'Início',
        isSelected: currentIndex == NavigationItem.home,
        onTap: () => _onNavigationTap(context, 0),
      ),
      _buildSidebarItem(
        context,
        icon: Icons.book,
        title: isAdmin ? 'Gerenciar' : 'Matérias',
        isSelected: currentIndex == NavigationItem.management,
        onTap: () => _onNavigationTap(context, 1),
      ),
      _buildSidebarItem(
        context,
        icon: Icons.assignment,
        title: 'Atividades',
        isSelected: currentIndex == NavigationItem.activities,
        onTap: () => _onNavigationTap(context, 2),
      ),
      _buildSidebarItem(
        context,
        icon: Icons.person,
        title: 'Perfil',
        isSelected: currentIndex == NavigationItem.profile,
        onTap: () => _onNavigationTap(context, 3),
      ),
      _buildSidebarItem(
        context,
        icon: Icons.chat,
        title: 'Chat',
        isSelected: currentIndex == NavigationItem.chat,
        onTap: () => _onNavigationTap(context, 4),
      ),
    ];
  }

  Widget _buildSidebarItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return ListTile(
      leading: Icon(icon),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
        ),
      ),
      selected: isSelected,
      selectedTileColor: Color.fromARGB(255, 45, 176, 194),
      selectedColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      onTap: onTap,
    );
  }

  int _getBottomNavIndex() {
    switch (currentIndex) {
      case NavigationItem.home:
        return 0;
      case NavigationItem.management:
        return 1;
      case NavigationItem.activities:
        return 2;
      case NavigationItem.profile:
        return 3;
      case NavigationItem.chat:
        return 4;
    }
  }

  List<BottomNavigationBarItem> _getNavigationItems() {
    return [
      BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
      BottomNavigationBarItem(
        icon: Icon(Icons.book),
        label: isAdmin ? 'Gerenciar' : 'Matérias',
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.assignment),
        label: 'Atividades',
      ),
      BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
      BottomNavigationBarItem(icon: Icon(Icons.chat), label: 'Chat'),
    ];
  }

  void _onNavigationTap(BuildContext context, int value) {
    switch (value) {
      case 0: // Home
        if (currentIndex != NavigationItem.home) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => 
                          globals.currentUser.role == UserRole.STUDENT
                            ? HomeScreen()
                            : AdminHomeScreen()),
          );
        }
        break;
      case 1: // Management/Courses
        if (currentIndex != NavigationItem.management) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ManagementScreen()),
          );
        }
        break;
      case 2: // Activities
        // You can add navigation to activities screen here
        break;
      case 3: // Profile
        if (currentIndex != NavigationItem.profile) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ProfileScreen()),
          );
        }
        break;
      case 4: // Chat
        if (currentIndex != NavigationItem.chat) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => SelectProfessorScreen(),
            ),
          );
        }
        break;
    }
  }
}
