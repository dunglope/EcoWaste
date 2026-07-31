import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

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
