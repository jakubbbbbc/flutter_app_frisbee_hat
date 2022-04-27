import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/material.dart';
import 'package:gtk_flutter/navigation_bar.dart';

import 'package:gtk_flutter/src/authentication.dart';
import 'package:gtk_flutter/teams_page.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'admin_functions.dart';
import 'src/widgets.dart';
import 'config.dart';

import 'main.dart';

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
    required this.uid,
    this.pic,
    required this.hasPic,
    required this.isAdmin,
    required this.badges,
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
  final String uid;
  Uint8List? pic;
  bool hasPic;
  final bool isAdmin;
  final List<String> badges;

  Future<Uint8List?> downloadImage(String fname) async {
    // Create a storage reference from our app
    final storageRef =
        FirebaseStorage.instance.ref().child('profile_pics').child(fname);

    try {
      const oneMegabyte = 1024 * 1024 * 4;
      final Uint8List? data = await storageRef.getData(oneMegabyte);
      // return MemoryImage(data!) as File;
      // return MemoryImage(data!);
      return data!;
    } on FirebaseException catch (e) {
      print(e);
    }
    return null;
  }
}

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
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
                if (appState.loginState == ApplicationLoginState.loggedIn) ...[
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
    return Consumer<ApplicationState>(
      builder: (context, appState, _) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          for (var player in widget.playersList)
            // Paragraph('${player.name}: ${player.nickname}'),
            OutlinedButton(
              onPressed: () {
                appState.currentNavigationBarItem = TabItem.players;
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
                      child: CircleAvatar(
                        minRadius: 20,
                        backgroundColor:
                            appState.teamsMap[player.hatTeam].color,
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
    );
  }
}

class ProfilePage extends StatefulWidget {
  ProfilePage({Key? key, required this.player, this.subpage = 0})
      : super(key: key);
  final Player player;
  int subpage;

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // int subpage = 0;

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplicationState>(
        builder: (context, appState, _) => Scaffold(
              appBar: AppBar(
                title: const Text('Zawodnik'),
                actions: <Widget>[
                  if (appState.currentPlayer.isAdmin) ...[
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => BadgesEditPage(
                                  player: widget.player,
                                )));
                        setState(() {});
                      },
                      color: Colors.white,
                      // padding: EdgeInsets.only(right: 5),
                      icon: Icon(Icons.admin_panel_settings),
                    ),
                  ],
                  if (widget.player.loggedIn) ...[
                    IconButton(
                      onPressed: () async {
                        await Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProfileEditPage(
                                      player: widget.player,
                                    )));
                        setState(() {});
                      },
                      color: Colors.white,
                      // padding: EdgeInsets.only(right: 5),
                      icon: Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        showLogoutDialog(context);
                      },
                      color: Colors.white,
                      padding: EdgeInsets.only(right: 5),
                      icon: Icon(Icons.logout),
                    ),
                  ],
                ],
              ),
              body: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    // Center(
                    //   child: ProfilePicture(
                    //     name: widget.player.name,
                    //     radius: 31,
                    //     fontsize: 31,
                    //     img:
                    //         'http://bestprofilepix.com/wp-content/uploads/2014/03/sad-and-alone-boys-facebook-profile-pictures.jpg',
                    //     // role: 'test',
                    //     // tooltip: true,
                    //   ),
                    // ),
                    CircleAvatar(
                      backgroundColor:
                          appState.teamsMap[widget.player.hatTeam].color,
                      child: widget.player.pic != null
                          ? SizedBox(
                              width: 70,
                              height: 70,
                              child: ClipOval(
                                  child: Image.memory(
                                widget.player.pic!,
                                fit: BoxFit.cover,
                              )),
                            )
                          : Text(widget.player.name[0] +
                              widget.player.name.split(' ').last[0]),
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
                                child: Text('Informacje')),
                          ),
                          Expanded(
                            flex: 5,
                            child: TextButton(
                                onPressed: () {
                                  widget.subpage = 1;
                                  setState(() {});
                                },
                                child: Text('Odznaki')),
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
                      Header('Podstawowe informacje'),
                      Container(
                        decoration: BoxDecoration(
                          color: themeColors['main']!,
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 10.0),
                        child: Column(
                          children: [
                            // const SizedBox(height: 8),
                            TextButton(
                              onPressed: () async {
                                appState.currentNavigationBarItem =
                                    TabItem.teams;
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => TeamPage(
                                              team: appState.teamsMap[
                                                  widget.player.hatTeam],
                                            )));
                                appState.currentNavigationBarItem =
                                    TabItem.players;
                              },
                              style: ButtonStyle(
                                foregroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.black),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                    EdgeInsets.zero),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 10.0, left: 8),
                                    child: Icon(Icons.people),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(widget.player.hatTeam),
                                        const Text('drużyna hatowa')
                                      ],
                                    ),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        right: 8, left: 10),
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
                                    margin: const EdgeInsets.only(
                                        right: 10.0, left: 8),
                                    child: Icon(Icons.people),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    margin: const EdgeInsets.only(
                                        right: 10.0, left: 8),
                                    child: Icon(Icons.location_city),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                    margin: const EdgeInsets.only(
                                        right: 10.0, left: 8),
                                    child: Icon(Icons.directions_run),
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                            color: themeColors['main']!,
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
                    if (1 == widget.subpage) ...[
                      Header('Zdobyte odznaki'),
                      GridView.count(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        children: [
                          for (var badge in widget.player.badges)
                            BadgeView(badge: badge),
                        ],
                      ),
                    ],
                  ],
                  // to here.
                ),
              ),
              bottomNavigationBar: MyBottomNavigationBar,
            ));
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

  XFile? imageFile = null;

  Future<void> _showChoiceDialog(BuildContext context) {
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              "Źródło zdjęcia",
              // style: TextStyle(color: Colors.blue),
            ),
            content: SingleChildScrollView(
              child: ListBody(
                children: [
                  Divider(
                    height: 1,
                    // color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openGallery(context);
                    },
                    title: Text("Galeria"),
                    leading: Icon(
                      Icons.account_box,
                      // color: Colors.blue,
                    ),
                  ),
                  Divider(
                    height: 1,
                    // color: Colors.blue,
                  ),
                  ListTile(
                    onTap: () {
                      _openCamera(context);
                    },
                    title: Text("Aparat"),
                    leading: Icon(
                      Icons.camera,
                      // color: Colors.blue,
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  void _openGallery(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    setState(() {
      imageFile = pickedFile!;
    });

    Navigator.pop(context);
    // Navigator.pop(context);
  }

  void _openCamera(BuildContext context) async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile!;
    });
    Navigator.pop(context);
  }

  Future<String?> _uploadImage(File img, String fname) async {
    final storage = FirebaseStorage.instance;
    final storageRef = storage.ref().child('profile_pics').child(fname);
    // storage.FirebaseStorage.instance.ref(path);
    final fileSize = await img.length();
    if (fileSize <= maxImageSize)
      try {
        await storageRef.putFile(img);
        return 'success';
      } on FirebaseException catch (e) {
        print(e);
      }
    else {
      return 'sizeError';
    }
    return 'error';
  }

  // UploadTask uploadString() {
  //   const String putStringText =
  //       'This upload has been generated using the putString method! Check the metadata too!';
  //
  //   // Create a Reference to the file
  //   Reference ref = FirebaseStorage.instance
  //       .ref()
  //       .child('flutter-tests')
  //       .child('/put-string-example.txt');
  //
  //   // Start upload of putString
  //   return ref.putString(
  //     putStringText,
  //     metadata: SettableMetadata(
  //       contentLanguage: 'en',
  //       customMetadata: <String, String>{'example': 'putString'},
  //     ),
  //   );
  // }
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edycja profilu'),
        leading: IconButton(
          onPressed: () {
            _isLoading ? null : Navigator.pop(context);
          },
          icon: Icon(Icons.close),
        ),
        actions: <Widget>[
          Consumer<ApplicationState>(
            builder: (context, appState, _) => TextButton(
              onPressed: () async {
                if (_isLoading)
                  null;
                else {
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
                }
              },
              style: ButtonStyle(
                foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
              ),
              child: Icon(Icons.check),
            ),
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
                  Header('Podstawowe informacje'),
                  Container(
                    decoration: BoxDecoration(
                      color: themeColors['main']!,
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
                  const SizedBox(height: 8),
                  Center(
                    child: OutlinedButton(
                        onPressed: () async {
                          await _showChoiceDialog(context);
                          setState(() => _isLoading = true);
                          String? uploadState = await _uploadImage(
                              File(imageFile!.path), widget.player.uid);
                          if ('sizeError' == uploadState) {
                            print('too big image');
                            await showImageAlertDialog(context);
                          } else {
                            // widget.player.pic = await widget.player
                            //     .downloadImage(widget.player.uid);
                            widget.player.pic =
                                File(imageFile!.path).readAsBytesSync();
                            widget.player.hasPic = true;
                            FirebaseFirestore.instance
                                .collection('players')
                                .doc(widget.player.uid)
                                .update(<String, dynamic>{
                              'hasPic': true,
                            });
                            Navigator.pop(context);
                          }
                          setState(() => _isLoading = false);
                          // print(widget.player.pic);
                        },
                        child: const Text('Wybierz zdjęcie profilowe')),
                  ),
                  // Card(
                  //   child: (widget.player.pic == null)
                  //       ? Text("Choose Image")
                  //       // : Image.file(File(imageFile!.path)),
                  //       : Image.memory(widget.player.pic!),
                  // ),
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

showImageAlertDialog(BuildContext context) {
  Widget cancelButton = TextButton(
    child: Text("Ok"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Zbyt duży rozmiar zdjęcia"),
    content: Text(
        "Rozmiar zdjęcia nie może przekroczyć ${maxImageSize / 1000000} MB."),
    actions: [
      cancelButton,
      // continueButton,
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
