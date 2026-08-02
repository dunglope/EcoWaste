import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'database/query_log_dialog.dart';
import 'database/reindex_tables_dialog.dart';

class DatabasePage extends StatefulWidget {
  const DatabasePage({super.key});

  @override
  State<DatabasePage> createState() => _DatabasePageState();
}

class _DatabasePageState extends State<DatabasePage> {
  String _lastReindexed = '12 days ago';
  String _health = 'Online';

  Future<void> _openReindexDialog() async {
    final method = await showDialog<String>(
      context: context,
      builder: (context) => const ReindexTablesDialog(),
    );
    if (method == null || !mounted) return;
    setState(() {
      _lastReindexed = 'Just now';
      _health = 'Optimized';
    });
    _showMessage('$method completed successfully.');
  }

  void _openQueryLog() {
    showDialog<void>(
      context: context,
      builder: (context) => const QueryLogDialog(),
    );
  }

  void _showConnectionDetails() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Connection Pool Details'),
        content: const SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              MetricLine('Active Connections', '38 / 100'),
              MetricLine('Idle Connections', '22'),
              MetricLine('Waiting Requests', '0'),
              MetricLine('Average Query Time', '34ms'),
              MetricLine('Peak Connections (24h)', '71'),
            ],
          ),
        ),
        actions: [
          OutlinedButton.icon(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              _showMessage('Connection pool metrics refreshed.');
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Database',
      subtitle: 'Monitor database health and storage performance.',
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 200,
              child: AppCard(
                height: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('System Health'),
                    ChipPill('● $_health', active: true),
                    const Spacer(),
                    const MetricLine('Uptime', '100%'),
                    const MetricLine('Replication Lag', '1.2s'),
                    MetricLine('Last Re-indexed', _lastReindexed),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppCard(
                height: 260,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(child: SectionTitle('Connection Pool')),
                        TextButton(
                          onPressed: _showConnectionDetails,
                          child: const Text('View Details'),
                        ),
                      ],
                    ),
                    const Expanded(
                      child: Center(
                        child: Text(
                          '[Real-time Line Chart Area: Connections over Time]',
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Storage Usage'),
                    MetricLine('Spatial Data', '2.1 TB (42%)'),
                    LinearProgressIndicator(value: .42),
                    MetricLine('Telemetry Logs', '1.5 TB (30%)'),
                    LinearProgressIndicator(value: .30),
                    MetricLine('Free Space', '1.4 TB (28%)'),
                    LinearProgressIndicator(value: .28),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            SizedBox(
              width: 240,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SectionTitle(
                      'Advanced Tools',
                      icon: Icons.construction_rounded,
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Maintenance & Diagnostics',
                      style: TextStyle(color: textMuted, fontSize: 12),
                    ),
                    const Divider(height: 24),
                    OutlinedButton.icon(
                      onPressed: _openReindexDialog,
                      icon: const Icon(Icons.build_rounded),
                      label: const Text('Re-index Tables'),
                    ),
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      onPressed: _openQueryLog,
                      icon: const Icon(Icons.list_alt_rounded),
                      label: const Text('Query Log Viewer'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
