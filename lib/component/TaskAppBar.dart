import 'dart:typed_data';
import 'dart:convert'; // Import for base64 decoding
import 'package:flutter/material.dart';
import 'package:taskmanager/style/style.dart';
import 'package:taskmanager/utility/utility.dart';

AppBar TaskAppBar(BuildContext context, Map<String, dynamic> FormValues) {
  Uint8List? profileImage;

  if (FormValues['photo'] != null) {
    try {
      if (FormValues['photo'] is Uint8List) {
        profileImage = FormValues[
            'photo']; // Direct assignment if it's already a byte array
      } else if (FormValues['photo'] is String) {
        // Check if it's a base64 string before decoding
        try {
          profileImage = base64Decode(FormValues['photo']);
        } catch (e) {
          print("Error decoding base64 image: $e");
          profileImage = null; // Handle decoding errors gracefully
        }
      }
    } catch (e) {
      print("Error processing image: $e");
      profileImage = null;
    }
  }

  return AppBar(
    backgroundColor: colorGreen,
    flexibleSpace: Container(
      margin: const EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Row(
        children: [
          // Display the profile image or default avatar
          CircleAvatar(
            backgroundColor: Colors.grey[300],
            backgroundImage: profileImage != null
                ? MemoryImage(profileImage)
                    as ImageProvider // Use decoded image bytes if available
                : (FormValues['photo'] != null &&
                        FormValues['photo'].startsWith("http")
                    ? NetworkImage(FormValues[
                        'photo']) // If it's a URL, show the network image
                    : const AssetImage("assets/default_avatar.png")
                        as ImageProvider),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/update-profile-screen');
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display first name and last name
                Text(
                  '${FormValues['firstName'] ?? 'First Name'} ${FormValues['lastName'] ?? 'Last Name'}',
                  style: Head7Text(colorWhite),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                // Display email
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
