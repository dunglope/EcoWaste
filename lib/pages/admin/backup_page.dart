import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'backup/backup_now_dialog.dart';
import 'backup/download_archive_dialog.dart';
import 'backup/restore_point_dialog.dart';

class BackupPage extends StatefulWidget {
  const BackupPage({super.key});

  @override
  State<BackupPage> createState() => _BackupPageState();
}

class _BackupPageState extends State<BackupPage> {
  String _lastBackup = 'Today, 02:00 AM';
  String _healthStatus = 'System Health: Optimal';
  BackupRequest? _manualBackup;

  Future<void> _backupNow() async {
    final request = await showDialog<BackupRequest>(
      context: context,
      builder: (context) => const BackupNowDialog(),
    );
    if (request == null || !mounted) return;
    setState(() {
      _manualBackup = request;
      _lastBackup = 'Just now';
      _healthStatus = 'System Health: Optimal';
    });
    _showMessage('${request.scope} backup completed successfully.');
  }

  Future<void> _restoreFromPoint() async {
    final point = await showDialog<RestorePoint>(
      context: context,
      builder: (context) => const RestorePointDialog(),
    );
    if (point == null || !mounted) return;
    setState(() => _healthStatus = 'Restored: ${point.label}');
    _showMessage('System restored from ${point.date}.');
  }

  Future<void> _downloadArchive() async {
    final download = await showDialog<ArchiveDownload>(
      context: context,
      builder: (context) => const DownloadArchiveDialog(),
    );
    if (download == null || !mounted) return;
    _showMessage(
      '${download.format}${download.encrypted ? ' encrypted' : ''} archive download started.',
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    final rows = <List<Widget>>[
      if (_manualBackup != null)
        tableRow([
          'Just now',
          'Manual · ${_manualBackup!.scope}',
          '42.9 GB',
          'Verified',
          _manualBackup!.label,
        ], selected: true),
      tableRow([
        '2023-10-27 02:00:00',
        'Automated',
        '42.8 GB',
        'Verified',
        'Available',
      ]),
      tableRow([
        '2023-10-26 14:30:22',
        'Manual',
        '42.7 GB',
        'Verified',
        'Available',
      ]),
      tableRow([
        '2023-10-25 02:00:00',
        'Automated',
        '42.4 GB',
        'Archived',
        'Archive',
      ]),
    ];

    return PageScaffold(
      title: 'Backup & Restore',
      subtitle: 'Manage system backups and disaster recovery.',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: AppCard(
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      _healthStatus,
                      icon: Icons.cloud_done_rounded,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        Expanded(child: MetricLine('Last Backup', _lastBackup)),
                        const Expanded(
                          child: MetricLine('Total Size', '42.8 GB'),
                        ),
                        const Expanded(
                          child: MetricLine(
                            'Next Schedule',
                            'Tomorrow 02:00 AM',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 210,
              child: AppCard(
                height: 220,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const Text('Actions',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Spacer(),
                    FilledButton.icon(
                      onPressed: _backupNow,
                      style: FilledButton.styleFrom(backgroundColor: primary),
                      icon: const Icon(Icons.cloud_upload_outlined),
                      label: const Text('Backup Now'),
                    ),
                    const SizedBox(height: 6),
                    OutlinedButton.icon(
                      onPressed: _restoreFromPoint,
                      icon: const Icon(Icons.restore_rounded),
                      label: const Text('Restore from Point'),
                    ),
                    TextButton.icon(
                      onPressed: _downloadArchive,
                      icon: const Icon(Icons.download_rounded),
                      label: const Text('Download Archive'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DataTableCard(
          title: 'Recent Backups',
          columns: const [
            'Timestamp',
            'Type',
            'Size',
            'Integrity Check',
            'Action',
          ],
          rows: rows,
        ),
      ],
    );
  }
}
