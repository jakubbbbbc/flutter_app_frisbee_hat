import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/info.dart';
import 'package:gtk_flutter/plan_page.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

import 'config.dart';
import 'firebase_options.dart';
import 'src/authentication.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HatApp',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: themeColors['main'],
            ),
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<ApplicationState>(
              builder: (context, appState, _) => Authentication(
                email: appState.email,
                loginState: appState.loginState,
                startLoginFlow: appState.startLoginFlow,
                verifyEmail: appState.verifyEmail,
                signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
                cancelRegistration: appState.cancelRegistration,
                registerAccount: appState.registerAccount,
                signOut: appState.signOut,
              ),
            ),
        '/ReadScreen': (context) => const ReadScreen(),
      },
      // home: const HomePage(),
    );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  ApplicationLoginState get loginState => _loginState;
  String? _email;

  String? get email => _email;

  TabItem currentNavigationBarItem = TabItem.home;
  TabItem homeNavigationBarItem = TabItem.home;

  // players variables
  StreamSubscription<QuerySnapshot>? _playersSubscription;
  List<Player> _playersList = [];

  List<Player> get playersList => _playersList;

  Player _currentPlayer = Player(
    name: '',
    position: '',
    nickname: '',
    homeTeam: '',
    email: '',
    hatTeam: '',
    loggedIn: false,
    bio: '',
    city: '',
    uid: '',
    hasPic: false,
    isAdmin: false,
    badges: <String>[],
  );

  get currentPlayer => _currentPlayer;
  String _currentPlayerDocId = '';

  // teams variables
  var _teamsMap = new Map();

  get teamsMap => _teamsMap;

  // events variables
  StreamSubscription<QuerySnapshot>? _eventsSubscription;
  List<GeneralEvent> _eventsList = [];

  List<GeneralEvent> get eventsList => _eventsList;

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;

        // loading players and teams (only player data saved in database)
        _playersSubscription = FirebaseFirestore.instance
            .collection('players')
            .orderBy('name', descending: false)
            .snapshots()
            .listen((snapshot) async {
          _playersList = [];
          _teamsMap = new Map();
          for (final document in snapshot.docs) {
            String pName = document.data()['name'] as String;
            String pHatTeam = document.data()['hatTeam'] as String;
            _playersList.add(
              Player(
                name: pName,
                nickname: document.data()['nickname'] as String,
                hatTeam: pHatTeam,
                homeTeam: document.data()['homeTeam'] as String,
                city: document.data()['city'] as String,
                position: document.data()['position'] as String,
                bio: document.data()['bio'] as String,
                email: document.data()['email'] as String,
                loggedIn: FirebaseAuth.instance.currentUser!.email ==
                        document.data()['email'] as String
                    ? true
                    : false,
                uid: document.id,
                hasPic: document.data()['hasPic'],
                isAdmin: document.data()['isAdmin'],
                // badges: <String>[],
                badges: document.data()['badges'].cast<String>(),
              ),
            );
            // print(_playersList.last.isAdmin);

            if (_playersList.last.hasPic) {
              _playersList.last.pic =
                  await _playersList.last.downloadImage(_playersList.last.uid);
            }
            if (_playersList.last.loggedIn) {
              _currentPlayerDocId = document.id;
              _currentPlayer = _playersList.last;
            }
            // print("${pName}, ${_playersList.last.loggedIn}, ${_playersList.last.hasPic}");
            if (_teamsMap.containsKey(pHatTeam)) {
              _teamsMap[pHatTeam].teamPlayers.add(_playersList.last);
            } else {
              _teamsMap[pHatTeam] = Team(
                  name: pHatTeam,
                  color: teamColors[pHatTeam]!,
                  teamPlayers: [_playersList.last]);
            }
          }
          var sortedKeys = _teamsMap.keys.toList(growable:false)
            ..sort((k1, k2) => _teamsMap[k1].teamPlayers.length.compareTo(_teamsMap[k2].teamPlayers.length));
          print(sortedKeys);
          notifyListeners();
        });

        // loading events and games
        _eventsSubscription = FirebaseFirestore.instance
            .collection('events')
            .orderBy('date')
            .orderBy('time')
            .orderBy('place')
            .orderBy('duration')
            .snapshots()
            .listen((snapshot) async {
          _eventsList = [];
          for (final document in snapshot.docs) {
            String eCategory = document.data()['category'] as String;
            String eDate = document.data()['date'] as String;
            String eTime = document.data()['time'] as String;
            if ('mecz' == eCategory) {
              if ('' == document.data()['score1'])
                _eventsList.add(GameEvent(
                    category: eCategory,
                    name: document.data()['name'] as String,
                    duration: document.data()['duration'] as String,
                    day: document.data()['day'] as String,
                    time: eTime,
                    place: document.data()['place'] as String,
                    timestamp: DateFormat('dd.MM.yyyy, hh:mm')
                        .parse('${eDate}, ${eTime}'),
                    team1: document.data()['team1'] as String,
                    team2: document.data()['team2'] as String));
              else
                _eventsList.add(GameEvent(
                    category: eCategory,
                    name: document.data()['name'] as String,
                    duration: document.data()['duration'] as String,
                    day: document.data()['day'] as String,
                    time: eTime,
                    place: document.data()['place'] as String,
                    timestamp: DateFormat('dd.MM.yyyy, hh:mm')
                        .parse('${eDate}, ${eTime}'),
                    team1: document.data()['team1'] as String,
                    team2: document.data()['team2'] as String,
                    score1: document.data()['score1'],
                    score2: document.data()['score2']));
            } else
              _eventsList.add(GeneralEvent(
                category: eCategory,
                name: document.data()['name'] as String,
                duration: document.data()['duration'] as String,
                day: document.data()['day'] as String,
                time: eTime,
                place: document.data()['place'] as String,
                timestamp:
                    DateFormat('dd.MM.yyyy, hh:mm').parse('${eDate}, ${eTime}'),
              ));
          }
          notifyListeners();
        });
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        _playersList = [];
        _playersSubscription?.cancel();
        _eventsSubscription?.cancel();
      }
      notifyListeners();
    });
  }

  Future<void> updatePlayerInfo(String nickname, String homeTeam, String city,
      String position, String bio) async {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }
    FirebaseFirestore.instance
        .collection('players')
        .doc(_currentPlayerDocId)
        .update(<String, dynamic>{
      'nickname': nickname,
      'homeTeam': homeTeam,
      'city': city,
      'position': position,
      'bio': bio,
    });
    // FirebaseFirestore.instance
    //     .collection('events')
    //     .doc('gid2')
    //     .update(<String, dynamic>{
    //   'score2': 4,
    // });
    // notifyListeners(); //czy to potrzebne?
  }

  void startLoginFlow() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> verifyEmail(
    String email,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      var methods =
          await FirebaseAuth.instance.fetchSignInMethodsForEmail(email);
      if (methods.contains('password')) {
        _loginState = ApplicationLoginState.password;
      } else {
        _loginState = ApplicationLoginState.register;
      }
      _email = email;
      notifyListeners();
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  Future<void> signInWithEmailAndPassword(
    String email,
    String password,
    void Function(FirebaseAuthException e) errorCallback,
  ) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void cancelRegistration() {
    _loginState = ApplicationLoginState.emailAddress;
    notifyListeners();
  }

  Future<void> registerAccount(
      String email,
      String displayName,
      String password,
      void Function(FirebaseAuthException e) errorCallback) async {
    try {
      var credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      await credential.user!.updateDisplayName(displayName);
    } on FirebaseAuthException catch (e) {
      errorCallback(e);
    }
  }

  void signOut() {
    FirebaseAuth.instance.signOut();
  }
}
