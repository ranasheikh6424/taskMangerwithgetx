import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../Style/Style.dart';
import '../api/apiClient.dart';
import 'TaskList.dart';

// Controller class for state management using GetX
class CompletedTaskController extends GetxController {
  var taskItems = <dynamic>[].obs; // Observable list for task items
  var loading = true.obs; // Observable for loading state
  var status = "Completed".obs; // Observable for task status

  // Method to fetch data
  Future<void> callData() async {
    loading(true);
    var data = await TaskListRequest("Completed");
    taskItems.assignAll(data); // Update the list with fetched data
    loading(false);
  }

  // Method to update task status
  Future<void> updateStatus(String id, String status) async {
    loading(true);
    await TaskUpdateRequest(id, status); // Update task status in the database
    // Find the task and update its status locally
    var task =
        taskItems.firstWhere((task) => task['_id'] == id, orElse: () => {});
    if (task.isNotEmpty) {
      task['status'] = status; // Update status in local list
    }
    loading(false);
    // Optionally call callData() again to refresh from the server
  }

  // Method to delete task item
  Future<void> deleteItem(String id) async {
    loading(true);
    await TaskDeleteRequest(id); // Delete task from server
    taskItems
        .removeWhere((task) => task['_id'] == id); // Remove from local list
    loading(false); // Update state and UI after deletion
  }
}

class CompletedTaskList extends StatelessWidget {
  const CompletedTaskList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Instantiate the controller using GetX
    final controller = Get.put(CompletedTaskController());

    return Obx(() {
      // Reactive UI
      return controller.loading.value
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: () async {
                await controller.callData(); // Refresh data
              },
              child: ListView.builder(
                itemCount: controller.taskItems.length,
                itemBuilder: (context, index) {
                  var task = controller.taskItems[index];
                  // Determine the status color based on task status
                  Color statusColor = colorGreen;
                  if (task['status'] == "New") {
                    statusColor = colorBlue;
                  } else if (task['status'] == "Progress") {
                    statusColor = colorOrange;
                  } else if (task['status'] == "Canceled") {
                    statusColor = colorRed;
                  }

                  // Alternate background color for cards
                  Color cardBackgroundColor =
                      index % 2 == 0 ? Colors.grey.shade100 : Colors.white;

                  return Card(
                    color: cardBackgroundColor,
                    elevation: 3, // Adds a subtle shadow to cards
                    margin:
                        const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Task Title
                          Text(
                            task['title'],
                            style: Head6Text(colorDarkBlue),
                          ),
                          const SizedBox(height: 5),

                          // Task Description
                          Text(
                            task['description'],
                            style: Head7Text(colorLightGray),
                          ),
                          const SizedBox(height: 5),

                          // Task Creation Date
                          Text(
                            "Created: ${task['createdDate']}",
                            style: Head9Text(colorDarkBlue),
                          ),
                          const SizedBox(height: 10),

                          // Status and Action Buttons
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Status Label with Color
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 4, horizontal: 10),
                                decoration: BoxDecoration(
                                  color: statusColor.withOpacity(0.2),
                                  border: Border.all(color: statusColor),
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Text(
                                  task['status'],
                                  style: TextStyle(
                                    color: statusColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),

                              // Action Buttons (Edit and Delete)
                              Row(
                                children: [
                                  // Edit Button
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        statusChange(
                                          context,
                                          task['_id'],
                                          controller,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.edit,
                                        size: 16,
                                        color: Colors.green,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 10),

                                  // Delete Button
                                  SizedBox(
                                    width: 60,
                                    height: 40,
                                    child: ElevatedButton(
                                      onPressed: () {
                                        controller.deleteItem(task['_id']);
                                      },
                                      style: ElevatedButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        size: 16,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
    });
  }

  // Method for showing status change modal
  void statusChange(
      BuildContext context, String id, CompletedTaskController controller) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Container(
              padding: const EdgeInsets.all(30),
              height: 360,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  RadioListTile(
                    title: const Text("New"),
                    value: "New",
                    groupValue: controller.status.value,
                    onChanged: (value) {
                      controller.status.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: const Text("Progress"),
                    value: "Progress",
                    groupValue: controller.status.value,
                    onChanged: (value) {
                      controller.status.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: const Text("Completed"),
                    value: "Completed",
                    groupValue: controller.status.value,
                    onChanged: (value) {
                      controller.status.value = value.toString();
                    },
                  ),
                  RadioListTile(
                    title: const Text("Canceled"),
                    value: "Canceled",
                    groupValue: controller.status.value,
                    onChanged: (value) {
                      controller.status.value = value.toString();
                    },
                  ),
                  ElevatedButton(
                    style: AppButtonStyle(),
                    child: SuccessButtonChild('Confirm'),
                    onPressed: () {
                      Navigator.pop(context);
                      // Pass the status value to updateStatus
                      controller.updateStatus(id, controller.status.value);
                    },
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
