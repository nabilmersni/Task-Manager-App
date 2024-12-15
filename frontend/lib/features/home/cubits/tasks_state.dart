part of "tasks_cubit.dart";

sealed class TasksState {
  const TasksState();
}

final class TasksInit extends TasksState {}

final class TasksLoading extends TasksState {}

final class TasksError extends TasksState {
  final String error;
  const TasksError({required this.error});
}

final class AddNewTaskSuccess extends TasksState {
  final TaskModel taskModel;
  const AddNewTaskSuccess({required this.taskModel});
}

final class GetTasksSuccess extends TasksState {
  final List<TaskModel> tasks;
  const GetTasksSuccess({required this.tasks});
}
