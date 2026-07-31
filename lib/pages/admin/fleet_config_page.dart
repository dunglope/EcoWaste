import 'package:flutter/material.dart';

import '../../shared/widgets.dart';

class FleetConfigPage extends StatelessWidget {
  const FleetConfigPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Fleet Configuration',
          subtitle: 'Global parameters for vehicle management.',
          children: [
            Wrap(spacing: 24, runSpacing: 24, children: const [
              ConfigPanel('Vehicle Classes', Icons.directions_car_rounded, [
                'Heavy - 26000 kg',
                'Hookloader - 32000 kg',
                'Van - 3500 kg'
              ]),
              ConfigPanel('Maintenance', Icons.build_rounded, [
                'Standard Maintenance Interval 15,000 km',
                'Warning distance 1000 km',
                'Critical overdue 500 km'
              ]),
              ConfigPanel('Fuel Management', Icons.local_gas_station_rounded, [
                'Primary Fuel Diesel',
                'Secondary Fuel None',
                'Low Fuel Warning 15%'
              ]),
              ConfigPanel('GPS Telemetry', Icons.satellite_alt_rounded, [
                'Ping Frequency 10s',
                'Detailed Route History 90 Days',
                'Aggregated Metrics Indefinite'
              ]),
            ]),
          ]);
}

class ConfigPanel extends StatelessWidget {
  const ConfigPanel(this.title, this.icon, this.lines, {super.key});
  final String title;
  final IconData icon;
  final List<String> lines;
  @override
  Widget build(BuildContext context) => AppCard(
      width: 304,
      height: 250,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(title, icon: icon),
        const Divider(height: 24),
        for (final l in lines)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 9), child: Text(l)),
        const Spacer(),
        Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add')))
      ]));
}
