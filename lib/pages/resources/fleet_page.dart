import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class FleetPage extends StatelessWidget {
  const FleetPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Fleet Management',
        breadcrumb: 'Resource Management › Fleet Management',
        children: [
          const Row(children: [
            KpiCard(
                title: 'Total Vehicles',
                value: '156',
                trend: '',
                icon: Icons.local_shipping_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'In Service',
                value: '142',
                trend: '',
                icon: Icons.check_circle_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'Maintenance',
                value: '8',
                trend: '',
                icon: Icons.build_rounded,
                warning: true),
            SizedBox(width: 14),
            KpiCard(
                title: 'Available',
                value: '6',
                trend: '',
                icon: Icons.event_available_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'GPS Online',
                value: '154',
                trend: '',
                icon: Icons.gps_fixed_rounded)
          ]),
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Expanded(
              flex: 7,
              child: DataTableCard(columns: const [
                'Vehicle ID',
                'License Plate',
                'Type',
                'Status',
                'Assigned Driver',
                'Fuel'
              ], rows: [
                tableRow([
                  'TRK-842',
                  'GZA-9231',
                  'Heavy Compactor',
                  'In Service',
                  'Robert K.',
                  '45%'
                ], selected: true),
                tableRow([
                  'TRK-843',
                  'GZA-9232',
                  'Standard Loader',
                  'Available',
                  'Unassigned',
                  '83%'
                ]),
                tableRow([
                  'TRK-844',
                  'GZA-9233',
                  'Heavy Compactor',
                  'Maintenance',
                  'Sarah J.',
                  '12%'
                ]),
                tableRow([
                  'TRK-845',
                  'GZA-9234',
                  'Light EV',
                  'In Service',
                  'Mike T.',
                  '72%'
                ]),
              ]),
            ),
            const SizedBox(width: 24),
            SizedBox(
                width: 300,
                child: AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      FakeMap(height: 160, label: 'Vehicle Photo'),
                      SizedBox(height: 20),
                      Text('TRK-842',
                          style: TextStyle(
                              fontSize: 28, fontWeight: FontWeight.w800)),
                      Text('Volvo FMX Heavy Compactor • GZA-9231'),
                      SizedBox(height: 20),
                      MetricLine('Assigned Driver', 'Robert K.'),
                      MetricLine('Payload Cap.', '18,500 kg'),
                      MetricLine('Current Mileage', '142,850 km'),
                      SizedBox(height: 16),
                      SectionTitle('Telemetry'),
                      MetricLine('Fuel Level', '45%'),
                      LinearProgressIndicator(value: .45, color: primary),
                      MetricLine('Engine Temp', '92°C')
                    ]))),
          ]),
        ],
      );
}
