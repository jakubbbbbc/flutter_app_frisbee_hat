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
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Consumer<ApplicationState>(
        builder: (context, appState, _) => Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  // crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ConstrainedBox(
                      constraints: const BoxConstraints.tightFor(
                          width: 100, height: 100),
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
                        child: const Text('Twój profil'),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeamPage(
                                      team: appState.teamsList[
                                          appState.currentPlayer.hatTeam],
                                    )));
                      },
                      child: const Text('Twoja drużyna'),
                    ),
                  ],
                ),
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
            new Align(
              child: appState.currentPlayer.uid == ''
                  ? loadingIndicator
                  : new Container(),
              alignment: FractionalOffset.center,
            ),
          ],
        ),
      ),
    );
  }
}
