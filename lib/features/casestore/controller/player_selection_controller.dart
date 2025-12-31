import 'dart:math';
import 'package:alqadiya_game/core/utils/snackbar.dart';
import 'package:alqadiya_game/features/game/controller/game_controller.dart';
import 'package:alqadiya_game/features/casestore/model/member_model.dart';
import 'package:alqadiya_game/features/game/model/team_model.dart';
import 'package:get/get.dart';

class Player {
  final String id;
  final String name;
  final String imageUrl;

  Player({required this.id, required this.name, required this.imageUrl});

  Player copyWith({String? id, String? name, String? imageUrl}) {
    return Player(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}

class Team {
  final String id;
  final String name;
  final RxList<Player> players;

  Team({required this.id, required this.name, List<Player>? players})
    : players = RxList(players ?? []);

  void addPlayer(Player player) {
    if (!players.any((p) => p.id == player.id)) {
      players.add(player);
    }
  }

  void removePlayer(String playerId) {
    players.removeWhere((p) => p.id == playerId);
  }

  bool hasPlayer(String playerId) {
    return players.any((p) => p.id == playerId);
  }

  int get playerCount => players.length;
}

class PlayerSelectionController extends GetxController {
  // Observable lists
  final RxList<Player> availablePlayers = <Player>[].obs;
  final RxList<Team> teams = <Team>[].obs;
  final RxBool isLoading = false.obs;

  // Track dragged player
  final Rx<Player?> draggedPlayer = Rx<Player?>(null);

  @override
  void onInit() {
    super.onInit();
    if (Get.arguments != null) {
      if (Get.arguments['teams'] != null) {
        // Parse teams from arguments
        var teamsData = Get.arguments['teams'];
        if (teamsData is List) {
          List<Team> parsedTeams = [];
          for (var t in teamsData) {
            // Assuming t has id and name
            parsedTeams.add(
              Team(id: t['_id'] ?? t['id'] ?? '', name: t['name'] ?? 'Team'),
            );
          }
          teams.assignAll(parsedTeams);
        }
      }
    }

    // If no teams passed (e.g. testing), init default (or keep empty)
    if (teams.isEmpty) {
      _initializeTeams();
    }

    // Fetch available players from API
    fetchAvailablePlayers();
  }

  /// Initialize available players
  void fetchAvailablePlayers() {
    final gameController = Get.find<GameController>();

    // Sync Teams
    _syncTeams(gameController.teams);
    ever(gameController.teams, _syncTeams);

    // Initial sync players
    _syncPlayers(gameController.sessionPlayers);

    // Listen for updates
    ever(gameController.sessionPlayers, _syncPlayers);
  }

  void _syncTeams(List<TeamModel> apiTeams) {
    if (apiTeams.isEmpty) {
      // If no teams from API and we don't have any teams, initialize default
      if (teams.isEmpty) {
        _initializeTeams();
      }
      return;
    }

    // Map API teams to local Team objects
    // Preserve existing players in teams if team IDs match
    List<Team> newTeams = [];
    for (var apiTeam in apiTeams) {
      // Check if we already have this team with players
      Team? existingTeam = teams.firstWhereOrNull(
        (t) => t.id == (apiTeam.id ?? ''),
      );

      if (existingTeam != null) {
        // Keep existing team with its players, just update the name if needed
        newTeams.add(existingTeam);
      } else {
        // Create new team
        newTeams.add(
          Team(
            id: apiTeam.id ?? '',
            name: apiTeam.teamName ?? 'Team ${apiTeam.teamNumber}',
            players: [],
          ),
        );
      }
    }

    teams.assignAll(newTeams);
  }

  void _syncPlayers(List<MemberModel> members) {
    if (members.isEmpty) return;

    List<Player> players =
        members
            .map(
              (m) => Player(
                id: m.userId ?? m.id ?? '',
                name: m.userName ?? 'Unknown',
                imageUrl: "https://picsum.photos/200",
              ),
            )
            .toList();

    // Only add players not already in teams
    List<Player> filteredPlayers = [];
    for (var p in players) {
      bool alreadyAssigned = false;
      for (var t in teams) {
        if (t.hasPlayer(p.id)) {
          alreadyAssigned = true;
          break;
        }
      }
      if (!alreadyAssigned) {
        filteredPlayers.add(p);
      }
    }

    availablePlayers.assignAll(filteredPlayers);
  }

  /// Initialize teams (Mock)
  void _initializeTeams() {
    // Keep mock for fallback
    teams.assignAll([
      Team(id: '1', name: 'Team Da7i7', players: []),
      Team(id: '2', name: 'Team Moktashif', players: []),
    ]);
  }

  /// Add player to team
  void addPlayerToTeam(Player player, Team team) {
    // Remove from available players
    availablePlayers.removeWhere((p) => p.id == player.id);
    // Add to team
    team.addPlayer(player);
    availablePlayers.refresh();
    teams.refresh();
  }

  /// Remove player from team and add back to available
  void removePlayerFromTeam(Player player, Team team) {
    team.removePlayer(player.id);
    availablePlayers.add(player);
    availablePlayers.refresh();
    teams.refresh();
  }

  /// Get player by id
  Player? getPlayerById(String playerId) {
    try {
      return availablePlayers.firstWhere((p) => p.id == playerId);
    } catch (e) {
      // Check in teams
      for (var team in teams) {
        try {
          return team.players.firstWhere((p) => p.id == playerId);
        } catch (e) {
          continue;
        }
      }
      return null;
    }
  }

  /// Get team by id
  Team? getTeamById(String teamId) {
    try {
      return teams.firstWhere((t) => t.id == teamId);
    } catch (e) {
      return null;
    }
  }

  /// Shuffle players automatically across teams
  Future<void> shufflePlayers() async {
    isLoading.value = true;
    try {
      // Collect all players
      List<Player> allPlayers = [];
      for (var team in teams) {
        allPlayers.addAll(team.players);
      }
      allPlayers.addAll(availablePlayers);

      // Clear teams
      for (var team in teams) {
        team.players.clear();
      }
      availablePlayers.clear();

      // Shuffle the list
      allPlayers.shuffle(Random());

      // Distribute players evenly across teams
      int playerIndex = 0;
      while (playerIndex < allPlayers.length) {
        for (var team in teams) {
          if (playerIndex < allPlayers.length) {
            team.addPlayer(allPlayers[playerIndex]);
            playerIndex++;
          }
        }
      }

      teams.refresh();
      availablePlayers.refresh();
    } finally {
      isLoading.value = false;
    }
  }

  /// Validate team distribution
  bool validateTeamDistribution() {
    if (teams.isEmpty) {
      Get.snackbar(
        'Error',
        'No teams available',
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }

    // Allow empty teams? User said "if they are arranged send their team".
    // I assume at least one player per team
    for (var team in teams) {
      if (team.playerCount == 0) {
        Get.snackbar(
          'Error',
          '${team.name} has no players',
          snackPosition: SnackPosition.BOTTOM,
        );
        return false;
      }
    }

    return true;
  }

  /// Get total players count
  int getTotalPlayersCount() {
    int total = availablePlayers.length;
    for (var team in teams) {
      total += team.playerCount;
    }
    return total;
  }

  /// Proceed with team distribution
  Future<void> proceedWithTeams() async {
    if (!validateTeamDistribution()) {
      return;
    }

    // Check if any players are left unassigned (optional validation)
    if (availablePlayers.isNotEmpty) {
      CustomSnackbar.showInfo('Some players are not assigned to any team'.tr);
      return;
    }

    isLoading.value = true;
    try {
      final gameController = Get.find<GameController>();

      // Construct payload
      List<Map<String, dynamic>> assignments = [];
      for (var team in teams) {
        assignments.add({
          "teamId": team.id,
          "userIds": team.players.map((p) => p.id).toList(),
        });
      }

      await gameController.assignMembers(assignments: assignments);
    } catch (e) {
      print("Error in proceedWithTeams: $e");
    } finally {
      isLoading.value = false;
    }
  }

  /// Reset all teams and players
  void resetTeams() {
    availablePlayers.clear();
    teams.clear();
    draggedPlayer.value = null;
    fetchAvailablePlayers();
    // _initializeTeams();
  }
}
