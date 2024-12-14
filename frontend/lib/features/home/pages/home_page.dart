import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:task_app/core/constants/utils.dart';
import 'package:task_app/features/home/pages/add_new_task_page.dart';
import 'package:task_app/features/home/widgets/date_selector.dart';
import 'package:task_app/features/home/widgets/task_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  static route() => MaterialPageRoute(
        builder: (context) => const HomePage(),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("My Tasks"),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.push(context, AddNewTaskPage.route());
            },
            icon: const Icon(CupertinoIcons.add),
          )
        ],
      ),
      body: Column(
        children: [
          const DateSelector(),
          Row(
            children: [
              const Expanded(
                child: TaskCard(
                  color: Color.fromRGBO(246, 222, 194, 1),
                  headerText: "Hello!",
                  descriptionText:
                      "This is a new task!this is a new task!this is a new task!this is a new task!this is a new task!this is a new task!this is a new task!this is a new task!",
                ),
              ),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: strengthenColor(
                    const Color.fromRGBO(246, 222, 194, 1),
                    0.69,
                  ),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(
                  "10:00AM",
                  style: TextStyle(
                    fontSize: 17,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
