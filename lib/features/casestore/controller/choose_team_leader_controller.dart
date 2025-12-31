import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/game/model/team_model.dart';
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

  // Observable for loading state
    final RxBool isLoading = false.obs;
  // Team Name
  final RxString teamName = ''.obs;
  String teamId = '';

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
        
        // Get team members - we need to check which players are assigned to this team
        // Since the API response structure may vary, we'll use all session players
        // In production, you'd filter by team assignments from the API response
        List<TeamLeader> leaders = gameController.sessionPlayers
            .map(
              (member) => TeamLeader(
                id: member.userId ?? member.id ?? '',
                name: member.userName ?? 'Unknown',
                imageUrl: "https://picsum.photos/200",
              ),
            )
            .toList();
        
        if (leaders.isNotEmpty) {
          teamLeaders.assignAll(leaders);
        } else if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
      } else {
        if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
      }
    } catch (e) {
      CustomSnackbar.showError("Failed to fetch team members: ${e.toString()}");
      if (teamLeaders.isEmpty) {
        _initializeTeamLeaders();
      }
    } finally {
      isLoading.value = false;
    }
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
      CustomSnackbar.showError('Please select a team leader');
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
      CustomSnackbar.showError("Failed to select leader: ${e.toString()}");
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset selection
  void resetSelection() {
    selectedLeader.value = null;
  }
}
