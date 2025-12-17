import 'package:get/get.dart';

/// Controller for managing game result summary screen state
class GameResultController extends GetxController {
  // Team result data
  final List<Map<String, dynamic>> teamResults = [
    {
      'name': 'Team Da7i7',
      'players': [
        {'name': 'Me', 'avatar': 'https://picsum.photos/100?random=1'},
        {'name': 'Fahd', 'avatar': 'https://picsum.photos/100?random=2'},
        {'name': 'Med', 'avatar': 'https://picsum.photos/100?random=3'},
      ],
      'suspectName': 'Farida',
      'suspectImage': 'https://picsum.photos/200?random=10',
      'isCorrect': true,
      'totalScore': 22,
      'timeTaken': '01:22:38',
      'accuracy': 89,
      'hintsUsed': 4,
    },
    {
      'name': 'Moktashif team',
      'players': [
        {'name': 'Issam', 'avatar': 'https://picsum.photos/100?random=4'},
        {'name': 'Khaled', 'avatar': 'https://picsum.photos/100?random=5'},
        {'name': 'Aymen', 'avatar': 'https://picsum.photos/100?random=6'},
      ],
      'suspectName': 'Azmi',
      'suspectImage': 'https://picsum.photos/200?random=11',
      'isCorrect': false,
      'totalScore': 21,
      'timeTaken': '01:33:38',
      'accuracy': 68,
      'hintsUsed': 4,
    },
  ];

  String get winnerTeam => teamResults[0]['name'] as String; // Team Da7i7 wins
}
