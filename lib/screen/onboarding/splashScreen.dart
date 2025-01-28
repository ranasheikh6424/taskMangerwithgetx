import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import '../../style/style.dart';
import '../../utility/utility.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    moveToNextScreen();
  }

  Future<void> moveToNextScreen() async {
    String? token = await ReadUserData('token');
    await Future.delayed(const Duration(seconds: 3));
    if (token == null) {
      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenBackground(context),
          Container(
            padding: const EdgeInsets.all(30),
            child: Center(
              child: SvgPicture.asset(
                "assets/images/logo.svg",
                alignment: Alignment.center,
              ),
            ),
          )
        ],
      ),
    );
  }
}
