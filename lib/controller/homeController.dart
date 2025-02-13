import 'package:get/get.dart';
import 'package:taskmanager/component/newTaskList.dart';
import 'package:taskmanager/component/progresstaskList.dart';
import 'package:taskmanager/component/completedTaskList.dart';
import 'package:taskmanager/component/cancelTaskList.dart';

class HomeController extends GetxController {
  // Observable form values
  var formValues = {
    "email": "",
    "firstName": "",
    "lastName": "",
    "photo": "",
  }.obs;

  // Observable tab index
  var tabIndex = 0.obs;

  // List of widgets to be displayed based on tab index
  final widgetOptions = [
    NewTaskList(),
    const ProgressTaskList(),
    const CompletedTaskList(),
    const TaskListPage(),
  ];

  // Function to read data (mock data here)
  void readAppData() async {
    // Simulate reading data from storage
    await Future.delayed(const Duration(seconds: 2));
    formValues.value = {
      "email": "user@example.com",
      "firstName": "John",
      "lastName": "Doe",
      "photo": "default_photo_url",
    };
  }

  // Update tab index
  void updateTabIndex(int index) {
    tabIndex.value = index;
  }
}
