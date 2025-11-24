import 'package:polieats_frontend/src/data/Class.dart';
import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/Notices.dart';
import 'package:polieats_frontend/src/data/Tasks.dart';
import 'package:polieats_frontend/src/data/User.dart';

class Globals {
  User currentUser;
  CourseController courseController;
  CourseClassController classController;
  TasksController tasksController;
  Notices noticesController;

  Globals({
    required this.currentUser,
    required this.courseController,
    required this.classController,
    required this.tasksController,
    required this.noticesController,
  });
}