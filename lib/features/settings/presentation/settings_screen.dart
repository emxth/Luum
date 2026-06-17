import 'package:drift/drift.dart' hide Column;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../data/database/app_database.dart';
import '../../../data/providers/settings_provider.dart';
import '../../../data/repositories/settings_repository.dart';
import '../providers/budget_summary_provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  final monthlyLimitController = TextEditingController();

  final warning1Controller = TextEditingController();

  final warning2Controller = TextEditingController();

  final warning3Controller = TextEditingController();

  bool notificationsEnabled = true;
  bool backupEnabled = true;
  bool darkModeEnabled = false;

  bool loaded = false;

  Future<void> saveSettings() async {
    final repository = ref.read(settingsRepositoryProvider);

    await repository.updateSettings(
      SettingsCompanion(
        monthlyLimit: Value(double.tryParse(monthlyLimitController.text) ?? 0),

        notificationsEnabled: Value(notificationsEnabled),

        backupEnabled: Value(backupEnabled),

        darkModeEnabled: Value(darkModeEnabled),

        warningPercentage1: Value(int.tryParse(warning1Controller.text) ?? 80),

        warningPercentage2: Value(int.tryParse(warning2Controller.text) ?? 90),

        warningPercentage3: Value(int.tryParse(warning3Controller.text) ?? 100),

        updatedAt: Value(DateTime.now().toIso8601String()),
      ),
    );

    ref.invalidate(settingsProvider);

    ref.invalidate(budgetSummaryProvider);

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Settings saved')));
    }
  }

  void loadSettings(Setting settings) {
    if (loaded) {
      return;
    }

    monthlyLimitController.text = settings.monthlyLimit?.toString() ?? '';

    warning1Controller.text = settings.warningPercentage1.toString();

    warning2Controller.text = settings.warningPercentage2.toString();

    warning3Controller.text = settings.warningPercentage3.toString();

    notificationsEnabled = settings.notificationsEnabled;

    backupEnabled = settings.backupEnabled;

    darkModeEnabled = settings.darkModeEnabled;

    loaded = true;
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: settings.when(
        data: (data) {
          if (data == null) {
            return const Center(child: Text('Settings not found'));
          }

          loadSettings(data);

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                SwitchListTile(
                  title: const Text('Notifications'),
                  value: notificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      notificationsEnabled = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text('Backup'),
                  value: backupEnabled,
                  onChanged: (value) {
                    setState(() {
                      backupEnabled = value;
                    });
                  },
                ),

                SwitchListTile(
                  title: const Text('Dark Mode'),
                  value: darkModeEnabled,
                  onChanged: (value) {
                    setState(() {
                      darkModeEnabled = value;
                    });
                  },
                ),

                const Divider(),

                TextField(
                  controller: warning1Controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Warning 1 (%)'),
                ),

                TextField(
                  controller: warning2Controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Warning 2 (%)'),
                ),

                TextField(
                  controller: warning3Controller,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Warning 3 (%)'),
                ),

                const SizedBox(height: 24),

                const Divider(),

                TextField(
                  controller: monthlyLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(labelText: 'Monthly Limit'),
                ),

                const SizedBox(height: 16),

                const Divider(),

                DropdownButton<String>(
                  value: backupFrequency,
                  items: const [
                    DropdownMenuItem(value: 'daily', child: Text('Daily')),
                    DropdownMenuItem(value: 'weekly', child: Text('Weekly')),
                    DropdownMenuItem(value: 'monthly', child: Text('Monthly')),
                  ],
                  onChanged: (value) async {
                    if (value == null) {
                      return;
                    }

                    await SettingsRepository.updateBackupFrequency(value);

                    ref.invalidate(settingsProvider);
                  },
                ),

                ListTile(
                  title: const Text('Backup'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/backup');
                  },
                ),

                ListTile(
                  title: const Text('Backup Frequency'),
                  subtitle: Text(settings.backupFrequency),
                ),

                ElevatedButton(
                  onPressed: saveSettings,
                  child: const Text('Save Settings'),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text(e.toString())),
      ),
    );
  }

  @override
  void dispose() {
    monthlyLimitController.dispose();
    warning1Controller.dispose();
    warning2Controller.dispose();
    warning3Controller.dispose();

    super.dispose();
  }
}
