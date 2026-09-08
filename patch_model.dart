import 'dart:io';

void main() {
  var file = File('lib/features/game/model/user_answer_model.dart');
  var content = file.readAsStringSync();

  final oldConstructor = '''
    this.unlockMessageEn,
    this.unlockMessageAr,
  });
''';
  final newConstructor = '''
    this.unlockMessageEn,
    this.unlockMessageAr,
    this.unlockedEvidenceCount,
    this.unlockedEvidenceIds,
  });
''';
  content = content.replaceAll(oldConstructor, newConstructor);

  final oldDeclarations = '''
  final String? unlockMessageEn;
  final String? unlockMessageAr;
''';
  final newDeclarations = '''
  final String? unlockMessageEn;
  final String? unlockMessageAr;
  final int? unlockedEvidenceCount;
  final List<String>? unlockedEvidenceIds;
''';
  content = content.replaceAll(oldDeclarations, newDeclarations);

  final oldFromJson = '''
      unlockMessageEn: json["unlockMessageEn"],
      unlockMessageAr: json["unlockMessageAr"],
    );
  }
''';
  final newFromJson = '''
      unlockMessageEn: json["unlockMessageEn"],
      unlockMessageAr: json["unlockMessageAr"],
      unlockedEvidenceCount: json["unlockedEvidenceCount"],
      unlockedEvidenceIds: json["unlockedEvidenceIds"] != null ? List<String>.from(json["unlockedEvidenceIds"]) : null,
    );
  }
''';
  content = content.replaceAll(oldFromJson, newFromJson);

  final oldToJson = '''
    "unlockMessageEn": unlockMessageEn,
    "unlockMessageAr": unlockMessageAr,
  };
''';
  final newToJson = '''
    "unlockMessageEn": unlockMessageEn,
    "unlockMessageAr": unlockMessageAr,
    "unlockedEvidenceCount": unlockedEvidenceCount,
    "unlockedEvidenceIds": unlockedEvidenceIds,
  };
''';
  content = content.replaceAll(oldToJson, newToJson);

  file.writeAsStringSync(content);
  print('UserAnswerModel patched.');
}
