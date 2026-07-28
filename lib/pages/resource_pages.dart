import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../shared/widgets.dart';

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

class PersonnelPage extends StatelessWidget {
  const PersonnelPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Personnel & Shift Management',
        breadcrumb: 'Resource Management › Personnel & Shift Management',
        children: [
          const Row(children: [
            KpiCard(
                title: 'Total Employees',
                value: '184',
                trend: '',
                icon: Icons.group_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'Drivers On Duty',
                value: '42',
                trend: '',
                icon: Icons.person_pin_circle_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'Drivers Off Duty',
                value: '12',
                trend: '',
                icon: Icons.bedtime_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'Active Shifts',
                value: '8',
                trend: '',
                icon: Icons.calendar_month_rounded),
            SizedBox(width: 14),
            KpiCard(
                title: 'Expiring Licenses',
                value: '3',
                trend: '',
                icon: Icons.warning_rounded,
                warning: true)
          ]),
          const SizedBox(height: 24),
          DataTableCard(
              columns: const [
                'Employee ID',
                'Name',
                'Role',
                'Current Shift',
                'Assigned Vehicle',
                'Status'
              ],
              rows: [
                tableRow([
                  'EMP-0492',
                  'Robert K.',
                  'Senior Driver',
                  'Afternoon',
                  'VH-4092',
                  'On Duty'
                ], selected: true),
                tableRow([
                  'EMP-0511',
                  'Sarah M.',
                  'Logistics Coordinator',
                  '-',
                  '-',
                  'Off Duty'
                ]),
                tableRow([
                  'EMP-0623',
                  'James D.',
                  'Driver',
                  'Morning',
                  'VH-1102',
                  'On Duty'
                ])
              ],
              footer: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(
                      child: Text('View All 36 Personnel',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w800))))),
          const SizedBox(height: 24),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
            Expanded(child: AppCard(child: PersonnelList())),
            SizedBox(width: 24),
            Expanded(child: AppCard(child: ScheduleGrid())),
            SizedBox(width: 24),
            Expanded(child: AppCard(child: PersonnelDetail())),
          ]),
        ],
      );
}

class PersonnelList extends StatelessWidget {
  const PersonnelList({super.key});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        Text('PERSONNEL',
            style: TextStyle(fontWeight: FontWeight.w800, color: textMuted)),
        ListTile(
            leading: CircleAvatar(child: Text('RK')),
            title: Text('Robert K.'),
            subtitle: Text('Senior Driver • On Duty')),
        ListTile(
            leading: CircleAvatar(child: Text('SM')),
            title: Text('Sarah M.'),
            subtitle: Text('Logistics Coordinator • Off Duty')),
        ListTile(
            leading: CircleAvatar(child: Text('JD')),
            title: Text('James D.'),
            subtitle: Text('Driver • On Duty'))
      ]);
}

class ScheduleGrid extends StatelessWidget {
  const ScheduleGrid({super.key});
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const SectionTitle('Weekly Schedule'),
        const SizedBox(height: 12),
        Row(
            children: List.generate(
                5,
                (i) => Expanded(
                    child: Container(
                        height: 190,
                        margin: const EdgeInsets.all(3),
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                            border: Border.all(color: border),
                            color: i == 2
                                ? const Color(0xFFE3EAE0)
                                : Colors.white),
                        child: Column(children: [
                          Text(['Mon', 'Tue', 'Wed', 'Thu', 'Fri'][i],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800)),
                          const SizedBox(height: 12),
                          Container(
                              padding: const EdgeInsets.all(8),
                              color: primary,
                              child: const Text('06:00 - 14:00\nMorning Shift',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 12)))
                        ])))))
      ]);
}

class PersonnelDetail extends StatelessWidget {
  const PersonnelDetail({super.key});
  @override
  Widget build(BuildContext context) => Column(children: const [
        CircleAvatar(radius: 44, child: Text('RK')),
        SizedBox(height: 12),
        Text('Robert K.',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        Text('Senior Driver • ID: EMP-0492'),
        SizedBox(height: 16),
        Row(children: [
          Expanded(
              child: FilledButton(onPressed: null, child: Text('Message'))),
          SizedBox(width: 8),
          Expanded(
              child:
                  OutlinedButton(onPressed: null, child: Text('Edit Profile')))
        ]),
        Divider(height: 32),
        MetricLine('Phone', '+1 (555) 019-2837'),
        MetricLine('Email', 'robert.k@ecosystem.com'),
        MetricLine('License Expiration', 'Dec 14, 2025')
      ]);
}
