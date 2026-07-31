import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class TransferStationsPage extends StatelessWidget {
  const TransferStationsPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Waste Transfer Stations',
        breadcrumb: 'Spatial Infrastructure › Waste Transfer Stations',
        actions: [
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Station')),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.upload_rounded),
              label: const Text('Import GIS Data')),
          TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded),
              label: const Text('Export GIS Data'))
        ],
        children: [
          const Row(children: [
            KpiCard(
                title: 'Total Stations',
                value: '142',
                trend: '',
                icon: Icons.business_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Operational Stations',
                value: '118',
                trend: '+2 this week',
                icon: Icons.check_circle_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Avg. Capacity Utilization',
                value: '68%',
                trend: '',
                icon: Icons.speed_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Requiring Attention',
                value: '12',
                trend: '',
                icon: Icons.warning_rounded,
                warning: true)
          ]),
          const SizedBox(height: 16),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            SizedBox(
                width: 300,
                child: AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      SectionTitle('District Explorer'),
                      SizedBox(height: 12),
                      ChipPill('Operational', active: true),
                      ListTile(
                          title: Text('Oakwood Transfer'),
                          subtitle: LinearProgressIndicator(value: .45)),
                      ListTile(
                          title: Text('Riverside Facility'),
                          subtitle:
                              LinearProgressIndicator(value: .92, color: alert))
                    ]))),
            const SizedBox(width: 16),
            const Expanded(
                child: FakeMap(height: 610, label: 'Station GIS Map')),
            const SizedBox(width: 16),
            SizedBox(
                width: 330,
                child: AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      Text('SELECTED ASSET',
                          style: TextStyle(
                              fontWeight: FontWeight.w800, color: textMuted)),
                      SizedBox(height: 12),
                      Text('Oakwood Transfer',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w800)),
                      Text('ID: WTS-1042'),
                      SizedBox(height: 24),
                      ChipPill('● OPERATIONAL', active: true),
                      SizedBox(height: 16),
                      MetricLine('Capacity vs Load', '45%'),
                      LinearProgressIndicator(value: .45, color: primary),
                      SizedBox(height: 20),
                      Text(
                          'Properties\nDistrict: North District\nCoordinates: 41.8781° N, 87.6298° W\nAccepted Waste: Municipal Solid, Recyclables, Yard Waste')
                    ]))),
          ]),
        ],
      );
}
