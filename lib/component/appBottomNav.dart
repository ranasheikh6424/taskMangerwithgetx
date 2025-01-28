import 'package:flutter/material.dart';
import 'package:taskmanager/Style/Style.dart';

BottomNavigationBar appBottomNav(currentIndex, onItemTapped) {
  return BottomNavigationBar(
    items: const [
      BottomNavigationBarItem(
        icon: Icon(Icons.list_alt),
        label: "New",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.access_time_rounded),
        label: "Progress",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.check_circle_outlined),
        label: "Completed",
      ),
      BottomNavigationBarItem(
        icon: Icon(Icons.cancel_outlined),
        label: "Canceled",
      ),
    ],
    selectedItemColor: colorGreen, // Selected tab color
    unselectedItemColor: colorLightGray, // Unselected tab color
    currentIndex: currentIndex, // Current tab index
    showSelectedLabels: true, // Show labels when a tab is selected
    showUnselectedLabels: true, // Show labels when a tab is not selected
    onTap: onItemTapped, // Action when a tab is tapped
    type: BottomNavigationBarType.fixed, // Fix the bar items
    backgroundColor: Colors.white, // Set background color for the bar
    elevation: 5, // Add shadow effect to the bar
  );
}
