import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/api/apiClient.dart';
import 'package:taskmanager/modals/taskCountMOdal.dart';

class TaskController extends GetxController {
  var taskCounts = <TaskCountModal>[].obs;
  var newTasks = [].obs;
  var isLoadingCounts = true.obs;
  var isLoadingTasks = true.obs;
  var status = "New".obs;
  var loading = false.obs;

  @override
  void onInit() {
    fetchTaskCounts();
    fetchNewTasks();
    super.onInit();
  }

  fetchTaskCounts() async {
    isLoadingCounts(true);
    try {
      taskCounts.value = await TaskStatusCountListRequest();
    } catch (e) {
      print("Error fetching task counts: $e");
    } finally {
      isLoadingCounts(false);
    }
  }

  fetchNewTasks() async {
    isLoadingTasks(true);
    try {
      newTasks.value = await TaskListRequest("New");
    } catch (e) {
      print("Error fetching new tasks: $e");
    } finally {
      isLoadingTasks(false);
    }
  }

  updateStatus(id) async {
    loading(true);
    await TaskUpdateRequest(id, status.value);
    await fetchNewTasks();
    await fetchTaskCounts();
    status.value = "New";
    loading(false);
  }

  deleteItem(id) async {
    loading(true);
    await TaskDeleteRequest(id);
    await fetchNewTasks();
    await fetchTaskCounts();
    loading(false);
  }
}

class NewTaskList extends StatelessWidget {
  final TaskController controller = Get.put(TaskController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 100,
            padding: const EdgeInsets.all(8.0),
            child: Obx(() => controller.isLoadingCounts.value
                ? const Center(child: CircularProgressIndicator())
                : buildTaskCountWidget()),
          ),
          const Divider(),
          Expanded(
            child: Obx(() => controller.isLoadingTasks.value
                ? const Center(child: CircularProgressIndicator())
                : buildNewTaskListWidget()),
          ),
        ],
      ),
    );
  }

  Widget buildTaskCountWidget() {
    return Obx(() => controller.taskCounts.isEmpty
        ? const Center(child: Text("No task counts available !...."))
        : ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: controller.taskCounts.length,
            itemBuilder: (context, index) {
              var count = controller.taskCounts[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Container(
                  height: 100,
                  width: 80,
                  decoration: BoxDecoration(
                    color: count.sId == "New"
                        ? Colors.redAccent
                        : Colors.blueAccent,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(count.sum.toString(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                      Text(count.sId ?? "Unknown",
                          style: const TextStyle(
                              fontSize: 10, color: Colors.white),
                          textAlign: TextAlign.center),
                    ],
                  ),
                ),
              );
            },
          ));
  }

  Widget buildNewTaskListWidget() {
    return Obx(() => controller.newTasks.isEmpty
        ? const Center(child: Text("No new tasks available."))
        : ListView.builder(
            itemCount: controller.newTasks.length,
            itemBuilder: (context, index) {
              var task = controller.newTasks[index];
              return Container(
                color: index % 2 == 0 ? Colors.grey.shade200 : Colors.white,
                child: ListTile(
                  title: Text(task['title'],
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(task['description']),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blue),
                          onPressed: () =>
                              controller.updateStatus(task['_id'])),
                      IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => controller.deleteItem(task['_id'])),
                    ],
                  ),
                ),
              );
            },
          ));
  }
}
