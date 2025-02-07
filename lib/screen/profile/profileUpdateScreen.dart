import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../api/apiClient.dart';
import '../../style/style.dart';
// profile update screen section here.........
class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  XFile? _pickedImage;
  bool loading = false;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController firstNameController = TextEditingController();
  final TextEditingController lastNameController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Map<String, dynamic> formValues = {
    "email": "",
    "firstName": "",
    "lastName": "",
    "mobile": "",
    "password": "",
    "photo": "",
  };

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    String email = await ReadUserData('email') ?? '';
    String firstName = await ReadUserData('firstName') ?? '';
    String lastName = await ReadUserData('lastName') ?? '';
    String mobile = await ReadUserData('mobile') ?? '';

    setState(() {
      formValues['email'] = email;
      formValues['firstName'] = firstName;
      formValues['lastName'] = lastName;
      formValues['mobile'] = mobile;

      emailController.text = email;
      firstNameController.text = firstName;
      lastNameController.text = lastName;
      mobileController.text = mobile;
    });
  }

  Future<void> FormOnSubmit() async {
    if (emailController.text.isEmpty) {
      ErrorToast('Email Required!');
      return;
    } else if (firstNameController.text.isEmpty) {
      ErrorToast('First Name Required!');
      return;
    } else if (lastNameController.text.isEmpty) {
      ErrorToast('Last Name Required!');
      return;
    } else if (mobileController.text.isEmpty) {
      ErrorToast('Mobile No Required!');
      return;
    }

    formValues['email'] = emailController.text;
    formValues['firstName'] = firstNameController.text;
    formValues['lastName'] = lastNameController.text;
    formValues['mobile'] = mobileController.text;
    formValues['password'] = passwordController.text;

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      String encodedImage = base64Encode(imageBytes);
      formValues['photo'] = encodedImage;
    }

    if (formValues['password']!.isEmpty) {
      formValues.remove('password');
    }

    setState(() {
      loading = true;
    });

    bool res = await ProfileUpdateRequest(formValues);

    setState(() {
      loading = false;
    });

    if (res == true) {
      SuccessToast('Profile Updated Successfully');
      Navigator.pop(context);
    } else {
      ErrorToast('Update Failed');
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
            child: SingleChildScrollView(
              child: loading
                  ? const Center(child: CircularProgressIndicator())
                  : Container(
                      padding: const EdgeInsets.all(30),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Join With Us", style: Head1Text(colorDarkBlue)),
                          const SizedBox(height: 1),
                          Text("Learn with Rabbil Hasan",
                              style: Head6Text(colorLightGray)),
                          const SizedBox(height: 20),
                          _buildPhotoPicker(),
                          const SizedBox(height: 10),
                          _buildTextField("Email Address", emailController,
                              enabled: false),
                          const SizedBox(height: 20),
                          _buildTextField("First Name", firstNameController),
                          const SizedBox(height: 20),
                          _buildTextField("Last Name", lastNameController),
                          const SizedBox(height: 20),
                          _buildTextField("Mobile", mobileController),
                          const SizedBox(height: 20),
                          _buildTextField("Password", passwordController,
                              obscureText: true),
                          const SizedBox(height: 20),
                          Container(
                            child: ElevatedButton(
                              style: AppButtonStyle(),
                              onPressed: FormOnSubmit,
                              child: SuccessButtonChild('Update Profile'),
                            ),
                          )
                        ],
                      ),
                    ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller,
      {bool obscureText = false, bool enabled = true}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      enabled: enabled,
      decoration: AppInputDecoration(label),
    );
  }

  Widget _buildPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(8)),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                  color: Colors.grey,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(8),
                      bottomLeft: Radius.circular(8))),
              alignment: Alignment.center,
              child: const Text('Photo', style: TextStyle(color: Colors.white)),
            ),
            const SizedBox(width: 12),
            Text(_pickedImage == null ? 'No item selected' : _pickedImage!.name,
                maxLines: 1),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage() async {
    ImagePicker picker = ImagePicker();
    XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _pickedImage = image;
      });
    }
  }
}
