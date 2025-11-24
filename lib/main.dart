import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Globals.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/data/User.dart';
import 'package:polieats_frontend/src/helpers/api.dart';
import 'package:polieats_frontend/src/login_screen.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';

final Api api = Api();
final Globals globals = Globals(
  currentUser: User(email: '', name: '', id: 0, role: UserRole.STUDENT),
  courseController: CourseController(),
  classController: CourseClassController(),
  tasksController: TasksController(),
  noticesController: Notices(),
);

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    GoogleFonts.config.allowRuntimeFetching = true;

    return MaterialApp(
      title: 'PoliGrades',
      debugShowCheckedModeBanner: false,
      locale: const Locale('pt', 'BR'),
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        SfGlobalLocalizations.delegate,
      ],
      supportedLocales: const [Locale('pt', 'BR')],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Color.fromARGB(255, 45, 176, 194),
        ),
        fontFamily: GoogleFonts.leagueSpartan().fontFamily,
      ),
      home: LoginScreen(),
    );
  }
}
