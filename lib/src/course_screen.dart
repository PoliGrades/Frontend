import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:polieats_frontend/src/data/Assignments.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Grades.dart';
import 'package:polieats_frontend/src/helpers/icon_map.dart';

class CourseScreen extends StatefulWidget {
  const CourseScreen({super.key, required this.course});

  final Course course;

  @override
  _CourseScreenState createState() => _CourseScreenState();
}

class _CourseScreenState extends State<CourseScreen> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final f = DateFormat('dd/MM/yyyy');

    final assignmentsController = Assignments();
    final assignments = assignmentsController.getAssignmentsForCourse(
      widget.course.name,
    );

    final gradesController = Grades();
    final grades = gradesController.getGradesForCourse(widget.course.name);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            spacing: 16,
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(1000),
                                  ),
                                  color: widget.course.accentColor,
                                ),
                                child: Icon(
                                  iconMap[widget.course.name] ?? Icons.help,
                                  size: 35,
                                  color: widget.course.color,
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.course.name,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                      fontSize: 24,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    "Docente: teste",
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        "Atividades",
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.horizontal,
                          physics: BouncingScrollPhysics(),
                          itemCount: assignments.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(width: 10);
                          },
                          itemBuilder: (context, index) {
                            final assignment = assignments[index];

                            // ignore: sized_box_for_whitespace
                            return Container(
                              width: size.width * 0.60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.grey.shade50,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    height: 100,
                                    decoration: BoxDecoration(
                                      color: widget.course.color,
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(10),
                                        topRight: Radius.circular(10),
                                      ),
                                    ),
                                    child: Stack(
                                      children: [
                                        Positioned(
                                          top: 8,
                                          left: 8,
                                          child: Container(
                                            padding: EdgeInsets.symmetric(
                                              vertical: 4,
                                              horizontal: 8,
                                            ),
                                            decoration: BoxDecoration(
                                              color: Colors.white70,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(20),
                                              ),
                                            ),
                                            child: Text(
                                              f.format(assignment.dueDate),
                                              style: TextStyle(
                                                fontFamily:
                                                    GoogleFonts.leagueSpartan()
                                                        .fontFamily,
                                                fontSize: 12,
                                                color: widget.course.color,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          bottom: -12,
                                          right: 8,
                                          child: Icon(
                                            iconMap[widget.course.name] ?? Icons.help,
                                            size: 64,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Container(
                                    padding: EdgeInsets.only(left: 10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          assignment.title,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.leagueSpartan()
                                                    .fontFamily,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          assignment.course,
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.leagueSpartan()
                                                    .fontFamily,
                                            fontSize: 12,
                                            color: Colors.grey,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        "Minhas notas",
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 18,
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          scrollDirection: Axis.vertical,
                          physics: BouncingScrollPhysics(),
                          itemCount: grades.length,
                          separatorBuilder: (context, index) {
                            return SizedBox(height: 10);
                          },
                          itemBuilder: (context, index) {
                            final grade = grades[index];

                            // ignore: sized_box_for_whitespace
                            return Container(
                              height: 120,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.all(
                                  Radius.circular(10),
                                ),
                                color: Colors.grey.shade50,
                              ),
                              padding: EdgeInsets.all(10),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        f.format(grade.dateRecorded),
                                        style: TextStyle(
                                          fontFamily:
                                              GoogleFonts.leagueSpartan()
                                                  .fontFamily,
                                          fontSize: 12,
                                          color: Colors.grey,
                                        ),
                                      ),
                                      // A container badge that shows if the grade is higher than 60% of maxScore
                                      Container(
                                        margin: EdgeInsets.only(left: 10),
                                        padding: EdgeInsets.symmetric(
                                          vertical: 2,
                                          horizontal: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              grade.score >=
                                                  0.6 * grade.maxScore
                                              ? Colors.green
                                              : Colors.red,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                        ),
                                        child: Text(
                                          grade.score >= 0.6 * grade.maxScore
                                              ? "Aprovado"
                                              : "Reprovado",
                                          style: TextStyle(
                                            fontFamily:
                                                GoogleFonts.leagueSpartan()
                                                    .fontFamily,
                                            fontSize: 12,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    grade.assignmentName,
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(height: 6),
                                  Text(
                                    "Nota: ${grade.score.toStringAsFixed(1)}/${grade.maxScore.toStringAsFixed(1)}",
                                    style: TextStyle(
                                      fontFamily: GoogleFonts.leagueSpartan()
                                          .fontFamily,
                                      fontSize: 16,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                  color: Colors.white12,
                  width: size.width,
                  height: 350,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    spacing: 15,
                    children: [
                      Text(
                        "Meu desempenho",
                        style: TextStyle(
                          fontFamily: GoogleFonts.leagueSpartan().fontFamily,
                          fontSize: 18,
                        ),
                      ),
                      // Using fl_chart to create a line chart showing the grades over time and the average line
                      Expanded(
                        child: LineChart(
                          LineChartData(
                            gridData: FlGridData(show: true),
                            titlesData: FlTitlesData(
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: true),
                              ),
                            ),
                            borderData: FlBorderData(show: true),
                            lineBarsData: [
                              LineChartBarData(
                                spots: grades
                                    .asMap()
                                    .entries
                                    .map(
                                      (e) => FlSpot(
                                        e.key.toDouble(),
                                        e.value.score,
                                      ),
                                    )
                                    .toList(),
                                isCurved: true,
                                barWidth: 3,
                                color: widget.course.color,
                                dotData: FlDotData(show: true),
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
          ),
        ),
      ),
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
        currentIndex: 1,
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
