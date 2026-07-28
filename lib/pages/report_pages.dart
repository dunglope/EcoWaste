import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../shared/widgets.dart';

class KpiPage extends StatelessWidget {
  const KpiPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'KPI Reports',
        breadcrumb: 'Reports & Analytics › KPI Reports',
        actions: [
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded),
              label: const Text('Export')),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.sync_rounded),
              label: const Text('Generate Report'),
              style: FilledButton.styleFrom(backgroundColor: primary))
        ],
        children: [
          const AppCard(
              child: Row(children: [
            CircleAvatar(
                backgroundColor: purple,
                child: Icon(Icons.auto_awesome_rounded, color: Colors.white)),
            SizedBox(width: 18),
            Expanded(
                child: Text(
                    'AI Insights\nHighest performing district: North District (+12% efficiency)\nFleet utilization optimization recommended for Sector C',
                    style: TextStyle(fontSize: 16)))
          ])),
          const SizedBox(height: 24),
          const Row(children: [
            KpiCard(
                title: 'Total Requests',
                value: '12,450',
                trend: '+5.2% vs last period',
                icon: Icons.assignment_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Avg Response Time',
                value: '45m',
                trend: '-12% vs last period',
                icon: Icons.timer_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Fleet Utilization',
                value: '87%',
                trend: '-2.1% vs last period',
                icon: Icons.local_shipping_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Success Rate',
                value: '99.2%',
                trend: '+0.5% vs last period',
                icon: Icons.check_circle_outline_rounded)
          ]),
          const SizedBox(height: 24),
          Row(children: [
            Expanded(
                flex: 2,
                child: AppCard(
                    height: 300,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SectionTitle('Collection Trend'),
                          Expanded(
                              child: Center(
                                  child: Text(
                                      '[Line Chart Placeholder - Collection Trend]')))
                        ]))),
            const SizedBox(width: 24),
            Expanded(
                child: AppCard(
                    height: 300,
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          SectionTitle('Waste Category Distribution'),
                          Expanded(
                              child: Center(
                                  child: Text('[Donut Chart Placeholder]')))
                        ])))
          ]),
          const SizedBox(height: 24),
          DataTableCard(title: 'District Performance', columns: const [
            'District',
            'Requests',
            'Completed',
            'Response Time',
            'Score'
          ], rows: [
            tableRow(['North District', '3,200', '3,150', '38m', '98/100']),
            tableRow(['South District', '2,800', '2,700', '42m', '95/100']),
            tableRow(['East District', '4,100', '3,900', '51m', '88/100'])
          ]),
        ],
      );
}

class SpatialAnalysisPage extends StatelessWidget {
  const SpatialAnalysisPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Spatial Analysis Map',
        breadcrumb: 'Reports & Analytics › Spatial Analysis Map',
        scroll: false,
        actions: [
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.download_rounded),
              label: const Text('Export Map')),
          OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.table_chart_rounded),
              label: const Text('Export Data')),
          FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run Analysis'),
              style: FilledButton.styleFrom(backgroundColor: primary))
        ],
        children: [
          Expanded(
              child: Row(children: [
            SizedBox(
                width: 310,
                child: AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      SectionTitle('Analysis Toolbox',
                          icon: Icons.build_rounded),
                      SizedBox(height: 18),
                      Text('Density Analysis',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      RadioListTile(
                          value: true,
                          groupValue: true,
                          onChanged: null,
                          title: Text('Kernel Density Estimation')),
                      RadioListTile(
                          value: false,
                          groupValue: true,
                          onChanged: null,
                          title: Text('Point Density')),
                      Divider(),
                      Text('Hotspot Analysis',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      CheckboxListTile(
                          value: true,
                          onChanged: null,
                          title: Text('Optimized Hot Spot Analysis'))
                    ]))),
            const Expanded(
                child: FakeMap(
                    heat: true,
                    height: double.infinity,
                    label: 'Spatial Heatmap')),
            SizedBox(
                width: 330,
                child: AppCard(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                      SectionTitle('Results'),
                      SizedBox(height: 24),
                      MetricLine('Max Density', '42.8'),
                      MetricLine('Mean Density', '14.2'),
                      SizedBox(height: 18),
                      ChipPill('Downtown Core (Sector 7G)', danger: true),
                      SizedBox(height: 28),
                      SectionTitle('Distribution Curve'),
                      SizedBox(height: 12),
                      MiniBars(),
                      Spacer(),
                      FilledButton(
                          onPressed: null,
                          child: Text('Generate Detailed Report'))
                    ]))),
          ])),
        ],
      );
}
