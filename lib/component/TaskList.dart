import 'package:flutter/material.dart';
import 'package:get/get.dart'; // Import GetX package
import '../controller/taskListController.dart';
import '../style/style.dart';

class TaskList extends StatelessWidget {
  // Create instances of TaskListController
  final TaskListController taskListController = Get.find<TaskListController>();

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      // We will get the task items from the controller
      List<Map<String, dynamic>> taskItems = taskListController.taskItems;

      return ListView.builder(
        itemCount: taskItems.length,
        itemBuilder: (context, index) {
          // Determine the status color based on task status
          Color statusColor = colorGreen;
          if (taskItems[index]['status'] == "New") {
            statusColor = colorBlue;
          } else if (taskItems[index]['status'] == "Progress") {
            statusColor = colorOrange;
          } else if (taskItems[index]['status'] == "Canceled") {
            statusColor = colorRed;
          }

          // Alternate background color for cards
          Color cardBackgroundColor =
              index % 2 == 0 ? Colors.grey.shade100 : Colors.white;

          return Card(
            color: cardBackgroundColor,
            elevation: 3, // Adds a subtle shadow to cards
            margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 10),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Task Title
                  Text(
                    taskItems[index]['title'],
                    style: Head6Text(colorDarkBlue),
                  ),
                  const SizedBox(height: 5),

                  // Task Description
                  Text(
                    taskItems[index]['description'],
                    style: Head7Text(colorLightGray),
                  ),
                  const SizedBox(height: 5),

                  // Task Creation Date
                  Text(
                    "Created: ${taskItems[index]['createdDate']}",
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
                          taskItems[index]['status'],
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
                                // Call the method to change the status
                                taskListController.updateTaskStatus(
                                  taskItems[index]['_id'],
                                  'Progress', // Example new status
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
                                // Call the method to delete the task
                                taskListController
                                    .deleteTask(taskItems[index]['_id']);
                              },
                              style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
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
      );
    });
  }
}
