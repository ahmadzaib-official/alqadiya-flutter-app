import 'dart:io';

void main() {
  var file = File('lib/features/game/screen/game_result_summary_screen.dart');
  var content = file.readAsStringSync();

  // Add path_provider import if not present
  if (!content.contains('package:path_provider/path_provider.dart')) {
    content = "import 'package:path_provider/path_provider.dart';\nimport 'dart:io' as io;\n" + content;
  }

  final oldShare = '''
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        final XFile file = XFile.fromData(
          pngBytes,
          mimeType: 'image/png',
          name: 'game_result.png',
        );

        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [file],
          text: 'Check out my game result on Alqadiya!'.tr,
          sharePositionOrigin: sharePositionOrigin,
        );
      }
''';

  final newShare = '''
      if (byteData != null) {
        Uint8List pngBytes = byteData.buffer.asUint8List();

        // Write to temp directory for iOS compatibility
        final directory = await getTemporaryDirectory();
        final imagePath = '\${directory.path}/game_result_\${DateTime.now().millisecondsSinceEpoch}.png';
        final imageFile = io.File(imagePath);
        await imageFile.writeAsBytes(pngBytes);

        final XFile file = XFile(imagePath);

        // ignore: deprecated_member_use
        await Share.shareXFiles(
          [file],
          text: 'Check out my game result on Alqadiya!'.tr,
          sharePositionOrigin: sharePositionOrigin,
        );
      }
''';

  if (content.contains(oldShare)) {
    content = content.replaceFirst(oldShare, newShare);
    file.writeAsStringSync(content);
    print("Patched _shareResult for iOS");
  } else {
    print("Failed to find _shareResult");
  }
}
