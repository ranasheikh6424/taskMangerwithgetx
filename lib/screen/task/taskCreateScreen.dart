import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/Style/Style.dart';

import '../../controller/taskCreateController.dart';

class TaskCreateScreen extends StatelessWidget {
  const TaskCreateScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TaskCreateController controller = Get.put(TaskCreateController());

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorGreen,
        title: const Text('Create New Task'),
      ),
      body: Obx(() {
        return Stack(
          children: [
            ScreenBackground(context),
            Container(
              alignment: Alignment.center,
              child: controller.loading.value
                  ? const Center(child: CircularProgressIndicator())
                  : SingleChildScrollView(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Add New Task", style: Head1Text(colorDarkBlue)),
                          const SizedBox(height: 1),
                          TextFormField(
                            onChanged: (Textvalue) {
                              controller.inputOnChange("title", Textvalue);
                            },
                            decoration: AppInputDecoration("Task Name"),
                          ),
                          const SizedBox(height: 20),
                          TextFormField(
                            onChanged: (Textvalue) {
                              controller.inputOnChange(
                                  "description", Textvalue);
                            },
                            maxLines: 10,
                            decoration: AppInputDecoration("Info"),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: ElevatedButton(
                              style: AppButtonStyle(),
                              child: SuccessButtonChild('Create'),
                              onPressed: () {
                                controller.formOnSubmit();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
            ),
          ],
        );
      }),
    );
  }
}
