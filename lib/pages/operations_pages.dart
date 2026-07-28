import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../shared/widgets.dart';

class CollectionRequestsPage extends StatelessWidget {
  const CollectionRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Collection Requests',
      breadcrumb: 'Collection Management › Collection Requests',
      actions: [
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh')),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export Excel')),
        FilledButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('New Collection Request'),
            style: FilledButton.styleFrom(backgroundColor: primary)),
      ],
      children: [
        const Row(children: [
          KpiCard(
              title: 'Pending Requests',
              value: '124',
              trend: '↗ +5%',
              icon: Icons.pending_actions_rounded),
          SizedBox(width: 18),
          KpiCard(
              title: 'Approved Today',
              value: '42',
              trend: 'vs 38 yesterday',
              icon: Icons.check_circle_outline_rounded),
          SizedBox(width: 18),
          KpiCard(
              title: 'In Progress',
              value: '18',
              trend: 'Active routes',
              icon: Icons.local_shipping_rounded),
          SizedBox(width: 18),
          KpiCard(
              title: 'Emergency Requests',
              value: '3',
              trend: 'Action required',
              icon: Icons.warning_rounded,
              warning: true),
        ]),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: const [
                Icon(Icons.filter_list_rounded),
                ChipPill('Status'),
                ChipPill('Pending ×', active: true),
                ChipPill('Approved'),
                ChipPill('Priority'),
                ChipPill('Emergency', danger: true),
                ChipPill('Category'),
                ChipPill('Clear All'),
              ]),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: DataTableCard(
                columns: const [
                  '',
                  'ID',
                  'Citizen Name',
                  'Category',
                  'Priority',
                  'Address / District',
                  'Status'
                ],
                rows: [
                  tableRow([
                    '✓',
                    'REQ-2024-081',
                    'Maria Gonzalez',
                    'Bulk Organic',
                    'High',
                    '142 Oak Street\nWestside District',
                    'Pending'
                  ], selected: true),
                  tableRow([
                    '',
                    'REQ-2024-082',
                    'John Smith',
                    'Recyclable',
                    'Low',
                    '88 Pine Ave\nDowntown',
                    'Assigned'
                  ]),
                  tableRow([
                    '',
                    'REQ-2024-083',
                    'City Parks Dept',
                    'Green Waste',
                    'Medium',
                    'Central Park North Gate\nNorth District',
                    'Approved'
                  ]),
                ],
                footer: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('Showing 1 to 10 of 124 requests')),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(flex: 3, child: RequestDetailCard()),
          ],
        ),
      ],
    );
  }
}

class RequestDetailCard extends StatelessWidget {
  const RequestDetailCard({super.key});
  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: const [
              Expanded(
                  child: Text('REQ-2024-081\nSubmitted 2 hours ago',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800))),
              Icon(Icons.more_vert_rounded),
              Icon(Icons.close_rounded)
            ]),
          ),
          Container(
              height: 180,
              color: const Color(0xFFD9E3D2),
              child: const Center(
                  child:
                      Icon(Icons.image_rounded, size: 56, color: textMuted))),
          const Padding(
            padding: EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ChipPill('HIGH PRIORITY', danger: true),
              SizedBox(height: 16),
              SectionTitle('Location Data', icon: Icons.location_on_outlined),
              SizedBox(height: 8),
              FakeMap(height: 120, label: ''),
              SizedBox(height: 16),
              Text(
                  'Maria Gonzalez • (555) 018-4201\nBulk organic waste, estimated 2.4 m³\n142 Oak Street, Westside District'),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FilledButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.group_add_rounded),
                    label: const Text('Assign Driver'),
                    style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size.fromHeight(42))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Approve'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Reject')))
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

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

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  void _showReportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const ReportIncidentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Field Incident Reports',
        subtitle:
            'Real-time monitoring and management of infrastructure anomalies.',
        actions: [
          FilledButton.icon(
            onPressed: () => _showReportDialog(context),
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text('Report New Incident'),
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              minimumSize: const Size(190, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
          )
        ],
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Text('Status:', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 10),
                ChipPill('All', active: true),
                SizedBox(width: 8),
                ChipPill('Open'),
                SizedBox(width: 8),
                ChipPill('In Progress'),
                SizedBox(width: 8),
                ChipPill('Resolved'),
                SizedBox(width: 26),
                Text('Priority:',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 10),
                ChipPill('Emergency', danger: true),
                SizedBox(width: 8),
                ChipPill('High'),
                Spacer(),
                SizedBox(
                  width: 260,
                  child: SearchBar(
                    hintText: 'Filter by ID or reporter...',
                    leading: Icon(Icons.filter_list_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(flex: 7, child: IncidentReportTable()),
              SizedBox(width: 16),
              SizedBox(width: 250, child: IncidentClusterPreview()),
            ],
          ),
        ],
      );
}

class IncidentReportTable extends StatelessWidget {
  const IncidentReportTable({super.key});

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.9),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.1),
                5: FlexColumnWidth(1.1),
                6: FlexColumnWidth(.9),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color(0xFFEAEDE6),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  children: [
                    IncidentHeader('ID'),
                    IncidentHeader('Type'),
                    IncidentHeader('Priority'),
                    IncidentHeader('Reported By'),
                    IncidentHeader('Location'),
                    IncidentHeader('Status'),
                    IncidentHeader('Actions'),
                  ],
                ),
                _incidentRow(
                  id: '#INC-4029',
                  icon: Icons.delete_outline_rounded,
                  type: 'Overflow',
                  priority: const ChipPill('Emergency', danger: true),
                  reporter: 'John Doe\nField Agent 4',
                  location: '40.7128° N\n74.0060° W',
                  status: 'Open',
                ),
                _incidentRow(
                  id: '#INC-4028',
                  icon: Icons.handyman_rounded,
                  type: 'Damage',
                  priority: const ChipPill('High'),
                  reporter: 'Sensor #0921\nAutomated Alert',
                  location: '34.0522° N\n118.2437° W',
                  status: 'In Progress',
                ),
                _incidentRow(
                  id: '#INC-4027',
                  icon: Icons.event_busy_rounded,
                  type: 'Missed Collection',
                  priority: const ChipPill('Low'),
                  reporter: 'Citizen Portal\nExternal Report',
                  location: '51.5074° N\n0.1278° W',
                  status: 'Resolved',
                ),
              ],
            ),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(color: Color(0xFFEAEDE6)),
              child: const Row(
                children: [
                  Text('Showing 1-12 of 248 incidents'),
                  Spacer(),
                  Icon(Icons.chevron_left_rounded),
                  SizedBox(width: 16),
                  Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ],
        ),
      );

  static TableRow _incidentRow({
    required String id,
    required IconData icon,
    required String type,
    required Widget priority,
    required String reporter,
    required String location,
    required String status,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EBE3))),
      ),
      children: [
        IncidentCell(Text(id,
            style:
                const TextStyle(color: primary, fontWeight: FontWeight.w900))),
        IncidentCell(Row(children: [
          Icon(icon, size: 18, color: const Color(0xFF346B3B)),
          const SizedBox(width: 8),
          Flexible(
              child: Text(type,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
        ])),
        IncidentCell(Align(alignment: Alignment.centerLeft, child: priority)),
        IncidentCell(Text(reporter)),
        IncidentCell(Text(location)),
        IncidentCell(Row(children: [
          Icon(Icons.circle,
              size: 8, color: status == 'Resolved' ? textMuted : primary),
          const SizedBox(width: 6),
          Flexible(child: Text(status)),
        ])),
        const IncidentCell(Icon(Icons.more_horiz_rounded)),
      ],
    );
  }
}

class IncidentHeader extends StatelessWidget {
  const IncidentHeader(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11, color: textMuted, fontWeight: FontWeight.w900)),
      );
}

class IncidentCell extends StatelessWidget {
  const IncidentCell(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12, color: Color(0xFF1D241B)),
          child: child,
        ),
      );
}

class IncidentClusterPreview extends StatelessWidget {
  const IncidentClusterPreview({super.key});

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.radar_rounded, size: 18, color: primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Cluster\nPreview',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                  Text('Expand Full\nMap',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10, color: textMuted)),
                ],
              ),
            ),
            Stack(
              children: const [
                FakeMap(height: 440, label: ''),
                Positioned(
                  right: 8,
                  top: 8,
                  child: MapControls(vertical: true),
                ),
                Positioned(
                  left: 100,
                  top: 210,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: alert,
                    child: Text('!', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  MetricLine('Emergencies in View', '4'),
                  MetricLine('Active Crews nearby', '12'),
                ],
              ),
            )
          ],
        ),
      );
}

class ReportIncidentDialog extends StatelessWidget {
  const ReportIncidentDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(22, 18, 12, 14),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Report New Incident',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              color: primary)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(22),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel('Incident Type'),
                    fakeField('Overflow'),
                    formLabel('Severity Level'),
                    const Wrap(
                      spacing: 8,
                      children: [
                        ChipPill('Emergency'),
                        ChipPill('High'),
                        ChipPill('Medium', active: true),
                        ChipPill('Low'),
                      ],
                    ),
                    formLabel('Description'),
                    Container(
                      height: 100,
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE5E9E0),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Provide details about the incident...',
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ),
                    formLabel('Evidence'),
                    Container(
                      height: 92,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                            color: const Color(0xFFB8C2B3),
                            style: BorderStyle.solid),
                      ),
                      child: const Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.cloud_upload_outlined, color: primary),
                            SizedBox(height: 8),
                            Text('Upload photos or videos',
                                style: TextStyle(fontSize: 12)),
                          ],
                        ),
                      ),
                    ),
                    formLabel('Location'),
                    Row(
                      children: [
                        Expanded(child: fakeField('40.7128° N, 74.0060° W')),
                        const SizedBox(width: 12),
                        TextButton.icon(
                            onPressed: () {},
                            icon: const Icon(Icons.my_location_rounded),
                            label: const Text('Choose')),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: Color(0xFFF2F3ED)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel')),
                    const SizedBox(width: 16),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(backgroundColor: primary),
                      child: const Text('Submit Report'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
