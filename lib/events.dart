class GeneralEvent {
  final String category;
  final String name;
  final String place;
  final String day;
  final String time;
  final String duration;

  GeneralEvent(
      this.category, this.name, this.place, this.day, this.time, this.duration);
}

class GameEvent extends GeneralEvent {
  final String team1;
  final String team2;
  int score1 = 0;
  int score2 = 0;

  GameEvent(String category, String name, String place, String day, String time,
      String duration, this.team1, this.team2)
      : super(category, name, place, day, time, duration);
}
