import 'package:flutter/material.dart';

class PlayersPage extends StatefulWidget {
  const PlayersPage({Key? key}) : super(key: key);

  @override
  State<PlayersPage> createState() => _PlayersPageState();
}

class _PlayersPageState extends State<PlayersPage> {
  final List<Player> _players = [
    const Player(name: 'Jakub Ciemięga'),
    const Player(name: 'Adam Biegała'),
    const Player(name: 'Imię Nazwisko'),
    const Player(name: 'Andrzej Testowy'),
    const Player(name: 'Marek Kalicki'),
    ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Zawodnicy'),
      ),
      body: Column(
        children: [
          Flexible(child: ListView.builder(
            padding: const EdgeInsets.all(8.0),
            reverse: false,
            itemBuilder: (_, index) => _players[index],
            itemCount: _players.length,
          ))
        ],
      ),
    );
  }
}

class Player extends StatelessWidget {
  const Player({
    required this.name,
    Key? key,
  }) : super(key: key);

  final String name;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(child: Text(name[0])),
          ),
          Expanded(
            child: Text(name, style: Theme.of(context).textTheme.headline4),
          ),
        ],
      ),
    );
  }
}
