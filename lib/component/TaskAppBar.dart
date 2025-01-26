import 'dart:typed_data'; // Correct import for Uint8List
import 'package:flutter/material.dart';
import 'package:taskmanager/style/style.dart';
import 'package:taskmanager/utility/utility.dart';

AppBar TaskAppBar(BuildContext context, Map<String, String> ProfileData) {
  // Handle the case where the photo may be null or invalid
  Uint8List? profileImage = ShowBase64Image(ProfileData['photo']);

  return AppBar(
    backgroundColor: colorGreen,
    flexibleSpace: Container(
      margin: EdgeInsets.fromLTRB(10, 5, 10, 0),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: Colors.transparent,
            radius: 24,
            child: ClipOval(
              child: profileImage != null
                  ? Image.memory(
                      profileImage) // Display the image if it's valid
                  : Icon(Icons.account_circle,
                      size: 48,
                      color: colorWhite), // Default icon if the image is null
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${ProfileData['firstName'] ?? ''} ${ProfileData['lastName'] ?? ''}',
                style: Head7Text(colorWhite),
              ),
              Text(
                ProfileData['email'] ?? '', // Ensure email is not null
                style: Head9Text(colorWhite),
              )
            ],
          )
        ],
      ),
    ),
    actions: [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/taskCreate");
        },
        icon: Icon(Icons.add_circle_outline),
      ),
      IconButton(
        onPressed: () async {
          await RemoveToken();
          Navigator.pushNamedAndRemoveUntil(
              context, "/login", (route) => false);
        },
        icon: Icon(Icons.output),
      ),
    ],
  );
}
