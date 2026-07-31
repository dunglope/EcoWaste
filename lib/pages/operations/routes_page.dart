import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class RoutesPage extends StatelessWidget {
  const RoutesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Collection Routes',
      breadcrumb: 'Spatial Infrastructure › Collection Routes',
      scroll: false,
      actions: [
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.download_rounded),
            label: const Text('Export'))
      ],
      children: [
        Expanded(
          child: Row(
            children: [
              SizedBox(
                  width: 290,
                  child: AppCard(
                      padding: EdgeInsets.zero,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Padding(
                                padding: EdgeInsets.all(16),
                                child: SectionTitle('Route Explorer')),
                            Divider(height: 1),
                            ListTile(
                                title: Text('North District',
                                    style: TextStyle(
                                        fontWeight: FontWeight.w800))),
                            ListTile(
                                selected: true,
                                leading: Icon(Icons.circle,
                                    size: 12, color: primary),
                                title: Text('R-N101 (Residential)'),
                                trailing:
                                    Icon(Icons.check_circle_outline_rounded)),
                            ListTile(
                                leading: Icon(Icons.circle,
                                    size: 12, color: Color(0xFF3E6842)),
                                title: Text('R-N102 (Commercial)')),
                          ]))),
              const Expanded(
                  child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 0),
                      child: FakeMap(
                          height: double.infinity,
                          label: 'Route Editing Map'))),
              SizedBox(
                  width: 360,
                  child: AppCard(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: const [
                              Expanded(child: SectionTitle('Route Attributes')),
                              ChipPill('Editing', active: true)
                            ]),
                            const SizedBox(height: 20),
                            formLabel('Route ID'),
                            fakeField('R-N101'),
                            formLabel('Name / Description'),
                            fakeField('North Res Route A'),
                            Row(children: [
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    formLabel('Assigned Vehicle'),
                                    fakeField('TRK-402 (EV)')
                                  ])),
                              const SizedBox(width: 12),
                              Expanded(
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                    formLabel('Frequency'),
                                    fakeField('Bi-Weekly')
                                  ]))
                            ]),
                            const SizedBox(height: 16),
                            const AppCard(
                                child: Column(children: [
                              MetricLine('Distance', '14.2 km'),
                              MetricLine('Est. Time', '3h 45m'),
                              MetricLine('Service Points', '1,204')
                            ])),
                            const Spacer(),
                            Row(children: [
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Delete',
                                      style: TextStyle(color: alert))),
                              const Spacer(),
                              TextButton(
                                  onPressed: () {},
                                  child: const Text('Cancel')),
                              FilledButton(
                                  onPressed: () {},
                                  style: FilledButton.styleFrom(
                                      backgroundColor: primary),
                                  child: const Text('Save Route'))
                            ]),
                          ]))),
            ],
          ),
        ),
      ],
    );
  }
}
