import 'package:polieats_frontend/src/data/Courses.dart';
import 'package:polieats_frontend/src/data/User.dart';

class Globals {
  User currentUser;
  CourseController courseController;

  Globals({
    required this.currentUser,
    required this.courseController,
  });
}