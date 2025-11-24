import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/login_screen.dart';

class UserIconDropdown extends StatefulWidget {
  final double radius;
  final Color backgroundColor;
  final Color iconColor;
  
  const UserIconDropdown({
    super.key,
    this.radius = 30,
    this.backgroundColor = const Color.fromARGB(255, 45, 176, 194),
    this.iconColor = Colors.white,
  });

  @override
  State<UserIconDropdown> createState() => _UserIconDropdownState();
}

class _UserIconDropdownState extends State<UserIconDropdown> {
  bool isDropdownOpen = false;
  final GlobalKey _buttonKey = GlobalKey();
  OverlayEntry? _overlayEntry;

  void _toggleDropdown() {
    if (isDropdownOpen) {
      _closeDropdown();
    } else {
      _openDropdown();
    }
  }

  void _openDropdown() {
    setState(() {
      isDropdownOpen = true;
    });

    final RenderBox renderBox = _buttonKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        top: offset.dy + size.height + 5,
        right: MediaQuery.of(context).size.width - offset.dx - size.width,
        child: Material(
          color: Colors.transparent,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: Offset(0, 5),
                ),
              ],
            ),
            child: IntrinsicWidth(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          globals.currentUser.name,
                          style: TextStyle(
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: Colors.grey.shade800,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          globals.currentUser.email,
                          style: TextStyle(
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                            fontSize: 14,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1, color: Colors.grey.shade300),
                  InkWell(
                    onTap: _handleLogout,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.logout,
                            size: 18,
                            color: Colors.red.shade600,
                          ),
                          SizedBox(width: 12),
                          Text(
                            'Sair',
                            style: TextStyle(
                              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              fontSize: 14,
                              color: Colors.red.shade600,
                              fontWeight: FontWeight.w500,
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
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _closeDropdown() {
    setState(() {
      isDropdownOpen = false;
    });
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  Future<void> _handleLogout() async {
    _closeDropdown();
    
    try {
      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            content: Row(
              children: [
                CircularProgressIndicator(),
                SizedBox(width: 20),
                Text(
                  'Fazendo logout...',
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  ),
                ),
              ],
            ),
          );
        },
      );

      // Perform logout
      await api.logoutUser();
      
      if (mounted) {
        // Close loading dialog
        Navigator.of(context, rootNavigator: true).pop();
        
        // Navigate to login screen and clear navigation stack
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginScreen()),
          (route) => false,
        );
      }
    } catch (e) {
      if (mounted) {
        // Close loading dialog
        Navigator.of(context, rootNavigator: true).pop();
        
        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao fazer logout: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _closeDropdown();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _toggleDropdown,
      child: Container(
        key: _buttonKey,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(100)),
          color: widget.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: CircleAvatar(
          radius: widget.radius,
          backgroundColor: Colors.transparent,
          child: Icon(
            Icons.person,
            size: widget.radius * 0.7,
            color: widget.iconColor,
          ),
        ),
      ),
    );
  }
}
