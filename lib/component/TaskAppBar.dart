import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:taskmanager/style/style.dart';
import 'package:taskmanager/utility/utility.dart';

AppBar TaskAppBar(BuildContext context, Map<String, String> FormValues) {
  Uint8List? profileImage;
  if (FormValues['photo'] != null && FormValues['photo']!.isNotEmpty) {
    try {
      profileImage = ShowBase64Image(
          FormValues['photo']); // Ensure `photo` is valid base64.
    } catch (e) {
      profileImage = null; // Fallback in case of invalid base64.
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
                  '${FormValues['firstName'] ?? 'First Name'} ${FormValues['lastName'] ?? 'Last Name'}',
                  style: Head7Text(colorWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  FormValues['email'] ?? 'Email not provided',
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
