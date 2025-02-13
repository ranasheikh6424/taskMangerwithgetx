import 'package:get/get.dart';

class TaskCountController extends GetxController {
  // Using a map to store task counts for different statuses
  var taskCounts = <String, String>{}.obs;

  // Method to set or update task counts for a specific status
  void setTaskCount(String status, String count) {
    taskCounts[status] = count;
  }

  // Method to get the count of tasks for a specific status
  String getTaskCount(String status) {
    return taskCounts[status] ?? '0';
  }
}
