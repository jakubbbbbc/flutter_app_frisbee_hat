import 'package:flutter/material.dart';
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
                  Header('Przyznane odznaki'),
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
                                      Checkbox(
                                        value: widget.player.badges
                                            .contains(badge),
                                        onChanged: (value) {
                                          if (value!)
                                            widget.player.badges.add(badge);
                                          else
                                            widget.player.badges.remove(badge);
                                          appState.updatePlayerBadges(
                                              widget.player.uid,
                                              widget.player.badges);
                                          setState(() {});
                                        },
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
//
// class _TestSignInViewState extends State<TestSignInView> {
//   bool _load = false;
//
//   @override
//   Widget build(BuildContext context) {
//     Widget loadingIndicator = _load
//         ? new Container(
//             color: Colors.grey[300],
//             width: 70.0,
//             height: 70.0,
//             child: new Padding(
//                 padding: const EdgeInsets.all(5.0),
//                 child: new Center(child: new CircularProgressIndicator())),
//           )
//         : new Container();
//     return new Scaffold(
//         backgroundColor: Colors.white,
//         body: new Stack(
//           children: <Widget>[
//             new Padding(
//               padding:
//                   const EdgeInsets.symmetric(vertical: 50.0, horizontal: 20.0),
//               child: new ListView(
//                 children: <Widget>[
//                   new Column(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     children: <Widget>[
//                       new TextField(),
//                       new TextField(),
//                       new FlatButton(
//                           color: Colors.blue,
//                           child: new Text('Sign In'),
//                           onPressed: () {
//                             setState(() {
//                               _load = true;
//                             });
//
//                             //Navigator.of(context).push(new MaterialPageRoute(builder: (_)=>new HomeTest()));
//                           }),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//             new Align(
//               child: loadingIndicator,
//               alignment: FractionalOffset.center,
//             ),
//           ],
//         ));
//   }
// }
