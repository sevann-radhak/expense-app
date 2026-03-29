// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;

/// Opens a file picker for `.json` and returns file text, or `null` if empty/cancel/timeout.
Future<String?> pickBookBackupJsonText() async {
  final input = html.FileUploadInputElement()
    ..accept = '.json,application/json'
    ..multiple = false
    ..style.display = 'none';
  html.document.body!.append(input);
  try {
    input.click();
    await input.onChange.first.timeout(const Duration(minutes: 5));
  } on TimeoutException {
    input.remove();
    return null;
  }
  final files = input.files;
  input.remove();
  if (files == null || files.isEmpty) {
    return null;
  }
  final reader = html.FileReader();
  final loaded = reader.onLoad.first;
  reader.readAsText(files[0]);
  await loaded;
  final result = reader.result;
  return result is String ? result : null;
}
