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

    // Reset selection when initializing for a new team
    resetSelection();

    if (Get.arguments != null) {
      if (Get.arguments['teamId'] != null) {
        teamId = Get.arguments['teamId'];
      }
      if (Get.arguments['teamName'] != null) {
        teamName.value = Get.arguments['teamName'];
      }
      if (Get.arguments['members'] != null &&
          Get.arguments['members'] is List) {
        List<TeamLeader> leaders = [];
        for (var m in Get.arguments['members']) {
          // Use fallback image if userPhotoURL is empty or null
          String imageUrl = m['userPhotoURL'] ?? "";
          if (imageUrl.isEmpty) {
            imageUrl =
                "https://picsum.photos/200?random=${m['id']?.hashCode ?? 1}";
          }

          leaders.add(
            TeamLeader(
              id: m['id'] ?? '',
              name: m['name'] ?? 'Unknown',
              imageUrl: imageUrl,
            ),
          );
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
    final gameController = Get.find<GameController>();

    try {
      final sessionId = gameController.gameSession.value?.id;

      if (sessionId == null) {
        if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
        return;
      }

      // Get game session details to get teams and players with assignments
      await gameController.getGameSessionDetails(
        sessionId: sessionId,
        silent: true,
      );

      // Also fetch session players to ensure we have the latest player data
      await gameController.getSessionPlayers(silent: true);

      // Debug: Log current team and session data
      print('=== TEAM LEADER SELECTION DEBUG ===');
      print('Current teamId: $teamId');
      print('Session players count: ${gameController.sessionPlayers.length}');
      print('Teams count: ${gameController.teams.length}');

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
        List<TeamLeader> members = await _getTeamMembersFromScoreboard(
          sessionId,
        );

        print('Members from scoreboard: ${members.length}');
        for (var member in members) {
          print('Scoreboard member: ${member.name}, Image: ${member.imageUrl}');
        }

        // If scoreboard doesn't have data, use all session players as fallback
        // This happens when teams are just assigned and scoreboard isn't ready yet
        if (members.isEmpty && gameController.sessionPlayers.isNotEmpty) {
          print('Using session players as fallback');
          // Use all session players as team members (they should all be in the team after assignment)
          members =
              gameController.sessionPlayers.map((member) {
                // Use fallback image if userPhotoURL is empty or null
                String imageUrl = member.userPhotoURL ?? "";
                if (imageUrl.isEmpty) {
                  imageUrl =
                      "https://picsum.photos/200?random=${member.userId?.hashCode ?? member.id?.hashCode ?? 1}";
                }

                return TeamLeader(
                  id: member.userId ?? member.id ?? '',
                  name: member.userName ?? 'Unknown',
                  imageUrl: imageUrl,
                );
              }).toList();
        }

        // Update team members list (for display)
        teamMembers.assignAll(members);

        // Update team leaders list (for selection)
        if (members.isNotEmpty) {
          teamLeaders.assignAll(members);
        } else if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }

        print('Final team leaders count: ${teamLeaders.length}');
        print('=== END DEBUG ===');
      } else {
        // Team not found, use all session players as fallback
        if (gameController.sessionPlayers.isNotEmpty) {
          final members =
              gameController.sessionPlayers.map((member) {
                // Use fallback image if userPhotoURL is empty or null
                String imageUrl = member.userPhotoURL ?? "";
                if (imageUrl.isEmpty) {
                  imageUrl =
                      "https://picsum.photos/200?random=${member.userId?.hashCode ?? member.id?.hashCode ?? 1}";
                }

                return TeamLeader(
                  id: member.userId ?? member.id ?? '',
                  name: member.userName ?? 'Unknown',
                  imageUrl: imageUrl,
                );
              }).toList();
          teamMembers.assignAll(members);
          teamLeaders.assignAll(members);
        } else if (teamLeaders.isEmpty) {
          _initializeTeamLeaders();
        }
      }
    } catch (e) {
      // Only show error if we don't have any players at all
      // If we have session players, use them as fallback instead of showing error
      if (gameController.sessionPlayers.isEmpty) {
        CustomSnackbar.showError(
          "${'Failed to fetch team members:'.tr} ${e.toString()}",
        );
      } else {
        // Use session players as fallback
        final members =
            gameController.sessionPlayers.map((member) {
              // Use fallback image if userPhotoURL is empty or null
              String imageUrl = member.userPhotoURL ?? "";
              if (imageUrl.isEmpty) {
                imageUrl =
                    "https://picsum.photos/200?random=${member.userId?.hashCode ?? member.id?.hashCode ?? 1}";
              }

              return TeamLeader(
                id: member.userId ?? member.id ?? '',
                name: member.userName ?? 'Unknown',
                imageUrl: imageUrl,
              );
            }).toList();
        teamMembers.assignAll(members);
        teamLeaders.assignAll(members);
      }

      if (teamLeaders.isEmpty) {
        _initializeTeamLeaders();
      }
    } finally {
      isLoading.value = false;
    }
  }

  /// Get team members from scoreboard API
  Future<List<TeamLeader>> _getTeamMembersFromScoreboard(
    String sessionId,
  ) async {
    try {
      print('Fetching scoreboard for session: $sessionId, team: $teamId');
      final response = await _repository.getScoreboard(sessionId: sessionId);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final scoreboard = ScoreboardModel.fromJson(response.data);

        print('Scoreboard has ${scoreboard.teams.length} teams');
        // Find the team in scoreboard
        final teamScore = scoreboard.teams.firstWhereOrNull(
          (t) => t.teamId == teamId,
        );

        if (teamScore != null) {
          print(
            'Found team in scoreboard with ${teamScore.players.length} players',
          );
          final gameController = Get.find<GameController>();
          return teamScore.players.map((player) {
            // Find member in session players to get image URL
            final member = gameController.sessionPlayers.firstWhereOrNull(
              (m) => m.userId == player.userId || m.id == player.userId,
            );

            // Use fallback image if userPhotoURL is empty or null
            String imageUrl = member?.userPhotoURL ?? "";
            if (imageUrl.isEmpty) {
              imageUrl =
                  "https://picsum.photos/200?random=${player.userId?.hashCode ?? 1}";
            }

            print('Player: ${player.userName}, Image: $imageUrl');
            return TeamLeader(
              id: player.userId ?? '',
              name: player.userName ?? 'Unknown',
              imageUrl: imageUrl,
            );
          }).toList();
        } else {
          print('Team not found in scoreboard or no players');
        }
            } else {
        print('Scoreboard API returned status: ${response.statusCode}');
      }
    } catch (e) {
      // Scoreboard might not be available yet, that's okay
      print('Error fetching scoreboard: $e');
    }
    return [];
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
      CustomSnackbar.showError(
        "${'Failed to select leader:'.tr} ${e.toString()}",
      );
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

  /// Update team information for next team selection
  /// This is called when moving to the next team without navigating away
  Future<void> updateTeamForNextSelection({
    required String newTeamId,
    required String newTeamName,
  }) async {
    // Reset selection for the new team
    resetSelection();

    // Update team information
    teamId = newTeamId;
    teamName.value = newTeamName;

    // Clear current team leaders and members
    teamLeaders.clear();
    teamMembers.clear();

    // Set loading state while fetching
    isLoading.value = true;

    // Ensure we have the latest session data before fetching team members
    final gameController = Get.find<GameController>();
    final sessionId = gameController.gameSession.value?.id;

    if (sessionId != null) {
      // Refresh session details to get the latest team and player data
      await gameController.getGameSessionDetails(
        sessionId: sessionId,
        silent: true,
      );

      // Also refresh session players to ensure we have the latest player data
      await gameController.getSessionPlayers(silent: true);
    }

    // Fetch members for the new team
    await fetchTeamMembers();

    // Loading state will be set to false in fetchTeamMembers
  }
}
