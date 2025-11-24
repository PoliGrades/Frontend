import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/main.dart';
import 'package:polieats_frontend/src/admin_home_screen.dart';
import 'package:polieats_frontend/src/course_overview_screen.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/home_screen.dart';
import 'package:polieats_frontend/src/management_screen.dart';
import 'package:polieats_frontend/src/select_professor_screen.dart';
import 'package:polieats_frontend/src/widgets/user_icon_dropdown.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool isLoading = false;

  // Mock data for user statistics
  final Map<String, dynamic> userStats = {
    'totalAssignments': 24,
    'completedAssignments': 18,
    'totalClasses': 8,
    'averageGrade': 8.5,
    'attendanceRate': 92,
    'rankingPosition': 3,
    'totalStudents': 45,
  };

  final List<Map<String, dynamic>> subjectGrades = [
    {'name': 'Matemática', 'grade': 9.2, 'color': Colors.blue.shade500},
    {'name': 'Português', 'grade': 8.5, 'color': Colors.red.shade500},
    {'name': 'História', 'grade': 8.8, 'color': Colors.green.shade500},
    {'name': 'Geografia', 'grade': 7.9, 'color': Colors.orange.shade500},
    {'name': 'Química', 'grade': 8.1, 'color': Colors.purple.shade500},
    {'name': 'Física', 'grade': 8.9, 'color': Colors.teal.shade500},
  ];

  final List<Map<String, dynamic>> monthlyPerformance = [
    {'month': 'Jan', 'grade': 7.5},
    {'month': 'Fev', 'grade': 8.0},
    {'month': 'Mar', 'grade': 7.8},
    {'month': 'Abr', 'grade': 8.5},
    {'month': 'Mai', 'grade': 8.9},
    {'month': 'Jun', 'grade': 8.7},
  ];

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth > 1000) {
          return _buildDesktopLayout(context);
        } else {
          return _buildMobileLayout(context);
        }
      },
    );
  }

  Widget _buildDesktopLayout(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.asset('assets/images/logo.png', width: 40, height: 40),
            UserIconDropdown(radius: 20),
          ],
        ),
      ),
      body: Row(
        children: <Widget>[
          _buildSidebar(context, size),
          _buildDivider(size.height, size),
          Expanded(
            child: _buildProfileContent(context, isDesktop: true),
          ),
        ],
      ),
    );
  }

  Widget _buildMobileLayout(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Perfil',
          style: TextStyle(
            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: _buildProfileContent(context, isDesktop: false),
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
        currentIndex: 3,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Início'),
          BottomNavigationBarItem(icon: Icon(Icons.book), label: 'Matérias'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Atividades'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Perfil'),
        ],
      ),
    );
  }

  Widget _buildSidebar(BuildContext context, Size size) {
    return SizedBox(
      width: size.width * 0.20,
      child: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          spacing: 20,
          children: [
            ListTile(
              leading: Icon(Icons.home),
              title: Text('Início'),
              selected: false,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => globals.currentUser.role == UserRole.STUDENT ? HomeScreen() : AdminHomeScreen(),
                ));
              },
            ),
            if (globals.currentUser.role != UserRole.STUDENT) ...[
              ListTile(
                leading: Icon(Icons.manage_accounts),
                title: Text('Gerenciar'),
                selected: false,
                selectedTileColor: Color.fromARGB(255, 45, 176, 194),
                selectedColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(6)),
                ),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ManagementScreen(),
                    ),
                  );
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.book),
              title: Text('Matérias'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => CourseOverviewScreen()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.assignment),
              title: Text('Atividades'),
              selected: false,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text('Perfil'),
              selected: true,
              selectedTileColor: Color.fromARGB(255, 45, 176, 194),
              selectedColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(6)),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: Icon(Icons.chat),
              title: Text('Chat'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SelectProfessorScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDivider(double dividerHeight, Size size) {
    return SizedBox(
      width: 20,
      child: Center(
        child: Container(
          width: 1,
          height: dividerHeight > 0 ? dividerHeight : size.height,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }

  Widget _buildProfileContent(BuildContext context, {required bool isDesktop}) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(isDesktop ? 32.0 : 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // User Header
              _buildUserHeader(isDesktop),
              SizedBox(height: isDesktop ? 40 : 30),

              // Statistics Cards
              _buildStatisticsCards(isDesktop),
              SizedBox(height: isDesktop ? 40 : 30),

              // Charts Section
              if (isDesktop) ...[
                Row(
                  children: [
                    Expanded(child: _buildSubjectGradesChart(isDesktop)),
                    SizedBox(width: 30),
                    Expanded(child: _buildPerformanceTrendChart(isDesktop)),
                  ],
                ),
              ] else ...[
                _buildSubjectGradesChart(isDesktop),
                SizedBox(height: 30),
                _buildPerformanceTrendChart(isDesktop),
              ],

              SizedBox(height: isDesktop ? 40 : 30),

              // Assignment completion chart
              _buildAssignmentCompletionChart(isDesktop),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUserHeader(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue.shade600, Colors.blue.shade800],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.blue.withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  globals.currentUser.name,
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: isDesktop ? 28 : 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  '${globals.currentUser.role == UserRole.STUDENT ? "Aluno" : "Professor"} • 2º Ano B',
                  style: TextStyle(
                    fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                    fontSize: isDesktop ? 16 : 14,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                SizedBox(height: 16),
                Row(
                  children: [
                    Icon(Icons.school, color: Colors.white.withOpacity(0.9), size: 16),
                    SizedBox(width: 8),
                    Text(
                      'Ranking: ${userStats['rankingPosition']}º de ${userStats['totalStudents']}',
                      style: TextStyle(
                        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.9),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          CircleAvatar(
            radius: isDesktop ? 40 : 35,
            backgroundColor: Colors.white.withOpacity(0.2),
            child: Icon(
              Icons.person,
              size: isDesktop ? 40 : 35,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatisticsCards(bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 4 : 2,
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: isDesktop ? 1.2 : 1.0,
      children: [
        _buildStatCard(
          'Atividades',
          '${userStats['completedAssignments']}/${userStats['totalAssignments']}',
          Icons.assignment_turned_in,
          Colors.green,
          isDesktop,
        ),
        _buildStatCard(
          'Turmas',
          '${userStats['totalClasses']}',
          Icons.class_,
          Colors.blue,
          isDesktop,
        ),
        _buildStatCard(
          'Média Geral',
          '${userStats['averageGrade'].toStringAsFixed(1)}',
          Icons.star,
          Colors.orange,
          isDesktop,
        ),
        _buildStatCard(
          'Frequência',
          '${userStats['attendanceRate']}%',
          Icons.calendar_today,
          Colors.purple,
          isDesktop,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color, bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 20 : 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: isDesktop ? 32 : 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: isDesktop ? 24 : 20,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: color,
            ),
          ),
          SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: isDesktop ? 14 : 12,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
              color: Colors.grey.shade600,
            ),
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectGradesChart(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Notas por Matéria',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: isDesktop ? 300 : 250,
            child: BarChart(
              BarChartData(
                barGroups: subjectGrades.asMap().entries.map((entry) {
                  return BarChartGroupData(
                    x: entry.key,
                    barRods: [
                      BarChartRodData(
                        toY: entry.value['grade'],
                        color: entry.value['color'],
                        width: isDesktop ? 30 : 20,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  );
                }).toList(),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < subjectGrades.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              subjectGrades[value.toInt()]['name'].toString().substring(0, 3),
                              style: TextStyle(
                                fontSize: 10,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                maxY: 10,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPerformanceTrendChart(bool isDesktop) {
    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Evolução das Notas',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            ),
          ),
          SizedBox(height: 20),
          SizedBox(
            height: isDesktop ? 300 : 250,
            child: LineChart(
              LineChartData(
                lineBarsData: [
                  LineChartBarData(
                    spots: monthlyPerformance.asMap().entries.map((entry) {
                      return FlSpot(entry.key.toDouble(), entry.value['grade']);
                    }).toList(),
                    isCurved: true,
                    color: Colors.blue.shade600,
                    barWidth: 3,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        return FlDotCirclePainter(
                          radius: 4,
                          color: Colors.white,
                          strokeWidth: 2,
                          strokeColor: Colors.blue.shade600,
                        );
                      },
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Colors.blue.shade600.withOpacity(0.1),
                    ),
                  ),
                ],
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        if (value.toInt() < monthlyPerformance.length) {
                          return Padding(
                            padding: EdgeInsets.only(top: 8),
                            child: Text(
                              monthlyPerformance[value.toInt()]['month'],
                              style: TextStyle(
                                fontSize: 12,
                                fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                              ),
                            ),
                          );
                        }
                        return Text('');
                      },
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toStringAsFixed(0),
                          style: TextStyle(
                            fontSize: 12,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  horizontalInterval: 1,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.grey.shade200,
                      strokeWidth: 1,
                    );
                  },
                ),
                borderData: FlBorderData(show: false),
                maxY: 10,
                minY: 0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAssignmentCompletionChart(bool isDesktop) {
    final completionPercentage = (userStats['completedAssignments'] / userStats['totalAssignments'] * 100);
    final pendingPercentage = 100 - completionPercentage;

    return Container(
      padding: EdgeInsets.all(isDesktop ? 24 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Status das Atividades',
            style: TextStyle(
              fontSize: isDesktop ? 20 : 18,
              fontWeight: FontWeight.bold,
              fontFamily: GoogleFonts.leagueSpartan().fontFamily,
            ),
          ),
          SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: isDesktop ? 200 : 160,
                  child: PieChart(
                    PieChartData(
                      sections: [
                        PieChartSectionData(
                          color: Colors.green.shade500,
                          value: completionPercentage,
                          radius: isDesktop ? 80 : 60,
                          title: '${completionPercentage.toStringAsFixed(0)}%',
                          titleStyle: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        ),
                        PieChartSectionData(
                          color: Colors.orange.shade500,
                          value: pendingPercentage.toDouble(),
                          radius: isDesktop ? 80 : 60,
                          title: '${pendingPercentage.toStringAsFixed(0)}%',
                          titleStyle: TextStyle(
                            fontSize: isDesktop ? 16 : 14,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          ),
                        ),
                      ],
                      centerSpaceRadius: isDesktop ? 40 : 30,
                      sectionsSpace: 2,
                    ),
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem(
                      'Concluídas',
                      '${userStats['completedAssignments']}',
                      Colors.green.shade500,
                      isDesktop,
                    ),
                    SizedBox(height: 16),
                    _buildLegendItem(
                      'Pendentes',
                      '${userStats['totalAssignments'] - userStats['completedAssignments']}',
                      Colors.orange.shade500,
                      isDesktop,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, String value, Color color, bool isDesktop) {
    return Row(
      children: [
        Container(
          width: isDesktop ? 16 : 14,
          height: isDesktop ? 16 : 14,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: isDesktop ? 14 : 12,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                  color: Colors.grey.shade600,
                ),
              ),
              Text(
                value,
                style: TextStyle(
                  fontSize: isDesktop ? 18 : 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
