import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/plan_page.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:provider/provider.dart';

import 'config.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Widget displayNextGame(String teamName, List<GeneralEvent> eventsList) {
    GameEvent? game;
    late String opponent;
    for (var event in eventsList) {
      if (event is GameEvent) {
        if (event.timestamp.isAfter(compareDate) &&
            (teamName == event.team1 || teamName == event.team2)) {
          game = event;
          opponent = teamName == event.team1 ? event.team2 : event.team1;
          break;
        }
      }
    }
    if (game == null) return Container();

    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        children: [
          CircleAvatar(
            radius: 30,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 25,
              backgroundColor: appState.teamsMap[opponent].color,
            ),
          ),
          Text(
            opponent,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            game!.day,
            style: TextStyle(color: Colors.white),
          ),
          Text(
            game.place,
            style: TextStyle(color: Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => appState.currentPlayer.uid == ''
          ? loadingIndicator
          : Scaffold(
              appBar: AppBar(
                title: const Text('Witamy na turnieju!'),
              ),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      // crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: 100),
                        Padding(
                          padding: const EdgeInsets.all(30.0),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Cześć',
                                    textScaleFactor: 2,
                                  )
                                ],
                              ),
                              Row(
                                children: [
                                  Text(
                                    '${appState.currentPlayer.name.split(' ').first}!',
                                    textScaleFactor: 2,
                                  )
                                ],
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () async {
                                  appState.currentNavigationBarItem =
                                      TabItem.players;
                                  await Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                                player: appState.currentPlayer,
                                              )));
                                  setState(() {});
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    children: [
                                      Text('Twój profil'),
                                      Expanded(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: appState
                                              .teamsMap[appState
                                                  .currentPlayer.hatTeam]
                                              .color,
                                          child: appState.currentPlayer.pic !=
                                                  null
                                              ? SizedBox(
                                                  width: 90,
                                                  height: 90,
                                                  child: ClipOval(
                                                      child: Image.memory(
                                                    appState.currentPlayer.pic!,
                                                    fit: BoxFit.cover,
                                                  )),
                                                )
                                              : Text(appState
                                                      .currentPlayer.name[0] +
                                                  appState.currentPlayer.name
                                                      .split(' ')
                                                      .last[0]),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 150,
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  appState.currentNavigationBarItem =
                                      TabItem.teams;
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => TeamPage(
                                                team: appState.teamsMap[appState
                                                    .currentPlayer.hatTeam],
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    children: [
                                      Text('Twoja drużyna'),
                                      Expanded(
                                        child: CircleAvatar(
                                          radius: 50,
                                          backgroundColor: Colors.white,
                                          child: CircleAvatar(
                                            radius: 45,
                                            backgroundColor: appState
                                                .teamsMap[appState
                                                    .currentPlayer.hatTeam]
                                                .color,
                                          ),
                                        ),
                                      ),
                                      Text(appState
                                          .teamsMap[
                                              appState.currentPlayer.hatTeam]
                                          .name),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              width: 150,
                              height: 150,
                              decoration: BoxDecoration(
                                color: themeColors['main']!,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10)),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 5.0),
                              // margin:
                              // const EdgeInsets.symmetric(vertical: 5.0),
                              child: Column(
                                children: [
                                  Text(
                                    'Następny mecz',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  Spacer(),
                                  // Text('NASTĘPNY MECZ', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                                  displayNextGame(
                                      appState.currentPlayer.hatTeam,
                                      appState.eventsList),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Container(
                              width: 150,
                              height: 150,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => ProfilePage(
                                                player: appState.currentPlayer,
                                                subpage: 1,
                                              )));
                                },
                                style: ElevatedButton.styleFrom(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10))),
                                child: Container(
                                  margin:
                                      const EdgeInsets.symmetric(vertical: 5.0),
                                  child: Column(
                                    children: [
                                      Text('Twoje odznaki'),
                                      SizedBox(height: 10),
                                      GridView.count(
                                        childAspectRatio: 1.1,
                                        shrinkWrap: true,
                                        physics: NeverScrollableScrollPhysics(),
                                        crossAxisCount: 3,
                                        children: [
                                          for (var badge
                                              in appState.currentPlayer.badges)
                                            Icon(
                                              badgeIcons[badge],
                                              color: themeColors['dark'],
                                              size: 35,
                                            ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Header('Tabela'),
                        displayTable(),
                      ],
                    ),
                  ),
                  // new Align(
                  //   child: appState.currentPlayer.uid == ''
                  //       ? loadingIndicator
                  //       : new Container(),
                  //   alignment: FractionalOffset.center,
                  // ),
                ],
              ),
            ),
    );
  }
}

Widget displayTable() {
  return Consumer<ApplicationState>(
    builder: (context, appState, _) => Container(
      decoration: BoxDecoration(
        color: themeColors['main'],
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10.0),
      padding: EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(flex: 2, child: Text('Lp')),
              Expanded(flex: 4, child: Text('Drużyna')),
              for (var val in ['M', 'Z', 'R', 'P'])
                Expanded(flex: 1, child: Text(val)),
              Expanded(flex: 2, child: Text('+/-')),
            ],
          ),
          Divider(
            height: 8,
            thickness: 1,
            indent: 0,
            endIndent: 0,
            color: Colors.grey,
          ),
        ],
      ),
    ),
  );
}
