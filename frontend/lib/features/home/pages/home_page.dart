import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/auth/cubits/auth_cubit.dart';
import 'package:task_app/features/home/cubits/tasks_cubit.dart';
import 'package:task_app/features/home/pages/add_new_task_page.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime selectedDate = DateTime.now();

  void onSelectDate(DateTime date) {
    setState(() {
      selectedDate = date;
    });
  }

  @override
  void initState() {
    super.initState();
    final user = context.read<AuthCubit>().state as AuthLoggedIn;
    context.read<TasksCubit>().getTasks(token: user.user.token);
    Connectivity().onConnectivityChanged.listen(
      (data) async {
        if (data.contains(ConnectivityResult.wifi)) {
          // ignore: use_build_context_synchronously
          await context.read<TasksCubit>().syncTasks(token: user.user.token);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, TasksPage.route());
            },
            icon: const Icon(CupertinoIcons.add),
          )
        ],
      ),
      body: Column(
        children: [
          DateSelector(
            selectedDate: selectedDate,
            onTap: onSelectDate,
          ),
          BlocBuilder<TasksCubit, TasksState>(
            builder: (context, state) {
              if (state is TasksLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is TasksError) {
                return Center(child: Text(state.error));
              } else if (state is GetTasksSuccess) {
                final tasks = state.tasks
                    .where(
                      (element) =>
                          DateFormat('d').format(element.dueAt) ==
                              DateFormat('d').format(selectedDate) &&
                          element.dueAt.month == selectedDate.month &&
                          element.dueAt.year == selectedDate.year,
                    )
                    .toList();
                return Expanded(
                  child: ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return Row(
                          children: [
                            Expanded(
                              child: TaskCard(
                                color: task.color,
                                headerText: task.title,
                                descriptionText: task.description,
                              ),
                            ),
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: strengthenColor(
                                  task.color,
                                  0.69,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                DateFormat.jm().format(task.dueAt),
                                style: const TextStyle(
                                  fontSize: 17,
                                ),
                              ),
                            ),
                          ],
                        );
                      }),
                );
              }
              return const SizedBox();
            },
          ),
        ],
      ),
    );
  }
}
