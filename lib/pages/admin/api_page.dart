import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class ApiPage extends StatelessWidget {
  const ApiPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'API Integration',
          subtitle: 'Manage external service connections and webhooks.',
          children: [
            Wrap(spacing: 24, runSpacing: 24, children: const [
              IntegrationCard('Google Maps Platform', Icons.map_rounded,
                  'Connected', 'Monthly Usage 42,500 / 100,000 reqs'),
              IntegrationCard(
                  'Firebase Messaging',
                  Icons.notifications_active_rounded,
                  'Connected',
                  'Messages Sent (30d) 1.2M'),
              IntegrationCard('Enterprise ERP', Icons.table_view_rounded,
                  'Pending Sync', 'Last Sync Attempt Today, 14:15 - Timeout',
                  danger: true),
              IntegrationCard('Custom Webhooks', Icons.webhook_rounded,
                  '3 Active', 'Events Processed (24h) 4,892'),
            ]),
          ]);
}

class IntegrationCard extends StatelessWidget {
  const IntegrationCard(this.title, this.icon, this.status, this.detail,
      {super.key, this.danger = false});
  final String title;
  final IconData icon;
  final String status;
  final String detail;
  final bool danger;
  @override
  Widget build(BuildContext context) => Container(
        width: 304,
        height: 230,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          border: Border(
            left: BorderSide(
                color: danger ? const Color(0xFFE58BB0) : primary, width: 4),
            top: const BorderSide(color: border),
            right: const BorderSide(color: border),
            bottom: const BorderSide(color: border),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: background,
                    child: Icon(icon, color: primary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800))),
                OutlinedButton(
                    onPressed: () {}, child: const Text('Configure')),
              ],
            ),
            Text(
              '● $status',
              style: TextStyle(
                  color: danger
                      ? const Color(0xFFD95C91)
                      : const Color(0xFF2E6735),
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            const AppCard(
              tint: Color(0xFFF2F3ED),
              padding: EdgeInsets.all(10),
              child: Text(
                  'ENDPOINT        ****************\nAPI KEY         AlzaSyB...9XqQ'),
            ),
            const Spacer(),
            Text(detail),
          ],
        ),
      );
}
