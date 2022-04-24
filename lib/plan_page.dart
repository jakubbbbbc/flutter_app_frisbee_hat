import 'package:flutter/material.dart';
import 'package:gtk_flutter/config.dart';

class GeneralEvent {
  final String category;
  final String name;
  final String place;
  final String day;
  final String time;
  final String duration;
  final DateTime timestamp;

  GeneralEvent(
      {required this.category,
      required this.name,
      required this.place,
      required this.day,
      required this.time,
      required this.duration,
      required this.timestamp});
}

class GameEvent extends GeneralEvent {
  final String team1;
  final String team2;
  int score1 = 0;
  int score2 = 0;

  GameEvent(
      {required String category,
      required String name,
      required String place,
      required String day,
      required String time,
      required String duration,
      required DateTime timestamp,
      required this.team1,
      required this.team2})
      : super(
            category: category,
            name: name,
            place: place,
            day: day,
            time: time,
            duration: duration,
            timestamp: timestamp);
}

class PlanPage extends StatefulWidget {
  const PlanPage({Key? key, required this.eventList}) : super(key: key);

  final List<GeneralEvent> eventList;

  @override
  State<PlanPage> createState() => _PlanPageState();
}

class _PlanPageState extends State<PlanPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plan turnieju'),
      ),
      body: ListView(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              for (var event in widget.eventList) ...[
                Container(
                  decoration: BoxDecoration(
                    color: eventColors[event.category],
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                  ),
                  margin: const EdgeInsets.symmetric(horizontal: 10.0),
                  padding: EdgeInsets.all(5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                          // crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(event.category.toUpperCase()),
                            Spacer(),
                            Text(event.place),
                          ]),
                      SizedBox(height: 5),
                      Align(
                          alignment: Alignment.centerRight,
                          child: Text(event.duration)),
                      SizedBox(height: 5),
                      Text(event.name, textScaleFactor: 1.5),
                      Text("${event.day}  ${event.time}"),
                    ],
                  ),
                ),
                SizedBox(height: 10),
              ]
            ],
          ),
          // To here.
        ],
      ),
    );
  }
}
