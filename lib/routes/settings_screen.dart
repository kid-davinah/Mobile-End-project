import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = true;
  bool _darkMode = false;
  bool _biometrics = false;

  void _showBackupDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup & Export'),
        content: const Text('This is a demo. In a real app, you could export your data here.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F8FA),
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: const Color(0xFFF8BBD0),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            color: const Color(0xFFF8BBD0),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: SwitchListTile(
              value: _notifications,
              onChanged: (val) => setState(() => _notifications = val),
              title: const Text('Enable Notifications', style: TextStyle(fontWeight: FontWeight.bold)),
              secondary: const Icon(Icons.notifications),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFCE93D8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: SwitchListTile(
              value: _darkMode,
              onChanged: (val) => setState(() => _darkMode = val),
              title: const Text('Dark Mode', style: TextStyle(fontWeight: FontWeight.bold)),
              secondary: const Icon(Icons.dark_mode),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            color: const Color(0xFFFFF59D),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 3,
            child: SwitchListTile(
              value: _biometrics,
              onChanged: (val) => setState(() => _biometrics = val),
              title: const Text('Enable Biometrics', style: TextStyle(fontWeight: FontWeight.bold)),
              secondary: const Icon(Icons.fingerprint),
            ),
          ),
          const SizedBox(height: 32),
          Center(
            child: ElevatedButton.icon(
              onPressed: _showBackupDialog,
              icon: const Icon(Icons.backup),
              label: const Text('Backup & Export'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF8BBD0),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
} 