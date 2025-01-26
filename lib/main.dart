import 'package:flutter/material.dart';
import 'package:taskmanager/screen/onboarding/emailVerificationScreen.dart';
import 'package:taskmanager/screen/onboarding/loginScreen.dart';
import 'package:taskmanager/screen/onboarding/pinVerificationScreen.dart';
import 'package:taskmanager/screen/onboarding/registrationScreen.dart';
import 'package:taskmanager/screen/onboarding/setPasswordScreen.dart';
import 'package:taskmanager/screen/task/homeScreen.dart';
import 'screen/task/taskCreateScreen.dart';
import 'utility/utility.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  String? token = await ReadUserData('token');
  if (token == null) {
    runApp(MyApp("/login"));
  } else {
    runApp(MyApp("/"));
  }
}

class MyApp extends StatelessWidget {
  final String FirstRoute;
  MyApp(this.FirstRoute);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Task Manager",
      initialRoute: FirstRoute,
      routes: {
        '/': (context) => const homeScreen(),
        '/login': (context) => const loginScreen(),
        '/registration': (context) => const registrationScreen(),
        '/emailVerification': (context) => const emailVerificationScreen(),
        '/pinVerification': (context) => const pinVerificationScreen(),
        '/setPassword': (context) => const setPasswordScreen(),
        '/taskCreate': (context) => const taskCreateScreen()
      },
    );
  }
}
