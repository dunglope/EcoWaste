import 'package:flutter/material.dart';

import '../../shared/widgets.dart';
import 'general_page.dart';

class MapServicesPage extends StatelessWidget {
  const MapServicesPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Map Services',
          subtitle: 'Configure GIS providers and layer settings.',
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Expanded(
                  child: Column(children: [
                SettingsForm(title: 'Provider Settings', fields: const [
                  'Base Map Provider|Google Maps',
                  'API Key|**********************'
                ]),
                const SizedBox(height: 24),
                SettingsForm(title: 'Default View', fields: const [
                  'Center Latitude|37.7749',
                  'Center Longitude|-122.4194',
                  'Default Zoom Level|12'
                ])
              ])),
              const SizedBox(width: 24),
              SizedBox(
                  width: 250,
                  child: AppCard(
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                        SectionTitle('Active Layers',
                            icon: Icons.layers_rounded),
                        CheckboxListTile(
                            value: true,
                            onChanged: null,
                            title: Text('Traffic Data')),
                        CheckboxListTile(
                            value: false,
                            onChanged: null,
                            title: Text('Satellite Imagery')),
                        CheckboxListTile(
                            value: true,
                            onChanged: null,
                            title: Text('Waste Heatmap')),
                        CheckboxListTile(
                            value: true,
                            onChanged: null,
                            title: Text('Coordinate Inspector'))
                      ]))),
            ]),
          ]);
}
