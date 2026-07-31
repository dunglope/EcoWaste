import 'package:flutter/material.dart';

import '../../shared/widgets.dart';
import 'fleet_config_page.dart';

class DatabasePage extends StatelessWidget {
  const DatabasePage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Database',
          subtitle: 'Monitor database health and storage performance.',
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              SizedBox(
                  width: 200,
                  child: AppCard(
                      height: 260,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle('System Health'),
                            ChipPill('● Online', active: true),
                            Spacer(),
                            MetricLine('Uptime', '100%'),
                            MetricLine('Replication Lag', '1.2s')
                          ]))),
              SizedBox(width: 24),
              Expanded(
                  child: AppCard(
                      height: 260,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle('Connection Pool'),
                            Expanded(
                                child: Center(
                                    child: Text(
                                        '[Real-time Line Chart Area: Connections over Time]')))
                          ]))),
            ]),
            const SizedBox(height: 24),
            Row(children: const [
              Expanded(
                  child: AppCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                    SectionTitle('Storage Usage'),
                    MetricLine('Spatial Data', '2.1 TB (42%)'),
                    LinearProgressIndicator(value: .42),
                    MetricLine('Telemetry Logs', '1.5 TB (30%)'),
                    LinearProgressIndicator(value: .30),
                    MetricLine('Free Space', '1.4 TB (28%)'),
                    LinearProgressIndicator(value: .28)
                  ]))),
              SizedBox(width: 24),
              SizedBox(
                  width: 220,
                  child: ConfigPanel(
                      'Advanced Tools',
                      Icons.construction_rounded,
                      ['Re-index Tables', 'Query Log Viewer']))
            ]),
          ]);
}
