import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/authentication.dart';
import 'package:provider/provider.dart';
import 'src/widgets.dart';

import 'main.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  // final List<Player> _players = [
  //   const Player(name: 'Jakub Ciemięga'),
  //   const Player(name: 'Adam Biegała'),
  //   const Player(name: 'Imię Nazwisko'),
  //   const Player(name: 'Andrzej Testowy'),
  //   const Player(name: 'Marek Kalicki'),
  // ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zawodnicy'),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // // Add from here
                // if (appState.attendees >= 2)
                //   Paragraph('${appState.attendees} people going')
                // else if (appState.attendees == 1)
                //   const Paragraph('1 person going')
                // else
                //   const Paragraph('No one going'),
                // // To here.
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  // // Add from here
                  // YesNoSelection(
                  //   state: appState.attending,
                  //   onSelection: (attending) => appState.attending = attending,
                  // ),
                  // // To here.
                  // const Header('Discussion'),
                  PlayersList(
                    playersList: appState.playersList,
                  ),
                ],
              ],
            ),
          ),
          // To here.
        ],
      ),
    );
  }
}

class Player {
  const Player({
    required this.name,
    required this.nickname,
    required this.hatTeam,
    required this.homeTeam,
    required this.city,
    required this.position,
    required this.bio,
    // required this.city,
  });

  final String name;
  final String nickname;
  final String hatTeam;
  final String homeTeam;
  final String city;
  final String position;
  final String bio;
}

class PlayersList extends StatefulWidget {
  const PlayersList({required this.playersList});

  final List<Player> playersList; // new

  @override
  _PlayersListState createState() => _PlayersListState();
}

class _PlayersListState extends State<PlayersList> {
  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (var player in widget.playersList)
          // Paragraph('${player.name}: ${player.nickname}'),
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            player: player,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(child: Text(player.name[0])),
                  ),
                  Expanded(
                    child: Text(player.name,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                ],
              ),
            ),
          ),
      ],
      // to here.
    );
  }
}

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key, required this.player}) : super(key: key);
  final Player player;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zawodnik'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 10),
          CircleAvatar(
            child: Text(widget.player.name[0]),
            minRadius: 40,
          ),
          const SizedBox(height: 10),
          Center(
            child: Text(
              widget.player.name,
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          const SizedBox(height: 10),
          Center(
            child: widget.player.nickname != ""
                ? Text(
                    '\"${widget.player.nickname}\"',
                    style: Theme.of(context).textTheme.headline6,
                  )
                : null,
          ),
          const SizedBox(height: 20),
          const Divider(
            height: 8,
            thickness: 1,
            indent: 8,
            endIndent: 8,
            color: Colors.grey,
          ),
          Header('Podstawowe informacje'),
          Container(
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 10.0),
            child: Column(
              children: [
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(right: 10.0, left: 8),
                      child: Icon(Icons.people),
                    ),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(widget.player.hatTeam),
                          const Text('drużyna hatowa')
                        ],
                      ),
                    ),
                  ],
                ),
                if (widget.player.homeTeam != "")
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.black,
                  ),
                if (widget.player.homeTeam != "")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10.0, left: 8),
                        child: Icon(Icons.people),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.player.homeTeam),
                            const Text('drużyna domowa')
                          ],
                        ),
                      ),
                    ],
                  ),
                if (widget.player.city != "")
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.black,
                  ),
                if (widget.player.city != "")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10.0, left: 8),
                        child: Icon(Icons.location_city),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.player.city),
                            const Text('miasto')
                          ],
                        ),
                      ),
                    ],
                  ),
                if (widget.player.position != "")
                  const Divider(
                    height: 8,
                    thickness: 1,
                    indent: 8,
                    endIndent: 8,
                    color: Colors.black,
                  ),
                if (widget.player.position != "")
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(right: 10.0, left: 8),
                        child: Icon(Icons.directions_run),
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(widget.player.position),
                            const Text('pozycja na boisku')
                          ],
                        ),
                      ),
                    ],
                  ),
                const SizedBox(height: 8),
              ],
            ),
          ),
          if (widget.player.bio != "") Header('Bio'),
          if (widget.player.bio != "")
            Container(
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.all(Radius.circular(10)),
              ),
              margin: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      Expanded(child: Text(widget.player.bio)),
                      const SizedBox(width: 8),
                    ],
                  ),
                  const SizedBox(height: 8),
                ],
              ),
            ),
        ],
        // to here.
      ),
    );
  }
}
