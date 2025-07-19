import 'package:local_auth/local_auth.dart';
import 'package:student_budget_tracker/core/database/database_service.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';

class SecurityService {
  final LocalAuthentication _auth = LocalAuthentication();
  final DatabaseService _dbService = DatabaseService.instance;

  // Store PIN as a hash in a settings table
  Future<void> setPin(String pin) async {
    final db = await _dbService.database;
    final pinHash = sha256.convert(utf8.encode(pin)).toString();
    await db.insert('settings', {'key': 'pin_hash', 'value': pinHash}, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<bool> verifyPin(String pin) async {
    final db = await _dbService.database;
    final pinHash = sha256.convert(utf8.encode(pin)).toString();
    final result = await db.query('settings', where: 'key = ?', whereArgs: ['pin_hash']);
    if (result.isNotEmpty) {
      return result.first['value'] == pinHash;
    }
    return false;
  }

  Future<bool> isPinSet() async {
    final db = await _dbService.database;
    final result = await db.query('settings', where: 'key = ?', whereArgs: ['pin_hash']);
    return result.isNotEmpty;
  }

  Future<bool> authenticateWithBiometrics() async {
    final canCheck = await _auth.canCheckBiometrics;
    if (!canCheck) return false;
    try {
      return await _auth.authenticate(
        localizedReason: 'Authenticate to unlock the app',
        options: const AuthenticationOptions(biometricOnly: true),
      );
    } catch (_) {
      return false;
    }
  }
} 