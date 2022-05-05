import 'package:flutter/material.dart';
import 'package:gtk_flutter/plan_page.dart';
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
                    teamsList: appState.teamsMap,
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
    this.numPoints = 0,
    this.numWins = 0,
    this.numDraws = 0,
    this.numLoses = 0,
    this.pointDiff = 0,
  });

  final String name;
  final MaterialColor color;
  List<Player> teamPlayers;
  int numPoints;
  int numWins;
  int numDraws;
  int numLoses;
  int pointDiff;

  Future<void> updateScores(List<GeneralEvent> eventList) async {
    this.numWins = 0;
    this.numDraws = 0;
    this.numLoses = 0;
    this.pointDiff = 0;
    for (var event in eventList) {
      if (event is GameEvent) {
        GameEvent game = event;
        if ((game.score1 != 0 || game.score2 != 0) &&
            (this.name == game.team1 || this.name == game.team2)) {
          int score1 = this.name == game.team1 ? game.score1 : game.score2;
          int score2 = this.name == game.team1 ? game.score2 : game.score1;
          this.pointDiff += score1 - score2;
          if (score1 > score2)
            this.numWins += 1;
          else if (score1 == score2)
            this.numDraws += 1;
          else
            this.numLoses += 1;
        }
      }
    }
    this.numPoints = this.numWins * 3 + this.numDraws;
  }
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
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          for (var team in widget.teamsList.values)
            OutlinedButton(
              onPressed: () {
                appState.currentNavigationBarItem = TabItem.teams;
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
      ),
    );
  }
}

class TeamPage extends StatefulWidget {
  TeamPage({Key? key, required this.team, this.subpage = 0}) : super(key: key);
  final Team team;
  int subpage;

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
              Container(
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Row(
                  children: [
                    Expanded(
                      flex: 5,
                      child: TextButton(
                          onPressed: () {
                            widget.subpage = 0;
                            setState(() {});
                          },
                          child: Text('Zawdonicy')),
                    ),
                    Expanded(
                      flex: 5,
                      child: TextButton(
                          onPressed: () {
                            widget.subpage = 1;
                            setState(() {});
                          },
                          child: Text('Mecze')),
                    ),
                  ],
                ),
              ),
              Stack(children: [
                const Divider(
                  height: 8,
                  thickness: 1,
                  indent: 8,
                  endIndent: 8,
                  color: Colors.grey,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: 0 == widget.subpage
                            ? CrossAxisAlignment.start
                            : CrossAxisAlignment.end,
                        children: [
                          FractionallySizedBox(
                            widthFactor: 0.5,
                            child: 0 == widget.subpage
                                ? Divider(
                                    height: 5,
                                    thickness: 5,
                                    indent: 8,
                                    endIndent: 0,
                                    color: Colors.grey,
                                  )
                                : Divider(
                                    height: 5,
                                    thickness: 5,
                                    indent: 0,
                                    endIndent: 8,
                                    color: Colors.grey,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ]),
              if (0 == widget.subpage) ...[
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
                                      : Text(player.name[0] +
                                          player.name.split(' ').last[0]),
                                ),
                              ),
                              Expanded(
                                child: Text(player.name,
                                    style:
                                        Theme.of(context).textTheme.headline4),
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
              if (1 == widget.subpage) ...[
                Header('Mecze'),
                displayTeamGames(widget.team.name, appState.eventsList),
              ],
            ],
            // to here.
          ),
        ),
        bottomNavigationBar: MyBottomNavigationBar,
      ),
    );
  }
}

Widget displayTeamGames(String teamName, List<GeneralEvent> eventsList) {
  List<GameEvent>? teamGames = [];
  for (var event in eventsList) {
    if (event is GameEvent) if (teamName == event.team1 ||
        teamName == event.team2) teamGames.add(event);
  }
  if (teamGames == []) return Container();

  return ListView(
    shrinkWrap: true,
    physics: NeverScrollableScrollPhysics(),
    children: <Widget>[
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          for (var game in teamGames) ...[
            displayGame(game),
            SizedBox(height: 10),
          ]
        ],
      ),
      // To here.
    ],
  );
}
