import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:open_filex/open_filex.dart';

/// Check if platform supports opening folder in file manager
bool get canOpenFolder {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux || Platform.isAndroid;
}

/// Open the download folder in the system file manager
Future<bool> openDownloadFolder() async {
  try {
    if (Platform.isAndroid) {
      // On Android, open the Olib folder in Downloads
      final path = '/storage/emulated/0/Download/Olib';
      final dir = Directory(path);
      if (await dir.exists()) {
        final result = await OpenFilex.open(path);
        return result.type == ResultType.done;
      }
      // Fallback: try to open the Downloads folder
      final result = await OpenFilex.open('/storage/emulated/0/Download');
      return result.type == ResultType.done;
    } else if (Platform.isWindows) {
      await Process.run('explorer', [Directory.current.path]);
      return true;
    } else if (Platform.isMacOS) {
      await Process.run('open', [Directory.current.path]);
      return true;
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', [Directory.current.path]);
      return true;
    }
    return false;
  } catch (e) {
    debugPrint('Failed to open download folder: $e');
    return false;
  }
}

/// Open a file with the system default application
Future<bool> openFile(String filePath) async {
  try {
    final file = File(filePath);
    if (!await file.exists()) {
      return false;
    }
    final result = await OpenFilex.open(filePath);
    return result.type == ResultType.done;
  } catch (e) {
    debugPrint('Failed to open file: $e');
    return false;
  }
}

/// Get file size as human-readable string
String formatFileSize(int bytes) {
  if (bytes > 1024 * 1024) {
    return '${(bytes / (1024 * 1024)).toStringAsFixed(2)} MB';
  } else if (bytes > 1024) {
    return '${(bytes / 1024).toStringAsFixed(2)} KB';
  } else {
    return '$bytes B';
  }
}

/// Build a safe filename for saving files
String buildSafeFileName(String name, {String? extension}) {
  String safeName = name.replaceAll(RegExp(r'[/\\:*?"<>|\x00-\x1f]'), '').trim();
  if (safeName.isEmpty) {
    safeName = 'file_${DateTime.now().millisecondsSinceEpoch}';
  }
  if (extension != null && extension.isNotEmpty) {
    return '$safeName.$extension';
  }
  return safeName;
}
