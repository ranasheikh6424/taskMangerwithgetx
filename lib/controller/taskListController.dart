import 'package:get/get.dart';

class TaskListController extends GetxController {
  // RxList for storing the tasks
  var taskItems = <Map<String, dynamic>>[].obs;

  // Method to update the list of tasks
  void updateTaskItems(List<Map<String, dynamic>> tasks) {
    taskItems.value = tasks;
  }

  // Method to update a task's status
  void updateTaskStatus(String id, String status) {
    var index = taskItems.indexWhere((task) => task['_id'] == id);
    if (index != -1) {
      taskItems[index]['status'] = status;
      taskItems.refresh(); // Refresh the list after status change
    }
  }

  // Method to delete a task
  void deleteTask(String id) {
    taskItems.removeWhere((task) => task['_id'] == id);
  }
}
