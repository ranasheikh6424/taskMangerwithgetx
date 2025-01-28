import 'package:flutter/material.dart';
import '../../component/TaskAppBar.dart';
import '../../component/appBottomNav.dart';
import '../../component/cancelTaskList.dart';
import '../../component/completedTaskList.dart';
import '../../component/newTaskList.dart';
import '../../component/progresstaskList.dart';
import '../../utility/utility.dart';

class homeScreen extends StatefulWidget {
  const homeScreen({Key? key}) : super(key: key);

  @override
  State<homeScreen> createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  int TabIndex = 0;
  Map<String, String> FormValues = {
    "email": "",
    "firstName": "",
    "lastName": "",
    "photo": DefaultProfilePic
  };

  // Add taskCountScreen as a new tab option
  final widgetOptions = [
    NewTaskList(),
    progressTaskList(),
    completedTaskList(),
    cancelTaskList(),
    // New task count screen added
  ];

  onItemTapped(int index) {
    setState(() {
      TabIndex = index;
    });
  }

  ReadAppBarData() async {
    String? email = await ReadUserData('email' ?? '');
    String? firstName = await ReadUserData('firstName' ?? '');
    String? lastName = await ReadUserData('lastName' ?? '');
    String? photo = await ReadUserData('photo' ?? '');
    setState(() {
      FormValues = {
        "email": '$email',
        "firstName": '$firstName',
        "lastName": '$lastName',
        "photo": photo ?? DefaultProfilePic,
      };
    });
  }

  @override
  void initState() {
    ReadAppBarData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, "/taskCreate");
        },
        child: const Icon(Icons.add),
      ),
      appBar: TaskAppBar(context, FormValues),
      body: widgetOptions
          .elementAt(TabIndex), // Dynamically display selected tab screen
      bottomNavigationBar: appBottomNav(TabIndex, onItemTapped),
    );
  }
}
