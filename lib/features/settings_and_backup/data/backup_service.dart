import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as p;

class BackupService {
  // Get the path to the SQLite database file
  Future<File> getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File(p.join(dir.path, 'app_database.db'));
  }

  // Export the database file to a user-selected location
  Future<bool> exportDatabase() async {
    final dbFile = await getDatabaseFile();
    final result = await FilePicker.platform.saveFile(
      dialogTitle: 'Export Backup',
      fileName: 'student_budget_backup.db',
    );
    if (result != null) {
      final backupFile = File(result);
      await backupFile.writeAsBytes(await dbFile.readAsBytes());
      return true;
    }
    return false;
  }

  // Restore the database file from a user-selected backup
  Future<bool> restoreDatabase({required bool confirmOverwrite}) async {
    if (!confirmOverwrite) return false;
    final dbFile = await getDatabaseFile();
    final result = await FilePicker.platform.pickFiles(type: FileType.any);
    if (result != null && result.files.single.path != null) {
      final backupFile = File(result.files.single.path!);
      await dbFile.writeAsBytes(await backupFile.readAsBytes(), flush: true);
      return true;
    }
    return false;
  }

  // Get backup metadata
  Future<Map<String, dynamic>> getBackupMetadata(File file) async {
    final stat = await file.stat();
    return {
      'fileName': p.basename(file.path),
      'size': stat.size,
      'lastModified': stat.modified,
    };
  }
} 