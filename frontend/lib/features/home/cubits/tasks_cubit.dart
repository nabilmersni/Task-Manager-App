import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/repositories/task_local_repository.dart';
import 'package:task_app/features/home/repositories/task_remote_repository.dart';
import 'package:task_app/models/task_model.dart';
import 'package:uuid/uuid.dart';

part 'tasks_state.dart';

class TasksCubit extends Cubit<TasksState> {
  final taskRemoteRepository = TaskRemoteRepository();
  final taskLocalRepository = TaskLocalRepository();
  TasksCubit() : super(TasksInit());

  Future<void> createNewTask({
    required String title,
    required String description,
    required Color color,
    required String token,
    required String uid,
    required DateTime dueAt,
  }) async {
    try {
      emit(TasksLoading());
      final taskModel = await taskRemoteRepository.createTask(
        title: title,
        description: description,
        hexColor: rgbToHex(color),
        token: token,
        dueAt: dueAt,
      );
      await taskLocalRepository.insertTask(taskModel);

      emit(AddNewTaskSuccess(taskModel: taskModel));
    } catch (e) {
      try {
        final taskModel = TaskModel(
            id: const Uuid().v4(),
            uid: uid,
            title: title,
            description: description,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            dueAt: dueAt,
            color: color,
            isSynced: 0);
        await taskLocalRepository.insertTask(taskModel);
        emit(AddNewTaskSuccess(taskModel: taskModel));
      } catch (e) {
        emit(TasksError(error: e.toString()));
      }
    }
  }

  Future<void> getTasks({
    required String token,
  }) async {
    try {
      emit(TasksLoading());
      final tasks = await taskRemoteRepository.getTasks(
        token: token,
      );

      emit(GetTasksSuccess(tasks: tasks));
      await taskLocalRepository.insertTasks(tasks);
    } catch (e) {
      final tasks = await taskLocalRepository.getTasks();

      if (tasks.isNotEmpty) {
        emit(GetTasksSuccess(tasks: tasks));
        return;
      }

      emit(TasksError(error: e.toString()));
    }
  }

  Future<void> syncTasks({
    required String token,
  }) async {
    final unsycTasks = await taskLocalRepository.getUnsyncedTasks();
    if (unsycTasks.isNotEmpty) {
      final isSynced =
          await taskRemoteRepository.syncTasks(token: token, tasks: unsycTasks);

      if (isSynced) {
        for (var task in unsycTasks) {
          taskLocalRepository.updateRow(task.id, 1);
        }
      }
    }
  }
}
