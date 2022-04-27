import 'package:flutter/material.dart';
import 'package:gtk_flutter/plan_page.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/src/widgets.dart';
import 'package:provider/provider.dart';

import 'config.dart';
import 'main.dart';
import 'navigation_bar.dart';

class BadgesEditPage extends StatefulWidget {
  const BadgesEditPage({Key? key, required this.player}) : super(key: key);
  final Player player;

  @override
  State<BadgesEditPage> createState() => _BadgesEditPageState();
}

class _BadgesEditPageState extends State<BadgesEditPage> {
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edycja odznak'),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Header('Przyznane odznaki' + ': ' + widget.player.name),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    children: [
                      for (var badge in badgeIcons.keys)
                        LayoutBuilder(
                          builder: (BuildContext context,
                                  BoxConstraints constraints) =>
                              Container(
                            decoration: BoxDecoration(
                              color: themeColors['main']!,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10)),
                            ),
                            padding: EdgeInsets.all(10),
                            margin: EdgeInsets.all(10),
                            child: Column(
                              children: [
                                Text(
                                  badge,
                                  style: TextStyle(color: Colors.white),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Center(
                                  child: Stack(
                                    alignment: Alignment.center,
                                    children: [
                                      Icon(
                                        badgeIcons[badge],
                                        size: constraints.maxWidth / 2,
                                        color: themeColors['dark'],
                                      ),
                                      Transform.scale(
                                        scale: 1.5,
                                        child: Checkbox(
                                          value: widget.player.badges
                                              .contains(badge),
                                          onChanged: (value) async {
                                            if (value!)
                                              widget.player.badges.add(badge);
                                            else
                                              widget.player.badges
                                                  .remove(badge);
                                            _isLoading = true;
                                            await appState.updatePlayerBadges(
                                                widget.player.uid,
                                                widget.player.badges);
                                            _isLoading = false;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  badgeDescription[badge]!,
                                  style: TextStyle(color: Colors.white),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
                // to here.
              ),
            ),
          ),
          new Align(
            child: _isLoading ? loadingIndicator : new Container(),
            alignment: FractionalOffset.center,
          ),
        ],
      ),
      bottomNavigationBar: _isLoading ? null : MyBottomNavigationBar,
    );
  }
}

class ScoreEditPage extends StatefulWidget {
  const ScoreEditPage({Key? key, required this.game}) : super(key: key);
  final GameEvent game;

  @override
  State<ScoreEditPage> createState() => _ScoreEditPageState();
}

class _ScoreEditPageState extends State<ScoreEditPage> {
  bool _isLoading = false;

  final _score1Controller = TextEditingController();
  final _score2Controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _score1Controller.text = widget.game.score1.toString();
    _score2Controller.text = widget.game.score2.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edycja wyniku meczu'),
        actions: <Widget>[
          IconButton(
            onPressed: () {
              _isLoading
                  ? null
                  : showEditScoreDialog(
                      context,
                      widget.game,
                      int.parse(_score1Controller.text),
                      int.parse(_score2Controller.text));
            },
            color: Colors.white,
            padding: EdgeInsets.only(right: 5),
            icon: Icon(Icons.check),
          ),
        ],
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Consumer<ApplicationState>(
              builder: (context, appState, _) => Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Header('Wynik'),
                  Container(
                    decoration: BoxDecoration(
                      color: themeColors['main']!,
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 10.0),
                    padding: EdgeInsets.all(8),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              maxRadius: 15,
                              backgroundColor:
                                  appState.teamsMap[widget.game.team1].color,
                            ),
                            SizedBox(width: 10),
                            Text(widget.game.team1, textScaleFactor: 1.5),
                            Spacer(),
                            Container(
                              width: 60,
                              child: TextFormField(
                                controller: _score1Controller,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeColors['dark']!,
                                      width: 3,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeColors['dark']!,
                                      width: 3,
                                    ),
                                  ),
                                  // hintText: 'Drużyna domowa',
                                  // labelText: 'Wynik 1',
                                  labelStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.white,
                                  filled: true,
                                  // focusColor: Colors.yellow,
                                  // hoverColor: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Divider(
                          height: 8,
                          thickness: 2,
                          color: Colors.grey,
                        ),
                        Row(
                          children: [
                            CircleAvatar(
                              maxRadius: 15,
                              backgroundColor:
                                  appState.teamsMap[widget.game.team2].color,
                            ),
                            SizedBox(width: 10),
                            Text(widget.game.team2, textScaleFactor: 1.5),
                            Spacer(),
                            Container(
                              width: 60,
                              child: TextFormField(
                                controller: _score2Controller,
                                keyboardType: TextInputType.number,
                                textAlign: TextAlign.center,
                                decoration: InputDecoration(
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeColors['dark']!,
                                      width: 3,
                                    ),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: themeColors['dark']!,
                                      width: 3,
                                    ),
                                  ),
                                  // hintText: 'Drużyna domowa',
                                  // labelText: 'Wynik 1',
                                  labelStyle: TextStyle(color: Colors.black),
                                  fillColor: Colors.white,
                                  filled: true,
                                  // focusColor: Colors.yellow,
                                  // hoverColor: Colors.purple,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
                // to here.
              ),
            ),
          ),
          new Align(
            child: _isLoading ? loadingIndicator : new Container(),
            alignment: FractionalOffset.center,
          ),
        ],
      ),
      bottomNavigationBar: _isLoading ? null : MyBottomNavigationBar,
    );
  }
}

showEditScoreDialog(
    BuildContext context, GameEvent game, int score1, int score2) {
  Widget cancelButton = TextButton(
    child: Text("Cofnij"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text("Zapisz"),
    onPressed: () {
      //TODO implement firebase save and team results update
      //TODO how to pop context twice? - is it necessary?
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Potwierdzenie zmiany wyniku meczu"),
    content: Text("Czy na pewno zapisać nowy wynik meczu?"),
    actions: [
      cancelButton,
      continueButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
