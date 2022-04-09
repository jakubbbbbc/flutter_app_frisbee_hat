import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        // crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            // crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              ConstrainedBox(
                constraints:
                const BoxConstraints.tightFor(width: 100, height: 100),
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/ReadScreen');
                  },
                  style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10))),
                  child: const Text('Twój profil'),
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ReadScreen');
                },
                child: const Text('Twoja drużyna'),
              ),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ReadScreen');
                },
                child: const Text('Następny mecz'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/ReadScreen');
                },
                child: const Text('Odznaki'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}