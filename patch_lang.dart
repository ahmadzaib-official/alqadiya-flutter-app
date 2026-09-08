import 'dart:io';

void main() {
  var fileAr = File('lib/core/lang/app_ar.dart');
  var contentAr = fileAr.readAsStringSync();
  if (!contentAr.contains("'Congratulations!':")) {
    contentAr = contentAr.replaceFirst('const Map<String, String> lnAr = {', "const Map<String, String> lnAr = {\n  'Congratulations!': 'مبروك !',\n  'OK': 'حسنا',");
    fileAr.writeAsStringSync(contentAr);
  }

  var fileEn = File('lib/core/lang/app_en.dart');
  var contentEn = fileEn.readAsStringSync();
  if (!contentEn.contains("'Congratulations!':")) {
    contentEn = contentEn.replaceFirst('const Map<String, String> lnEn = {', "const Map<String, String> lnEn = {\n  'Congratulations!': 'Congratulations!',\n  'OK': 'OK',");
    fileEn.writeAsStringSync(contentEn);
  }
  print('Lang files patched');
}
