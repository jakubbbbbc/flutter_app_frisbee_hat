import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gtk_flutter/src/authentication.dart';
import 'package:gtk_flutter/teams_page.dart';
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
  Player({
    required this.name,
    required this.nickname,
    required this.hatTeam,
    required this.homeTeam,
    required this.city,
    required this.position,
    required this.bio,
    required this.email,
    required this.loggedIn,
  });

  final String name;
  String nickname;
  final String hatTeam;
  String homeTeam;
  String city;
  String position;
  String bio;
  final String email;
  final bool loggedIn;
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
                  Consumer<ApplicationState>(
                    builder: (context, appState, _) => Container(
                      margin: const EdgeInsets.only(right: 10.0),
                      child: CircleAvatar(
                          backgroundColor:
                              appState.teamsList[player.hatTeam].color,
                          child: Text(player.name[0])),
                    ),
                  ),
                  Expanded(
                    child: Text(player.name,
                        style: Theme.of(context).textTheme.headline4),
                  ),
                  Container(
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Icon(
                          Icons.arrow_forward_ios,
                          size: 15,
                        ),
                      ],
                    ),
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
      appBar: widget.player.loggedIn
          ? AppBar(
              title: const Text('Zawodnik'),
              actions: <Widget>[
                TextButton(
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfileEditPage(
                                  player: widget.player,
                                )));
                    setState(() {});
                  },
                  style: ButtonStyle(
                    foregroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    padding:
                        MaterialStateProperty.all<EdgeInsets>(EdgeInsets.zero),
                  ),
                  child: Icon(Icons.edit),
                ),
              ],
            )
          : AppBar(
              title: const Text('Zawodnik'),
            ),
      body: SingleChildScrollView(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                backgroundColor:
                    appState.teamsList[widget.player.hatTeam].color,
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
                    // const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TeamPage(
                                      team: appState
                                          .teamsList[widget.player.hatTeam],
                                    )));
                      },
                      style: ButtonStyle(
                        foregroundColor:
                            MaterialStateProperty.all<Color>(Colors.black),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            EdgeInsets.zero),
                      ),
                      child: Row(
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
                          Container(
                            margin: const EdgeInsets.only(right: 8, left: 10),
                            child: Column(
                              children: [
                                const SizedBox(height: 10),
                                Icon(
                                  Icons.arrow_forward_ios,
                                  size: 15,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
        ),
      ),
    );
  }
}

class ProfileEditPage extends StatefulWidget {
  const ProfileEditPage({Key? key, required this.player}) : super(key: key);
  final Player player;

  @override
  State<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends State<ProfileEditPage> {
  final _nicknameController = TextEditingController();
  final _homeTeamController = TextEditingController();
  final _cityController = TextEditingController();
  final _positionController = TextEditingController();
  final _bioController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _nicknameController.text = widget.player.nickname;
    _homeTeamController.text = widget.player.homeTeam;
    _cityController.text = widget.player.city;
    _positionController.text = widget.player.position;
    _bioController.text = widget.player.bio;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edycja profilu'),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => TextButton(
              onPressed: () async {
                // if (widget.player.nickname != _nicknameController.text)
                await appState.updatePlayerInfo(
                    _nicknameController.text,
                    _homeTeamController.text,
                    _cityController.text,
                    _positionController.text,
                    _bioController.text);
                widget.player.nickname = _nicknameController.text;
                widget.player.homeTeam = _homeTeamController.text;
                widget.player.city = _cityController.text;
                widget.player.position = _positionController.text;
                widget.player.bio = _bioController.text;
                Navigator.pop(context);
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Icon(Icons.check),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer<ApplicationState>(
          builder: (context, appState, _) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 24, bottom: 8),
                    child: StyledButton(
                      onPressed: () {
                        FirebaseAuth.instance.signOut();
                        Navigator.popUntil(context, ModalRoute.withName("/"));
                      },
                      child: const Text('LOGOUT'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: _nicknameController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          // hintText: 'Drużyna domowa',
                          labelText: 'Pseudonim',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                          // focusColor: Colors.yellow,
                          // hoverColor: Colors.purple,
                        ),
                        // validator: (value) {
                        //   if (value!.isEmpty) {
                        //     return 'Enter your account name';
                        //   }
                        //   return null;
                        // },
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: _homeTeamController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          labelText: 'Drużyna domowa',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: _cityController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          labelText: 'Miasto',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: _positionController,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          labelText: 'Pozycja',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: TextFormField(
                        controller: _bioController,
                        minLines: 3,
                        maxLines: null,
                        decoration: InputDecoration(
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.green.shade800,
                              width: 3,
                            ),
                          ),
                          labelText: 'Bio',
                          hintText: 'Powiedz nam coś o sobie',
                          labelStyle: TextStyle(color: Colors.black),
                          fillColor: Colors.white,
                          filled: true,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ],
            // to here.
          ),
        ),
      ),
    );
  }
}
