import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

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
