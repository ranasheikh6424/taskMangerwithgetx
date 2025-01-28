import 'package:flutter/material.dart';
import '../Style/Style.dart';
import '../main.dart';

TaskCount(String status, String count) {
  var cont = MyApp.navigatorkey.currentContext;
  return SizedBox(
    height: 60,
    width: MediaQuery.of(cont!).size.width * 0.20,
    child: Card(
      child: Column(
        children: [
          Text(
            status,
            style: Head6Text(Colors.black),
          ),
          Text(
            count,
            style: Head1Text(Colors.grey),
          ),
        ],
      ),
    ),
  );
}
