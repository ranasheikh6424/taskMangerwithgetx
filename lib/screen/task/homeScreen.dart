import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/component/TaskAppBar.dart';
import 'package:taskmanager/component/appBottomNav.dart';
import 'package:taskmanager/controller/homeController.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Bind the HomeController to the screen
    final HomeController controller = Get.put(HomeController());

    // Read app data when the screen is loaded
    controller.readAppData();

    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to task create screen using GetX
          Get.toNamed('/taskCreate');
        },
        child: const Icon(Icons.add),
      ),
      appBar: TaskAppBar(context,
          controller.formValues.value), // Fix here: remove Obx around appBar
      body: Obx(() {
        // Dynamically display selected tab screen based on tabIndex
        return controller.tabIndex.value < controller.widgetOptions.length
            ? controller.widgetOptions.elementAt(controller.tabIndex.value)
            : Container(); // Fallback if index out of range
      }),
      bottomNavigationBar: Obx(() {
        // Watch for tab index change and update bottom nav
        return appBottomNav(controller.tabIndex.value, (index) {
          controller.updateTabIndex(index);
        });
      }),
    );
  }
}
