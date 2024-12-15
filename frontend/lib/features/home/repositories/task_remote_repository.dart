import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:task_app/core/constants/constants.dart';
import 'package:task_app/models/task_model.dart';

class TaskRemoteRepository {
  Future<TaskModel> createTask({
    required String title,
    required String description,
    required String hexColor,
    required String token,
    required DateTime dueAt,
  }) async {
    try {
      final res = await http
          .post(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
        body: jsonEncode(
          {
            "title": title,
            "description": description,
            "hexColor": hexColor,
            "dueAt": dueAt.toIso8601String(),
          },
        ),
      )
          .timeout(const Duration(seconds: 5), onTimeout: () {
        throw "Request timed out";
      });

      if (res.statusCode != 201) {
        throw jsonDecode(res.body)["msg"];
      }

      return TaskModel.fromJson(res.body);
    } catch (e) {
      rethrow;
    }
  }

  Future<List<TaskModel>> getTasks({
    required String token,
  }) async {
    try {
      final res = await http.get(
        Uri.parse("${Constants.backendUri}/tasks"),
        headers: {
          'Content-Type': 'application/json',
          'x-auth-token': token,
        },
      ).timeout(const Duration(seconds: 5), onTimeout: () {
        throw "Request timed out";
      });

      if (res.statusCode != 200) {
        throw jsonDecode(res.body)["msg"];
      }

      final listTasksMap = jsonDecode(res.body);
      final List<TaskModel> tasks = [];
      for (var task in listTasksMap) {
        tasks.add(TaskModel.fromMap(task));
      }

      return tasks;
    } catch (e) {
      rethrow;
    }
  }
}
