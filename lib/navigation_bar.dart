import 'package:flutter/material.dart';
import 'package:gtk_flutter/home.dart';
import 'package:gtk_flutter/info.dart';
import 'package:gtk_flutter/plan_page.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/teams_page.dart';

class MyNavigationBar extends StatefulWidget {
  const MyNavigationBar({Key? key}) : super(key: key);

  @override
  State<MyNavigationBar> createState() => _MyNavigationBarState();
}

class _MyNavigationBarState extends State<MyNavigationBar> {
  int _selectedIndex = 0;

  final List<Widget> _children = [
    HomeScreen(),
    PlanPage(),
    PlayersPage(),
    TeamsPage(),
    ReadScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.blueGrey[100],
        unselectedItemColor: Colors.blueGrey,
        selectedItemColor: Colors.blue,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
              icon: Icon(Icons.calendar_month), label: 'Plan'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Zawodnicy'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Drużyny'),
          BottomNavigationBarItem(
              icon: Icon(Icons.newspaper), label: 'Czytelnia'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}
