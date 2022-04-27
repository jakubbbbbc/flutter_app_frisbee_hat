

import 'package:flutter/material.dart';

const maxImageSize = 2000000;

enum TabItem { home, plan, players, teams, read}

final themeColors={
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