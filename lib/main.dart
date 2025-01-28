import 'package:flutter/material.dart';
import 'package:taskmanager/screen/onboarding/emailverificationScreen.dart';
import 'package:taskmanager/screen/onboarding/loginScreen.dart';
import 'package:taskmanager/screen/onboarding/pinVerificationScreen.dart';
import 'package:taskmanager/screen/onboarding/registrationScreen.dart';
import 'package:taskmanager/screen/onboarding/setPasswordScreen.dart';
import 'package:taskmanager/screen/onboarding/splashScreen.dart';
import 'package:taskmanager/screen/profile/profileUpdateScreen.dart';
import 'package:taskmanager/screen/task/homeScreen.dart';
import 'screen/task/taskCreateScreen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  static GlobalKey<NavigatorState> navigatorkey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorkey,
      title: "Task Manager",
      initialRoute: '/splash', // Always start with the splash screen
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/': (context) => const homeScreen(),
        '/login': (context) => const loginScreen(),
        '/registration': (context) => const registrationScreen(),
        '/emailVerification': (context) => const EmailVerificationScreen(),
        '/pinVerification': (context) => const pinVerificationScreen(),
        '/setPassword': (context) => const setPasswordScreen(),
        '/taskCreate': (context) => const taskCreateScreen(),
        '/updateProfile': (context) => const UpdateProfileScreen(),
      },
    );
  }
}
