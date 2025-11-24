import 'package:polieats_frontend/main.dart';

class TaskAttachment {
  final int? id;
  final int? taskId;
  final String fileName;
  final String filePath;
  final List<int> fileBytes;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  TaskAttachment({
    this.id,
    this.taskId,
    required this.fileName,
    required this.filePath,
    required this.fileBytes,
    this.createdAt,
    this.updatedAt,
  });

  // Factory constructor for API responses
  factory TaskAttachment.fromJson(Map<String, dynamic> json) {
    return TaskAttachment(
      id: json['id'],
      taskId: json['taskId'],
      fileName: json['fileName'],
      filePath: json['filePath'],
      fileBytes: List<int>.empty(), // File bytes would be loaded separately
      createdAt: json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt: json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'taskId': taskId,
      'fileName': fileName,
      'filePath': filePath,
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }
}

class Task {
  final int id;
  final int classId;
  final String title;
  final String description;
  final bool hasAttachment;
  final DateTime dueDate;
  final List<TaskAttachment>? attachments;

  Task({
    required this.id,
    required this.classId,
    required this.title,
    required this.description,
    this.hasAttachment = false,
    required this.dueDate,
    this.attachments,
  });

  // Factory constructor for API responses
  factory Task.fromJson(Map<String, dynamic> json) {
    List<TaskAttachment>? attachments;
    if (json['attachments'] != null) {
      attachments = (json['attachments'] as List<dynamic>)
          .map((att) => TaskAttachment.fromJson(att))
          .toList();
    }

    return Task(
      id: json['id'],
      classId: json['classId'],
      title: json['title'],
      description: json['description'],
      hasAttachment: json['hasAttachment'] ?? false,
      dueDate: DateTime.parse(json['dueDate']),
      attachments: attachments,
    );
  }

  // Method to convert to JSON for API requests
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'classId': classId,
      'title': title,
      'description': description,
      'hasAttachment': hasAttachment,
      'dueDate': dueDate.toIso8601String(),
      'attachments': attachments?.map((att) => att.toJson()).toList(),
    };
  }
}

// Backwards compatibility - Assignment is now an alias for Task
typedef Attachment = TaskAttachment;
typedef Assignment = Task;

class Tasks {
  List<Task> tasks = [];

  Future<List<Task>> getTasksForClass(int classId) async {
    try {
      // This would need to be updated in the API to use class ID instead of subject ID
      final fetchedTasks = await api.fetchAssignmentsForSubject(classId);
      tasks = fetchedTasks.cast<Task>();
      return tasks;
    } catch (e) {
      print('Error fetching tasks: $e');
      return [];
    }
  }

  Task? getTaskByName(String name) {
    try {
      return tasks.firstWhere((task) => task.title == name);
    } catch (e) {
      return null;
    }
  }

  Task? getTaskById(int id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }
}

class TasksController {
  List<Task> tasks = [];

  List<Task> get allTasks => tasks;

  Task? getTaskById(int id) {
    try {
      return tasks.firstWhere((task) => task.id == id);
    } catch (e) {
      return null;
    }
  }

  Task? getTaskByName(String name) {
    try {
      return tasks.firstWhere((task) => task.title == name);
    } catch (e) {
      return null;
    }
  }

  void addTask(Task task) {
    tasks.add(task);
  }

  void removeTask(String name) {
    tasks.removeWhere((task) => task.title == name);
  }

  void setTasks(List<Task> newTasks) {
    tasks = newTasks;
  }

  void fromJson(List<dynamic> jsonData) {
    tasks = jsonData.map((task) => Task.fromJson(task)).toList();
  }
}

// Backwards compatibility
typedef Assignments = Tasks;
