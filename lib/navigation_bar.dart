import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/home_page.dart';
import 'package:gtk_flutter/map_page.dart';
import 'package:gtk_flutter/plan_page.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'main.dart';

class MyNavigationBarPage extends StatefulWidget {
  const MyNavigationBarPage({Key? key}) : super(key: key);

  @override
  State<MyNavigationBarPage> createState() => _MyNavigationBarPageState();
}

class _MyNavigationBarPageState extends State<MyNavigationBarPage> {
  final List<Widget> _children = [
    HomeScreen(),
    Consumer<ApplicationState>(
        builder: (context, appState, _) =>
            PlanPage(eventList: appState.eventsList)),
    PlayersPage(),
    TeamsPage(),
    MapPage(),
  ];

  @override
  Widget build(BuildContext context) {
    Timer _refresh = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {});
    });
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => appState.currentPlayer.uid == ''
          ? loadingIndicator
          : Scaffold(
              body: _children[appState.homeNavigationBarItem.index],
              bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.blueGrey[100],
                unselectedItemColor: Colors.blueGrey,
                selectedItemColor: themeColors['main']!,
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Strona główna'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.calendar_month), label: 'Harmonogram'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.person), label: 'Zawodnicy'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.people), label: 'Drużyny'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.newspaper), label: 'Mapa'),
                ],
                currentIndex: appState.homeNavigationBarItem.index,
                onTap: (int index) async {
                  appState.homeNavigationBarItem = TabItem.values[index];
                  setState(() {});
                },
              ),
            ),
    );
  }
}

Widget MyBottomNavigationBar = Consumer<ApplicationState>(
    builder: (context, appState, _) => BottomNavigationBar(
          backgroundColor: Colors.blueGrey[100],
          unselectedItemColor: Colors.blueGrey,
          selectedItemColor: themeColors['main']!,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
                icon: Icon(Icons.home), label: 'Strona główna'),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Harmonogram'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person), label: 'Zawodnicy'),
            BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Drużyny'),
            BottomNavigationBarItem(icon: Icon(Icons.newspaper), label: 'Mapa'),
          ],
          currentIndex: appState.currentNavigationBarItem.index,
          onTap: (int index) async {
            appState.currentNavigationBarItem = TabItem.values[index];
            appState.homeNavigationBarItem = TabItem.values[index];
            Navigator.popUntil(context, ModalRoute.withName('/'));
          },
        ));
