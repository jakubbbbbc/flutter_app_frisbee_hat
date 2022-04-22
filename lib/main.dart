import 'dart:async';
import 'dart:collection';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart'; // new
import 'package:firebase_core/firebase_core.dart'; // new
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:gtk_flutter/info.dart';
import 'package:gtk_flutter/players_page.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:provider/provider.dart'; // new

import 'firebase_options.dart'; // new
import 'src/authentication.dart'; // new
import 'src/widgets.dart';

void main() {
  // Modify from here
  runApp(
    ChangeNotifierProvider(
      create: (context) => ApplicationState(),
      builder: (context, _) => App(),
    ),
  );
  // to here
}

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'HatApp',
      theme: ThemeData(
        buttonTheme: Theme.of(context).buttonTheme.copyWith(
              highlightColor: Colors.green,
            ),
        primarySwatch: Colors.green,
        textTheme: GoogleFonts.robotoTextTheme(
          Theme.of(context).textTheme,
        ),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/ReadScreen': (context) => const ReadScreen(),
      },
      // home: const HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
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
    );
    // return Scaffold(
    //   appBar: AppBar(
    //     title: const Text('Firebase Meetup'),
    //   ),
    //   body: ListView(
    //     children: <Widget>[
    //       Image.asset('assets/codelab.png'),
    //       const SizedBox(height: 8),
    //       const IconAndDetail(Icons.calendar_today, 'October 30'),
    //       const IconAndDetail(Icons.location_city, 'San Francisco'),
    //       Consumer<ApplicationState>(
    //         builder: (context, appState, _) => Authentication(
    //           email: appState.email,
    //           loginState: appState.loginState,
    //           startLoginFlow: appState.startLoginFlow,
    //           verifyEmail: appState.verifyEmail,
    //           signInWithEmailAndPassword: appState.signInWithEmailAndPassword,
    //           cancelRegistration: appState.cancelRegistration,
    //           registerAccount: appState.registerAccount,
    //           signOut: appState.signOut,
    //         ),
    //       ),
    //       const Divider(
    //         height: 8,
    //         thickness: 1,
    //         indent: 8,
    //         endIndent: 8,
    //         color: Colors.grey,
    //       ),
    //       const Header("What we'll be doing"),
    //       const Paragraph(
    //         'Join us for a day full of Firebase Workshops and Pizza!',
    //       ),
    //       // Modify from here
    //       Consumer<ApplicationState>(
    //         builder: (context, appState, _) => Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             // Add from here
    //             if (appState.attendees >= 2)
    //               Paragraph('${appState.attendees} people going')
    //             else if (appState.attendees == 1)
    //               const Paragraph('1 person going')
    //             else
    //               const Paragraph('No one going'),
    //             // To here.
    //             if (appState.loginState == ApplicationLoginState.loggedIn) ...[
    //               // Add from here
    //               YesNoSelection(
    //                 state: appState.attending,
    //                 onSelection: (attending) => appState.attending = attending,
    //               ),
    //               // To here.
    //               const Header('Discussion'),
    //               GuestBook(
    //                 addMessage: (message) =>
    //                     appState.addMessageToGuestBook(message),
    //                 messages: appState.guestBookMessages,
    //               ),
    //             ],
    //           ],
    //         ),
    //       ),
    //       // To here.
    //     ],
    //   ),
    // );
  }
}

class ApplicationState extends ChangeNotifier {
  ApplicationState() {
    init();
  }

  Future<void> init() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    // Add from here
    // FirebaseFirestore.instance
    //     .collection('attendees')
    //     .where('attending', isEqualTo: true)
    //     .snapshots()
    //     .listen((snapshot) {
    //   _attendees = snapshot.docs.length;
    //   notifyListeners();
    // });
    // To here

    FirebaseAuth.instance.userChanges().listen((user) {
      if (user != null) {
        _loginState = ApplicationLoginState.loggedIn;
        // _guestBookSubscription = FirebaseFirestore.instance
        //     .collection('guestbook')
        //     .orderBy('timestamp', descending: true)
        //     .snapshots()
        //     .listen((snapshot) {
        //   _guestBookMessages = [];
        //   for (final document in snapshot.docs) {
        //     _guestBookMessages.add(
        //       GuestBookMessage(
        //         name: document.data()['name'] as String,
        //         message: document.data()['text'] as String,
        //       ),
        //     );
        //   }
        //   notifyListeners();
        // });
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
              ),
            );
            if (_playersList.last.hasPic) {
              _playersList.last.pic = await _playersList.last
                  .downloadImage(_playersList.last.uid);
            }
            if (FirebaseAuth.instance.currentUser!.email ==
                document.data()['email'] as String) {
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
          notifyListeners();
        });
        // Add from here
        // _attendingSubscription = FirebaseFirestore.instance
        //     .collection('attendees')
        //     .doc(user.uid)
        //     .snapshots()
        //     .listen((snapshot) {
        //   if (snapshot.data() != null) {
        //     if (snapshot.data()!['attending'] as bool) {
        //       _attending = Attending.yes;
        //     } else {
        //       _attending = Attending.no;
        //     }
        //   } else {
        //     _attending = Attending.unknown;
        //   }
        //   notifyListeners();
        // });
        // to here
      } else {
        _loginState = ApplicationLoginState.loggedOut;
        // _guestBookMessages = [];
        // _guestBookSubscription?.cancel();
        _playersList = [];
        _playersSubscription?.cancel();
        // _attendingSubscription?.cancel(); // new
      }
      notifyListeners();
    });
  }

  // Add from here
  // Future<DocumentReference> addMessageToGuestBook(String message) {
  //   if (_loginState != ApplicationLoginState.loggedIn) {
  //     throw Exception('Must be logged in');
  //   }
  //
  //   return FirebaseFirestore.instance
  //       .collection('guestbook')
  //       .add(<String, dynamic>{
  //     'text': message,
  //     'timestamp': DateTime.now().millisecondsSinceEpoch,
  //     'name': FirebaseAuth.instance.currentUser!.displayName,
  //     'userId': FirebaseAuth.instance.currentUser!.uid,
  //   });
  // }

  Future<void> updatePlayerInfo(String nickname, String homeTeam, String city,
      String position, String bio) {
    if (_loginState != ApplicationLoginState.loggedIn) {
      throw Exception('Must be logged in');
    }

    return FirebaseFirestore.instance
        .collection('players')
        .doc(_currentPlayerDocId)
        .update(<String, dynamic>{
      'nickname': nickname,
      'homeTeam': homeTeam,
      'city': city,
      'position': position,
      'bio': bio,
    });
  }

  // To here

  ApplicationLoginState _loginState = ApplicationLoginState.loggedOut;

  ApplicationLoginState get loginState => _loginState;
  String? _email;

  String? get email => _email;

  // Add from here
  // StreamSubscription<QuerySnapshot>? _guestBookSubscription;
  // List<GuestBookMessage> _guestBookMessages = [];
  //
  // List<GuestBookMessage> get guestBookMessages => _guestBookMessages;

  // to here.

  StreamSubscription<QuerySnapshot>? _playersSubscription;
  List<Player> _playersList = [];

  List<Player> get playersList => _playersList;
  var _teamsMap = new Map();

  get teamsList => _teamsMap;

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
  );

  get currentPlayer => _currentPlayer;
  String _currentPlayerDocId = '';

  // int _attendees = 0;
  //
  // int get attendees => _attendees;

  // Attending _attending = Attending.unknown;
  // StreamSubscription<DocumentSnapshot>? _attendingSubscription;

  // Attending get attending => _attending;

  // set attending(Attending attending) {
  //   final userDoc = FirebaseFirestore.instance
  //       .collection('attendees')
  //       .doc(FirebaseAuth.instance.currentUser!.uid);
  //   if (attending == Attending.yes) {
  //     userDoc.set(<String, dynamic>{'attending': true});
  //   } else {
  //     userDoc.set(<String, dynamic>{'attending': false});
  //   }
  // }

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

class GuestBookMessage {
  GuestBookMessage({required this.name, required this.message});

  final String name;
  final String message;
}

enum Attending { yes, no, unknown }

class GuestBook extends StatefulWidget {
  const GuestBook({required this.addMessage, required this.messages});

  final FutureOr<void> Function(String message) addMessage;
  final List<GuestBookMessage> messages; // new

  @override
  _GuestBookState createState() => _GuestBookState();
}

class _GuestBookState extends State<GuestBook> {
  final _formKey = GlobalKey<FormState>(debugLabel: '_GuestBookState');
  final _controller = TextEditingController();

  @override
  // Modify from here
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // to here.
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Leave a message',
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your message to continue';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 8),
                StyledButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await widget.addMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                  child: Row(
                    children: const [
                      Icon(Icons.send),
                      SizedBox(width: 4),
                      Text('SEND'),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        // Modify from here
        const SizedBox(height: 8),
        for (var message in widget.messages)
          Paragraph('${message.name}: ${message.message}'),
        const SizedBox(height: 8),
      ],
      // to here.
    );
  }
}

class YesNoSelection extends StatelessWidget {
  const YesNoSelection({required this.state, required this.onSelection});

  final Attending state;
  final void Function(Attending selection) onSelection;

  @override
  Widget build(BuildContext context) {
    switch (state) {
      case Attending.yes:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              TextButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      case Attending.no:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              TextButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                style: ElevatedButton.styleFrom(elevation: 0),
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
      default:
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              StyledButton(
                onPressed: () => onSelection(Attending.yes),
                child: const Text('YES'),
              ),
              const SizedBox(width: 8),
              StyledButton(
                onPressed: () => onSelection(Attending.no),
                child: const Text('NO'),
              ),
            ],
          ),
        );
    }
  }
}

final teamColors = {
  'Bazyliszki': Colors.blue,
  'Smaugi': Colors.yellow,
  'Rogogony': Colors.red,
};

final colorNames = {
  Colors.blue: 'niebieski',
  Colors.yellow: 'żółty',
  Colors.red: 'czerwony',
};
