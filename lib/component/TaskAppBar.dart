import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:taskmanager/style/style.dart';
import 'package:taskmanager/utility/utility.dart';

import '../controller/ProfileController.dart';

AppBar TaskAppBar(BuildContext context, Map<String, String> value) {
  // Use GetX to fetch the ProfileController
  final ProfileController controller = Get.find<ProfileController>();

  // Fetch FormValues from the controller
  var formValues = controller.formValues;

  // Get the profile image
  Uint8List? profileImage;
  if (formValues['photo'] != null && formValues['photo']!.isNotEmpty) {
    try {
      profileImage = ShowBase64Image(formValues['photo']);
    } catch (e) {
      profileImage = null;
    }
  }

  return AppBar(
    backgroundColor: colorGreen,
    flexibleSpace: Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 24,
            child: ClipOval(
              child: profileImage != null
                  ? Image.memory(
                      profileImage,
                      fit: BoxFit.cover,
                      width: 48,
                      height: 48,
                    )
                  : const Icon(
                      Icons.account_circle,
                      size: 48,
                      color: colorWhite,
                    ),
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/updateProfile');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${formValues['firstName'] ?? 'First Name'} ${formValues['lastName'] ?? 'Last Name'}',
                  style: Head7Text(colorWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  formValues['email'] ?? 'Email not provided',
                  style: Head9Text(colorWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () async {
          await RemoveToken();
          Navigator.pushNamedAndRemoveUntil(
              context, "/login", (route) => false);
        },
        icon: const Icon(Icons.logout, color: colorWhite),
      ),
    ],
  );
}
