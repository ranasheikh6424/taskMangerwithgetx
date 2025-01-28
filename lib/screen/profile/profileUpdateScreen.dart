import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:taskmanager/Style/Style.dart';
import 'package:taskmanager/component/TaskAppBar.dart';
import '../../api/apiClient.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);
  static const String name = '/update-profile-screen';

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  Map<String, String> formValues = {
    "email": "",
    "firstName": "",
    "lastName": "",
    "mobile": "",
    "password": "",
    "photo": "",
  };
  XFile? _pickedImage;
  bool _updateProfileInProgress = false;

  TextEditingController _emailController = TextEditingController();
  TextEditingController _firstNameController = TextEditingController();
  TextEditingController _lastNameController = TextEditingController();
  TextEditingController _mobileController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _firstNameController.dispose();
    _lastNameController.dispose();
    _mobileController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onFormChanged() {
    setState(() {
      formValues['email'] = _emailController.text;
      formValues['firstName'] = _firstNameController.text;
      formValues['lastName'] = _lastNameController.text;
      formValues['mobile'] = _mobileController.text;
      formValues['password'] = _passwordController.text;
    });
  }

  Future<void> _updateProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _updateProfileInProgress = true;
    });

    Map<String, dynamic> FormValues = {
      "email": formValues['email'],
      "firstName": formValues['firstName'],
      "lastName": formValues['lastName'],
      "mobile": formValues['mobile'],
    };

    if (_pickedImage != null) {
      List<int> imageBytes = await _pickedImage!.readAsBytes();
      FormValues['photo'] = base64Encode(imageBytes);
    }

    // Update the password only if it's not empty
    if (formValues['password']?.isNotEmpty ?? false) {
      FormValues['password'] = formValues['password'];
    }

    try {
      final response = await ProfileUpdateRequest(FormValues);
      setState(() {
        _updateProfileInProgress = false;
      });

      if (response.isEmpty) {
        // Pass updated data back to the previous screen
        Navigator.pop(context, FormValues); // Return the updated data
      } else {
        ErrorToast("Request Error");
      }
    } catch (e) {
      setState(() {
        _updateProfileInProgress = false;
      });
      ErrorToast("Error occurred while updating the profile");
    }
  }

  Widget buildContainerPhotoPicker() {
    return GestureDetector(
      onTap: _pickImage,
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              height: 50,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(
                color: Colors.grey,
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(8),
                    bottomLeft: Radius.circular(8)),
              ),
              alignment: Alignment.center,
              child: const Text(
                "Photo",
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(width: 12),
            Text(
              _pickedImage == null ? 'No item selected' : _pickedImage!.name,
              maxLines: 1,
            ),
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

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: TaskAppBar(context, formValues),
      body: Stack(
        children: [
          ScreenBackground(context),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                onChanged: _onFormChanged,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),
                    Text('Update Profile', style: textTheme.titleLarge),
                    const SizedBox(height: 40),
                    buildContainerPhotoPicker(),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailController,
                      enabled: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _firstNameController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your First name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: 'First name'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _lastNameController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your last name";
                        }
                        return null;
                      },
                      decoration: const InputDecoration(hintText: 'Last name'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _mobileController,
                      validator: (value) {
                        if (value?.trim().isEmpty ?? true) {
                          return "Enter your phone number";
                        }
                        return null;
                      },
                      keyboardType: TextInputType.phone,
                      decoration: const InputDecoration(hintText: 'Mobile'),
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: const InputDecoration(hintText: 'Password'),
                    ),
                    const SizedBox(height: 24),
                    Visibility(
                      visible: !_updateProfileInProgress,
                      replacement: const CircularProgressIndicator(),
                      child: ElevatedButton(
                        style: AppButtonStyle(),
                        onPressed: _updateProfile,
                        child: const Icon(Icons.arrow_circle_right_outlined),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
