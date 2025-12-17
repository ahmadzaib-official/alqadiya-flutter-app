import 'package:get/get.dart';

/// Controller for managing scoreboard screen state
class ScoreboardController extends GetxController {
  // Team data
  final List<Map<String, dynamic>> teams = [
    {
      'name': 'Team Da7i7',
      'score': 14,
      'players': [
        {'name': 'Me', 'avatar': 'https://picsum.photos/100?random=1'},
        {'name': 'Fahd', 'avatar': 'https://picsum.photos/100?random=2'},
        {'name': 'Med', 'avatar': 'https://picsum.photos/100?random=3'},
      ],
      'progressStart': 24,
      'progressEnd': 19,
    },
    {
      'name': 'Team Moktashif',
      'score': 16,
      'players': [
        {'name': 'Issam', 'avatar': 'https://picsum.photos/100?random=4'},
        {'name': 'Khaled', 'avatar': 'https://picsum.photos/100?random=5'},
        {'name': 'Aymen', 'avatar': 'https://picsum.photos/100?random=6'},
      ],
      'progressStart': 24,
      'progressEnd': 21,
    },
  ];
}
