import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/backup_provider.dart';
import '../providers/backup_info_provider.dart';

class BackupScreen extends ConsumerStatefulWidget {
  const BackupScreen({super.key});

  @override
  ConsumerState<BackupScreen> createState() => _BackupScreenState();
}

class _BackupScreenState extends ConsumerState<BackupScreen> {
  File? latestBackup;

  @override
  Widget build(BuildContext context) {
    final lastBackup = ref.watch(lastBackupProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Backup')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Last Backup'),

            const SizedBox(height: 8),

            lastBackup.when(
              data: (value) {
                return Text(value ?? 'Never');
              },
              loading: () => const CircularProgressIndicator(),
              error: (e, _) => Text(e.toString()),
            ),

            const SizedBox(height: 24),

            ElevatedButton(
              onPressed: () async {
                final file = await ref
                    .read(backupServiceProvider)
                    .createBackup();

                latestBackup = file;

                ref.invalidate(lastBackupProvider);

                if (mounted) {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text('Backup created')));
                }
              },
              child: const Text('Create Backup'),
            ),

            const SizedBox(height: 12),

            ElevatedButton(
              onPressed: latestBackup == null
                  ? null
                  : () async {
                      await ref
                          .read(backupServiceProvider)
                          .shareBackup(latestBackup!);
                    },
              child: const Text('Share Latest Backup'),
            ),
          ],
        ),
      ),
    );
  }
}
