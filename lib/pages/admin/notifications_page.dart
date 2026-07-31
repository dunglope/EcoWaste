import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Notifications',
          subtitle: 'Configure system-wide alert and reporting preferences.',
          actions: [
            FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: primary),
                child: const Text('Save Changes'))
          ],
          children: [
            AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: const [
                  SwitchRow('Emergency Broadcast (SMS/Push)',
                      'Critical alerts requiring immediate attention.', true),
                  SwitchRow(
                      'Route Deviation Alerts',
                      'Notifications when vehicles stray from planned paths.',
                      true),
                  SwitchRow(
                      'Maintenance Reminders',
                      'Scheduled upkeep and service warnings for fleet.',
                      false),
                  SwitchRow(
                      'System Health Warnings',
                      'Alerts regarding database sync or GPS connectivity issues.',
                      true),
                  SwitchRow(
                      'Daily Operational Summaries',
                      'End-of-day reports on collection metrics and incidents.',
                      false),
                  SwitchRow(
                      'API Connection Alerts',
                      'Notifications on third-party integration statuses.',
                      true),
                ])),
          ]);
}

class SwitchRow extends StatelessWidget {
  const SwitchRow(this.title, this.desc, this.value, {super.key});
  final String title;
  final String desc;
  final bool value;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: textMuted))
        ])),
        Switch(value: value, onChanged: (_) {})
      ]));
}
