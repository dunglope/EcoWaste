import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'General Settings',
        subtitle: 'Manage system preferences.',
        children: [
          const Row(children: [
            KpiCard(
                title: 'CPU Usage',
                value: '24%',
                trend: 'Good',
                icon: Icons.memory_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Database Health',
                value: 'Healthy',
                trend: '100% Uptime',
                icon: Icons.storage_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Storage',
                value: '87% full',
                trend: '',
                icon: Icons.inventory_2_rounded,
                warning: true)
          ]),
          const SizedBox(height: 24),
          SettingsForm(title: 'Platform Preferences', fields: const [
            'System Name|EcoSmart Waste',
            'Organization Name|City Municipality Services',
            'Language|English (US)',
            'Timezone|UTC -05:00 (Eastern Time)'
          ]),
        ],
      );
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key, required this.title, required this.fields});
  final String title;
  final List<String> fields;
  @override
  Widget build(BuildContext context) => AppCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        const Divider(height: 1),
        Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
                spacing: 24,
                runSpacing: 20,
                children: fields.map((f) {
                  final p = f.split('|');
                  return SizedBox(
                      width: 280,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [formLabel(p[0]), fakeField(p[1])]));
                }).toList())),
        Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF2F3ED),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(onPressed: () {}, child: const Text('Discard')),
              const SizedBox(width: 12),
              FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(backgroundColor: primary),
                  child: const Text('Save Changes'))
            ])),
      ]));
}
