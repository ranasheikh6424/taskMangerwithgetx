import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../api/apiClient.dart';
import '../../controller/getxController.dart';
import '../../style/style.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final ApiController apiController = Get.find<ApiController>();
  Map<String, String> _formValues = {"email": ""};
  bool _loading = false;

  // Update method names for better consistency
  void inputOnChange(String mapKey, String textValue) {
    setState(() {
      _formValues.update(mapKey, (value) => textValue);
    });
  }

  // Method to handle form submission
  Future<void> _formOnSubmit() async {
    if (_formValues['email']!.isEmpty) {
      ErrorToast('Email Required!');
    } else {
      setState(() {
        _loading = true;
      });
      bool res = await apiController.verifyEmailRequest(_formValues['email']!);
      if (res) {
        Get.toNamed('/pinVerification');
      } else {
        setState(() {
          _loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          ScreenBackground(context),
          Container(
            alignment: Alignment.center,
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                    padding: const EdgeInsets.all(30),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Your Email Address",
                            style: Head1Text(colorDarkBlue)),
                        const SizedBox(height: 1),
                        Text(
                          "A 6 digit verification pin will be sent to your email address",
                          style: Head6Text(colorLightGray),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          onChanged: (textValue) {
                            inputOnChange("email", textValue);
                          },
                          decoration: AppInputDecoration("Email Address"),
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          style: AppButtonStyle(),
                          onPressed: _formOnSubmit,
                          child: SuccessButtonChild('Next'),
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}
