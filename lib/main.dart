import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:taskmanager/screen/onboarding/emailverificationScreen.dart';
import 'package:taskmanager/screen/onboarding/loginScreen.dart';
import 'package:taskmanager/screen/onboarding/pinVerificationScreen.dart';
import 'package:taskmanager/screen/onboarding/registrationScreen.dart';
import 'package:taskmanager/screen/onboarding/setPasswordScreen.dart';
import 'package:taskmanager/screen/task/homeScreen.dart';
import 'package:taskmanager/screen/task/taskCreateScreen.dart';

import 'controller/ProfileController.dart';
import 'controller/TaskCountController.dart';
import 'controller/getxController.dart';
import 'controller/homeController.dart';
import 'controller/taskCreateController.dart';
import 'controller/taskListController.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      initialRoute: '/splash', // Always start with the splash screen
      initialBinding: BindingsBuilder(() {
        // Use Get.put() to ensure controllers are initialized immediately
        Get.put<HomeController>(HomeController());
        Get.put<ProfileController>(ProfileController());
        Get.put<TaskCountController>(TaskCountController());
        Get.put<ApiController>(ApiController());
        Get.put<TaskCreateController>(TaskCreateController());
        Get.put<TaskListController>(TaskListController());
      }),
      getPages: [
        GetPage(name: '/', page: () => const HomeScreen()),
        GetPage(name: '/login', page: () => const loginScreen()),
        GetPage(name: '/registration', page: () => const registrationScreen()),
        GetPage(
            name: '/emailVerification',
            page: () => const EmailVerificationScreen()),
        GetPage(
            name: '/pinVerification',
            page: () => const pinVerificationScreen()),
        GetPage(name: '/setPassword', page: () => const setPasswordScreen()),
        GetPage(name: '/taskCreate', page: () => const TaskCreateScreen()),
        //GetPage(name: '/updateProfile', page: () => const UpdateProfileScreen()),
      ],
    );
  }
}
