import 'dart:io';

void main() {
  var file = File('lib/features/game/controller/evidence_controller.dart');
  var content = file.readAsStringSync();

  if (!content.contains('var unlockedEvidenceIds = <String>[].obs;')) {
    content = content.replaceFirst('var isMoreLoading = false.obs;', 'var isMoreLoading = false.obs;\n  var unlockedEvidenceIds = <String>[].obs;');
  }

  final oldGet = '''
      final response = await _repository.getEvidencesByGame(
        gameId: gameId,
        sessionId: sessionId,
        page: currentPage,
        limit: limit,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final List<dynamic> list = response.data['data'] ?? [];
        final tempEvidences =
            list.map((e) => EvidenceModel.fromJson(e)).toList();

        if (isLoadMore) {
          evidences.addAll(tempEvidences);
        } else {
          evidences.assignAll(tempEvidences);
        }
''';

  final newGet = '''
      // Jugaar: We fetch ALL evidences (sessionId: null) for the UI list.
      // And we fetch UNLOCKED evidences (sessionId: sessionId) to know which ones are unlocked.
      
      // 1. Fetch ALL evidences for the current page
      final responseAll = await _repository.getEvidencesByGame(
        gameId: gameId,
        sessionId: null, // Force null to get ALL
        page: currentPage,
        limit: limit,
      );

      // 2. Fetch UNLOCKED evidences (we get a large limit to make sure we have all their IDs)
      if (!isLoadMore) {
        try {
          final responseUnlocked = await _repository.getEvidencesByGame(
            gameId: gameId,
            sessionId: sessionId,
            page: 1,
            limit: 1000, 
          );
          if (responseUnlocked.statusCode == 200 || responseUnlocked.statusCode == 201) {
            final List<dynamic> unlockedList = responseUnlocked.data['data'] ?? [];
            unlockedEvidenceIds.assignAll(unlockedList.map((e) => e['id'].toString()).toList());
          }
        } catch (e) {
          print("Failed to fetch unlocked evidences for jugaar: \$e");
        }
      }

      if (responseAll.statusCode == 200 || responseAll.statusCode == 201) {
        final List<dynamic> list = responseAll.data['data'] ?? [];
        final tempEvidences =
            list.map((e) => EvidenceModel.fromJson(e)).toList();

        if (isLoadMore) {
          evidences.addAll(tempEvidences);
        } else {
          evidences.assignAll(tempEvidences);
        }
''';

  if (!content.contains('Jugaar')) {
    content = content.replaceFirst(oldGet, newGet);
    file.writeAsStringSync(content);
    print('Patched EvidenceController successfully.');
  } else {
    print('Already patched.');
  }
}
