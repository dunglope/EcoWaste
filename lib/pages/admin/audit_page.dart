import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class AuditPage extends StatelessWidget {
  const AuditPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Audit Logs',
          subtitle: 'Track all system changes and user activities.',
          actions: [
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text('Export CSV')),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('Export PDF'))
          ],
          children: [
            AppCard(
                child: Wrap(spacing: 18, runSpacing: 12, children: const [
              ChipPill('Last 7 Days'),
              ChipPill('All Users'),
              ChipPill('All Modules'),
              ChipPill('All Actions'),
              ChipPill('Clear Filters', active: true)
            ])),
            const SizedBox(height: 24),
            DataTableCard(columns: const [
              'Timestamp',
              'User',
              'Action',
              'Module',
              'IP Address',
              'Status'
            ], rows: [
              tableRow([
                '2026-07-27 10:44',
                'Sarah Jenkins',
                'Updated role',
                'Roles',
                '10.0.50.4',
                'Success'
              ]),
              tableRow([
                '2026-07-27 09:18',
                'David Chen',
                'Exported fleet',
                'Fleet',
                '10.0.50.9',
                'Success'
              ]),
              tableRow([
                '2026-07-26 17:55',
                'System',
                'Backup completed',
                'Backup',
                '127.0.0.1',
                'Success'
              ])
            ]),
          ]);
}
