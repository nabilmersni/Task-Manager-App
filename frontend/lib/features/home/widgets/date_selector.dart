import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:task_app/core/constants/utils.dart';

class DateSelector extends StatefulWidget {
  const DateSelector({super.key});

  @override
  State<DateSelector> createState() => _DateSelectorState();
}

class _DateSelectorState extends State<DateSelector> {
  int weekOffset = 0;
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final weekDates = generateWeekDates(weekOffset);
    final currentMonth = DateFormat("MMMM").format(weekDates[0]);
    return Column(
      children: [
        Padding(
          padding:
              const EdgeInsets.symmetric(horizontal: 16).copyWith(bottom: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset--;
                  });
                },
                icon: const Icon(
                  Icons.arrow_back_ios,
                ),
              ),
              Text(
                currentMonth,
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              IconButton(
                onPressed: () {
                  setState(() {
                    weekOffset++;
                  });
                },
                icon: const Icon(
                  Icons.arrow_forward_ios,
                ),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: SizedBox(
            height: 80,
            child: ListView.builder(
              itemCount: weekDates.length,
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                final date = weekDates[index];
                bool isSelected = DateFormat('d').format(selectedDate) ==
                        DateFormat('d').format(date) &&
                    selectedDate.month == date.month &&
                    selectedDate.year == date.year;

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      selectedDate = date;
                    });
                  },
                  child: Container(
                    width: 70,
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: isSelected
                            ? Colors.deepOrange
                            : Colors.grey.shade300,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                      color: isSelected ? Colors.deepOrange : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          DateFormat("d").format(date),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat("E").format(date),
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        )
      ],
    );
  }
}
