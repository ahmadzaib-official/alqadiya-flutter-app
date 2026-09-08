import 'dart:io';

void main() {
  var file = File('lib/features/game/widget/evidence_unlocked_dialog.dart');
  var content = file.readAsStringSync();

  // Add showIcon to constructor
  content = content.replaceFirst('final String subtitle;', 'final String subtitle;\n  final bool showIcon;');
  content = content.replaceFirst('required this.subtitle,', 'required this.subtitle,\n    this.showIcon = true,');

  // Modify build method top padding depending on showIcon
  final oldPadding = '''
            padding: EdgeInsets.only(
              top: 55.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
''';
  final newPadding = '''
            padding: EdgeInsets.only(
              top: widget.showIcon ? 55.h : 20.h,
              bottom: 20.h,
              left: 20.w,
              right: 20.w,
            ),
''';
  content = content.replaceFirst(oldPadding, newPadding);

  // Wrap Positioned with if (widget.showIcon)
  final oldPositioned = '''
          // Floating Icon
          Positioned(
''';
  final newPositioned = '''
          // Floating Icon
          if (widget.showIcon)
            Positioned(
''';
  content = content.replaceFirst(oldPositioned, newPositioned);

  file.writeAsStringSync(content);
  print('Dialog patched for showIcon.');
}
