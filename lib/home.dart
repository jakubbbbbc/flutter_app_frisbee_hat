import 'package:flutter/material.dart';
import 'package:gtk_flutter/main.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:provider/provider.dart';
import 'package:gtk_flutter/src/authentication.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
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
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                            .teamsList[
                                                appState.currentPlayer.hatTeam]
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
                                            : Text(
                                                appState.currentPlayer.name[0]),
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
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamPage(
                                              team: appState.teamsList[appState
                                                  .currentPlayer.hatTeam],
                                            )));
                              },
                              style: ElevatedButton.styleFrom(
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10))),
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
                                              .teamsList[appState
                                                  .currentPlayer.hatTeam]
                                              .color,
                                        ),
                                      ),
                                    ),
                                    Text(appState
                                        .teamsList[
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
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(context, '/ReadScreen');
                            },
                            child: const Text('Następny mecz'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              showLogoutDialog(context);
                            },
                            child: const Text('Odznaki'),
                          ),
                        ],
                      ),
                    ],
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
