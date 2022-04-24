import 'package:flutter/material.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/src/authentication.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'main.dart';
import 'navigation_bar.dart';

class TeamsPage extends StatefulWidget {
  const TeamsPage({Key? key}) : super(key: key);

  @override
  State<TeamsPage> createState() => _TeamsPageState();
}

class _TeamsPageState extends State<TeamsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Drużyny'),
      ),
      body: ListView(
        children: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
                  TeamsList(
                    teamsList: appState.teamsList,
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

class Team {
  Team({
    required this.name,
    required this.color,
    required this.teamPlayers,
  });

  final String name;
  final MaterialColor color;
  List<Player> teamPlayers;
}

class TeamsList extends StatefulWidget {
  const TeamsList({required this.teamsList});

  final Map teamsList; // new

  @override
  _TeamsListState createState() => _TeamsListState();
}

class _TeamsListState extends State<TeamsList> {
  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        for (var team in widget.teamsList.values)
          OutlinedButton(
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TeamPage(
                            team: team,
                          )));
            },
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(right: 10.0),
                    child: CircleAvatar(
                      backgroundColor: team.color,
                    ),
                  ),
                  Expanded(
                    child: Text(team.name,
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

class TeamPage extends StatefulWidget {
  const TeamPage({Key? key, required this.team}) : super(key: key);
  final Team team;

  @override
  State<TeamPage> createState() => _TeamPageState();
}

class _TeamPageState extends State<TeamPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Scaffold(
        appBar: AppBar(
          title: const Text('Drużyna'),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 10),
              CircleAvatar(
                backgroundColor: widget.team.color,
                minRadius: 40,
              ),
              const SizedBox(height: 10),
              Center(
                child: Text(
                  widget.team.name,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
              // const SizedBox(height: 10),
              Center(
                child: Text(
                  colorNames[widget.team.color]!,
                  // widget.team.color.toString(),
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
              const SizedBox(height: 20),
              const Divider(
                height: 8,
                thickness: 1,
                indent: 8,
                endIndent: 8,
                color: Colors.grey,
              ),
              Header('Zawodnicy'),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  for (var player in widget.team.teamPlayers)
                    OutlinedButton(
                      onPressed: () async {
                        appState.currentNavigationBarItem = TabItem.players;
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfilePage(
                                      player: player,
                                    )));
                        appState.currentNavigationBarItem = TabItem.teams;
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(right: 10.0),
                              child: CircleAvatar(
                                backgroundColor: widget.team.color,
                                child: player.pic != null
                                    ? SizedBox(
                                        width: 35,
                                        height: 35,
                                        child: ClipOval(
                                            child: Image.memory(
                                          player.pic!,
                                          fit: BoxFit.cover,
                                        )),
                                      )
                                    : Text(player.name[0]+player.name.split(' ').last[0]),
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
              ),
            ],
            // to here.
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar,
      ),
    );
  }
}
