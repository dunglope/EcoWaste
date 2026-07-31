import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Backup & Restore',
          subtitle: 'Manage system backups and disaster recovery.',
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Expanded(
                  child: AppCard(
                      height: 220,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle('System Health: Optimal',
                                icon: Icons.cloud_done_rounded),
                            Spacer(),
                            Row(children: [
                              Expanded(
                                  child: MetricLine(
                                      'Last Backup', 'Today, 02:00 AM')),
                              Expanded(
                                  child: MetricLine('Total Size', '42.8 GB')),
                              Expanded(
                                  child: MetricLine(
                                      'Next Schedule', 'Tomorrow 02:00 AM'))
                            ])
                          ]))),
              const SizedBox(width: 24),
              SizedBox(
                  width: 190,
                  child: AppCard(
                      height: 220,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            const Spacer(),
                            FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                    backgroundColor: primary),
                                child: const Text('Backup Now')),
                            OutlinedButton(
                                onPressed: () {},
                                child: const Text('Restore from Point')),
                            TextButton(
                                onPressed: () {},
                                child: const Text('Download Archive'))
                          ]))),
            ]),
            const SizedBox(height: 24),
            DataTableCard(title: 'Recent Backups', columns: const [
              'Timestamp',
              'Type',
              'Size',
              'Integrity Check',
              'Action'
            ], rows: [
              tableRow([
                '2023-10-27 02:00:00',
                'Automated',
                '42.8 GB',
                'Verified',
                ''
              ]),
              tableRow(
                  ['2023-10-26 14:30:22', 'Manual', '42.7 GB', 'Verified', '']),
              tableRow([
                '2023-10-25 02:00:00',
                'Automated',
                '42.4 GB',
                'Archived',
                ''
              ])
            ]),
          ]);
}
