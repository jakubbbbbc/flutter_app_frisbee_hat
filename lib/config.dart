import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// max allowed in bytes
const maxImageSize = 2 * 1000000;

const mapURL =
    "https://www.google.com/maps/d/embed?mid=15J5ZzKPORhm01BZKuwLrzk5a3nsDep-K&ehbc=2E312F%22%20width=%22640%22%20height=%22480%22";

// for displaying next game
// DateTime compareDate = DateTime.now();
DateTime compareDate =
    DateFormat('dd.MM.yyyy, hh:mm').parse('23.04.2022, 08:55');

enum TabItem { home, plan, players, teams, read }

final themeColors = {
  'main': Colors.green,
  'dark': Colors.green.shade800,
  // 'main': Colors.purple,
  // 'dark': Colors.purple.shade800,
};

final teamColors = {
  'Bazyliszki': Colors.blue,
  'Smaugi': Colors.yellow,
  'Rogogony': Colors.red,
  'Gromogrzmoty': Colors.orange,
};

final colorNames = {
  Colors.blue: 'niebieski',
  Colors.yellow: 'żółty',
  Colors.red: 'czerwony',
  Colors.orange: 'pomarańczowy',
};

final eventColors = {
  'mecz': Colors.blue,
  'impreza': Colors.yellow,
  'turniej': Colors.red,
  'jedzenie': Colors.orange,
};
final eventDays = {
  1: 'piątek',
  2: 'sobota',
  3: 'niedziela',
};

final badgeIcons = {
  'Organizator': Icons.badge,
  'Mistrzowska Akcja': Icons.star,
  'Czyścioch': Icons.clean_hands,
};

final badgeDescription = {
  'Organizator': 'Członek teamu organizatorów',
  'Mistrzowska Akcja': 'Weź udział w najlepszej akcji meczu',
  'Czyścioch': 'Użyj płynu do dezynfekcji',
};
