import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/model/team_model.dart';
import 'package:alqadiya_game/features/game/model/scoreboard_model.dart';
import 'package:alqadiya_game/features/game/repository/game_repository.dart';
import 'package:get/get.dart';

class TeamLeader {
  final String id;
  final String name;
  final String imageUrl;

  TeamLeader({required this.id, required this.name, required this.imageUrl});
}

class ChooseTeamLeaderController extends GetxController {
  // Observable for selected leader
  final Rx<TeamLeader?> selectedLeader = Rx<TeamLeader?>(null);

  // Observable for team leaders list
  final RxList<TeamLeader> teamLeaders = <TeamLeader>[].obs;

  // Observable for team members (all team members for display)
  final RxList<TeamLeader> teamMembers = <TeamLeader>[].obs;

  // Observable for loading state
  final RxBool isLoading = false.obs;
  
  // Team Name
  final RxString teamName = ''.obs;
  String teamId = '';
  
  final _repository = GameRepository();

  @override
  void onInit() {
    super.onInit();
    
    if (Get.arguments != null) {
      if (Get.arguments['teamId'] != null) {
        teamId = Get.arguments['teamId'];
      }
      if (Get.arguments['teamName'] != null) {
        teamName.value = Get.arguments['teamName'];
      }
      if (Get.arguments['members'] != null && Get.arguments['members'] is List) {
        List<TeamLeader> leaders = [];
        for (var m in Get.arguments['members']) {
          leaders.add(TeamLeader(
            id: m['id'] ?? '',
            name: m['name'] ?? 'Unknown',
            imageUrl: m['imageUrl'] ?? "https://picsum.photos/200",
          ));
        }
        teamLeaders.assignAll(leaders);
      }
    }
    
    // Fetch team members from API
    fetchTeamMembers();
  }

  /// Fetch team members from API
  Future<void> fetchTeamMembers() async {
    if (teamId.isEmpty) {
      if (teamLeaders.isEmpty) {
        _initializeTeamLeaders();
      }
      return;
    }

    isLoading.value = true;
    try {
      final gameController = Get.find<GameController>();
      final sessionId = gameController.gameSession.value?.id;
      
      if (sessionId == null) {
        if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
        return;
      }

      // Get game session details to get teams and players with assignments
      await gameController.getGameSessionDetails(sessionId: sessionId);
      
      // Find the team
      TeamModel? team = gameController.teams.firstWhereOrNull(
        (t) => t.id == teamId,
      );
      
      if (team != null) {
        // Update team name if not set
        if (teamName.value.isEmpty) {
          teamName.value = team.teamName ?? 'Team';
        }
        
        // Try to get team members from scoreboard API (includes team-player assignments)
        List<TeamLeader> members = await _getTeamMembersFromScoreboard(sessionId);
        
        // If scoreboard doesn't have data, try to get from session details
        if (members.isEmpty) {
          members = await _getTeamMembersFromSessionDetails(gameController, sessionId);
        }
        
        // Update team members list (for display)
        teamMembers.assignAll(members);
        
        // Update team leaders list (for selection)
        if (members.isNotEmpty) {
          teamLeaders.assignAll(members);
        } else if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
      } else {
        if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
      }
    } catch (e) {
      CustomSnackbar.showError("${'Failed to fetch team members:'.tr} ${e.toString()}");
      if (teamLeaders.isEmpty) {
        _initializeTeamLeaders();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Get team members from scoreboard API
  Future<List<TeamLeader>> _getTeamMembersFromScoreboard(String sessionId) async {
    try {
      final response = await _repository.getScoreboard(sessionId: sessionId);
      
      if (response.statusCode == 200 || response.statusCode == 201) {
        final scoreboard = ScoreboardModel.fromJson(response.data);
        
        if (scoreboard.teams != null) {
          // Find the team in scoreboard
          final teamScore = scoreboard.teams!.firstWhereOrNull(
            (t) => t.teamId == teamId,
          );
          
          if (teamScore != null && teamScore.players != null) {
            return teamScore.players!.map((player) {
              return TeamLeader(
                id: player.userId ?? '',
                name: player.userName ?? 'Unknown',
                imageUrl: "https://picsum.photos/200",
              );
            }).toList();
          }
        }
      }
    } catch (e) {
      // Scoreboard might not be available yet, that's okay
    }
    return [];
  }

  /// Get team members from session details (fallback)
  Future<List<TeamLeader>> _getTeamMembersFromSessionDetails(
    GameController gameController,
    String sessionId,
  ) async {
    // Since the API response doesn't directly map players to teams,
    // we'll use all session players as a fallback
    // In a production environment, the API should include team assignments
    return gameController.sessionPlayers.map((member) {
      return TeamLeader(
        id: member.userId ?? member.id ?? '',
        name: member.userName ?? 'Unknown',
        imageUrl: "https://picsum.photos/200",
      );
    }).toList();
  }

  /// Initialize team leaders with sample data (Fallback)
  void _initializeTeamLeaders() {
    teamLeaders.assignAll([
      TeamLeader(
        id: '1',
        name: 'Me',
        imageUrl: 'https://picsum.photos/200?random=1',
      ),
      TeamLeader(
        id: '2',
        name: 'Fahd',
        imageUrl: 'https://picsum.photos/200?random=2',
      ),
    ]);
  }

  /// Select a team leader
  void selectLeader(TeamLeader leader) {
    selectedLeader.value = leader;
  }

  /// Check if a leader is selected
  bool isLeaderSelected(String leaderId) {
    return selectedLeader.value?.id == leaderId;
  }

  /// Get selected leader name
  String? getSelectedLeaderName() {
    return selectedLeader.value?.name;
  }

  /// Proceed to next screen with selected leader
  Future<void> proceedWithSelectedLeader() async {
    if (selectedLeader.value == null) {
      CustomSnackbar.showError('Please select a team leader'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final gameController = Get.find<GameController>();
      
      await gameController.assignTeamLeader(
        teamId: teamId,
        userId: selectedLeader.value!.id,
      );

    } catch (e) {
      CustomSnackbar.showError("${'Failed to select leader:'.tr} ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset selection
  void resetSelection() {
    selectedLeader.value = null;
  }

  /// Refresh team members
  Future<void> refreshTeamMembers() async {
    await fetchTeamMembers();
  }
}
