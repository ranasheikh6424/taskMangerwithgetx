import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Style/Style.dart';
import '../controller/TaskCountController.dart';

class TaskCount extends StatelessWidget {
  final String status;
  TaskCount({required this.status});

  @override
  Widget build(BuildContext context) {
    // Get the TaskCountController
    final taskCountController = Get.find<TaskCountController>();

    return SizedBox(
      height: 60,
      width: MediaQuery.of(context).size.width * 0.20,
      child: Card(
        child: Column(
          children: [
            Text(
              status,
              style: Head6Text(Colors.black),
            ),
            // Use GetX to observe the task count for this status
            Obx(() {
              // Fetch the task count for the given status
              String count = taskCountController.getTaskCount(status);
              return Text(
                count,
                style: Head1Text(Colors.grey),
              );
            }),
          ],
        ),
      ),
    );
  }
}
