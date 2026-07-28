import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../shared/widgets.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Operational Overview',
      breadcrumb: 'Dashboard',
      actions: const [
        Text('LAST UPDATED\nJust now',
            textAlign: TextAlign.right,
            style: TextStyle(fontWeight: FontWeight.w700, color: textMuted))
      ],
      children: [
        const Row(children: [
          KpiCard(
              title: 'Total Waste Collected',
              value: '4,250 t',
              trend: '↗ +5.2% vs yesterday',
              icon: Icons.delete_outline_rounded),
          SizedBox(width: 24),
          KpiCard(
              title: 'Active Fleet',
              value: '84 / 92',
              trend: '91% Utilization',
              icon: Icons.local_shipping_rounded),
          SizedBox(width: 24),
          KpiCard(
              title: 'Pending Requests',
              value: '124',
              trend: '15 high priority',
              icon: Icons.warning_amber_rounded,
              warning: true),
          SizedBox(width: 24),
          KpiCard(
              title: 'Optimization Score',
              value: '94%',
              trend: 'Top 10% Regional',
              icon: Icons.speed_rounded),
        ]),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Expanded(flex: 3, child: FakeMap(height: 610)),
            const SizedBox(width: 24),
            Expanded(
              child: Column(
                children: [
                  AppCard(
                      height: 260,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SectionTitle('Daily Collection Volume'),
                            const Spacer(),
                            MiniBars()
                          ])),
                  const SizedBox(height: 24),
                  const AlertsCard(),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class AlertsCard extends StatelessWidget {
  const AlertsCard({super.key});
  @override
  Widget build(BuildContext context) {
    final alerts = [
      [
        'Vehicle Breakdown',
        'Truck 42 reported engine failure in Zone C.',
        'INCIDENT'
      ],
      [
        'Route Delay',
        'Route 7 is running 45 minutes behind schedule.',
        'DELAYED'
      ],
      [
        'Bin Overflow',
        'Critical fill level reached at Sector 9 station.',
        'CRITICAL'
      ],
    ];
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: const [
            Expanded(child: SectionTitle('Recent Alerts')),
            Text('View All',
                style: TextStyle(color: primary, fontWeight: FontWeight.w700))
          ]),
          const SizedBox(height: 12),
          for (final a in alerts)
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: CircleAvatar(
                  backgroundColor: alertSoft,
                  child: Icon(Icons.warning_amber_rounded, color: alert)),
              title: Text(a[0],
                  style: const TextStyle(fontWeight: FontWeight.w800)),
              subtitle: Text(a[1]),
              trailing: ChipPill(a[2], danger: a[2] != 'DELAYED'),
            ),
        ],
      ),
    );
  }
}
