import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../shared/widgets.dart';

class GeneralPage extends StatelessWidget {
  const GeneralPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'General Settings',
        subtitle: 'Manage system preferences.',
        children: [
          const Row(children: [
            KpiCard(
                title: 'CPU Usage',
                value: '24%',
                trend: 'Good',
                icon: Icons.memory_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Database Health',
                value: 'Healthy',
                trend: '100% Uptime',
                icon: Icons.storage_rounded),
            SizedBox(width: 16),
            KpiCard(
                title: 'Storage',
                value: '87% full',
                trend: '',
                icon: Icons.inventory_2_rounded,
                warning: true)
          ]),
          const SizedBox(height: 24),
          SettingsForm(title: 'Platform Preferences', fields: const [
            'System Name|EcoSmart Waste',
            'Organization Name|City Municipality Services',
            'Language|English (US)',
            'Timezone|UTC -05:00 (Eastern Time)'
          ]),
        ],
      );
}

class SettingsForm extends StatelessWidget {
  const SettingsForm({super.key, required this.title, required this.fields});
  final String title;
  final List<String> fields;
  @override
  Widget build(BuildContext context) => AppCard(
      padding: EdgeInsets.zero,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
            padding: const EdgeInsets.all(16),
            child: Text(title, style: Theme.of(context).textTheme.titleLarge)),
        const Divider(height: 1),
        Padding(
            padding: const EdgeInsets.all(24),
            child: Wrap(
                spacing: 24,
                runSpacing: 20,
                children: fields.map((f) {
                  final p = f.split('|');
                  return SizedBox(
                      width: 280,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [formLabel(p[0]), fakeField(p[1])]));
                }).toList())),
        Container(
            padding: const EdgeInsets.all(16),
            color: const Color(0xFFF2F3ED),
            child: Row(mainAxisAlignment: MainAxisAlignment.end, children: [
              OutlinedButton(onPressed: () {}, child: const Text('Discard')),
              const SizedBox(width: 12),
              FilledButton(
                  onPressed: () {},
                  style: FilledButton.styleFrom(backgroundColor: primary),
                  child: const Text('Save Changes'))
            ])),
      ]));
}

class UsersPage extends StatelessWidget {
  const UsersPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'User Management',
          subtitle: 'Manage system users, roles, and access levels.',
          actions: [
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.person_add_rounded),
                label: const Text('Add User'),
                style: FilledButton.styleFrom(backgroundColor: primary))
          ],
          children: [
            AppCard(
                child: Row(children: const [
              Expanded(
                  child: SearchBar(
                      hintText: 'Search users by name or email...',
                      leading: Icon(Icons.search_rounded))),
              SizedBox(width: 16),
              ChipPill('Driver'),
              ChipPill('Admin')
            ])),
            const SizedBox(height: 24),
            DataTableCard(
                columns: const [
                  'Avatar',
                  'Full Name',
                  'Email',
                  'Role',
                  'Department'
                ],
                rows: [
                  tableRow([
                    'SJ',
                    'Sarah Jenkins',
                    's.jenkins@eco.gov',
                    'Admin',
                    'IT Systems'
                  ]),
                  tableRow([
                    'DC',
                    'David Chen',
                    'd.chen@eco.gov',
                    'Driver',
                    'Fleet Operations'
                  ]),
                  tableRow([
                    'MJ',
                    'Marcus Johnson',
                    'm.johnson@eco.gov',
                    'Driver',
                    'Fleet Operations'
                  ]),
                  tableRow([
                    'ER',
                    'Elena Rodriguez',
                    'e.rodriguez@eco.gov',
                    'Driver',
                    'Fleet Operations'
                  ])
                ],
                footer: const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text(
                        'Rows per page: 10                                      1-4 of 48'))),
          ]);
}

class RolesPage extends StatelessWidget {
  const RolesPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Role Management',
          subtitle: 'Define and manage organizational roles.',
          children: [
            Wrap(spacing: 24, runSpacing: 24, children: const [
              RoleCard(
                  title: 'Admin',
                  icon: Icons.admin_panel_settings_rounded,
                  users: '',
                  desc:
                      'Full access to all system features, including user management, global settings, and sensitive data access.',
                  permission: 'Full Access'),
              RoleCard(
                  title: 'Driver',
                  icon: Icons.groups_rounded,
                  users: '5 Users',
                  desc:
                      'Specific access to HR functions related to field staff, shift assignments and compliance tracking.',
                  permission: 'HR Limited'),
              RoleCard(
                  title: 'Dispatcher',
                  icon: Icons.support_agent_rounded,
                  users: '12 Users',
                  desc:
                      'Manage collection requests, route assignment, incidents, and live operational queues.',
                  permission: 'Operations'),
            ]),
          ]);
}

class RoleCard extends StatelessWidget {
  const RoleCard(
      {super.key,
      required this.title,
      required this.icon,
      required this.users,
      required this.desc,
      required this.permission});
  final String title;
  final IconData icon;
  final String users;
  final String desc;
  final String permission;
  @override
  Widget build(BuildContext context) => AppCard(
      width: 210,
      height: 330,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(children: [
          CircleAvatar(
              backgroundColor: primary, child: Icon(icon, color: Colors.white)),
          const SizedBox(width: 8),
          Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 22, fontWeight: FontWeight.w800))),
          if (users.isNotEmpty) ChipPill(users)
        ]),
        const SizedBox(height: 20),
        Text(desc),
        const Spacer(),
        AppCard(
            tint: const Color(0xFFF2F3ED),
            padding: const EdgeInsets.all(10),
            child: Text('PERMISSIONS\n$permission',
                style: const TextStyle(fontWeight: FontWeight.w800))),
        const SizedBox(height: 16),
        Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.edit_rounded),
                label: const Text('Edit Role')))
      ]));
}

class PermissionsPage extends StatelessWidget {
  const PermissionsPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Permissions',
          subtitle: 'Configure granular access control for system modules.',
          children: [
            DataTableCard(
                columns: const [
                  'System Modules',
                  'Admin',
                  'Viewer'
                ],
                rows: [
                  [
                    const Text('Dashboard',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Checkbox(value: true, onChanged: null),
                    const Checkbox(value: true, onChanged: null)
                  ],
                  [
                    const Text('Collection Management',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Checkbox(value: true, onChanged: null),
                    const Checkbox(value: true, onChanged: null)
                  ],
                  [
                    const Text('Spatial Infrastructure',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Checkbox(value: true, onChanged: null),
                    const Checkbox(value: false, onChanged: null)
                  ],
                  [
                    const Text('Reports & Analytics',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Checkbox(value: true, onChanged: null),
                    const Checkbox(value: false, onChanged: null)
                  ],
                  [
                    const Text('Audit Logs',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    const Checkbox(value: true, onChanged: null),
                    const Checkbox(value: false, onChanged: null)
                  ],
                ],
                footer: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          OutlinedButton(
                              onPressed: () {},
                              child: const Text('Reset to Default')),
                          const SizedBox(width: 12),
                          FilledButton(
                              onPressed: () {},
                              style: FilledButton.styleFrom(
                                  backgroundColor: primary),
                              child: const Text('Save Permissions'))
                        ]))),
          ]);
}

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

class FleetConfigPage extends StatelessWidget {
  const FleetConfigPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Fleet Configuration',
          subtitle: 'Global parameters for vehicle management.',
          children: [
            Wrap(spacing: 24, runSpacing: 24, children: const [
              ConfigPanel('Vehicle Classes', Icons.directions_car_rounded, [
                'Heavy - 26000 kg',
                'Hookloader - 32000 kg',
                'Van - 3500 kg'
              ]),
              ConfigPanel('Maintenance', Icons.build_rounded, [
                'Standard Maintenance Interval 15,000 km',
                'Warning distance 1000 km',
                'Critical overdue 500 km'
              ]),
              ConfigPanel('Fuel Management', Icons.local_gas_station_rounded, [
                'Primary Fuel Diesel',
                'Secondary Fuel None',
                'Low Fuel Warning 15%'
              ]),
              ConfigPanel('GPS Telemetry', Icons.satellite_alt_rounded, [
                'Ping Frequency 10s',
                'Detailed Route History 90 Days',
                'Aggregated Metrics Indefinite'
              ]),
            ]),
          ]);
}

class ConfigPanel extends StatelessWidget {
  const ConfigPanel(this.title, this.icon, this.lines, {super.key});
  final String title;
  final IconData icon;
  final List<String> lines;
  @override
  Widget build(BuildContext context) => AppCard(
      width: 304,
      height: 250,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        SectionTitle(title, icon: icon),
        const Divider(height: 24),
        for (final l in lines)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 9), child: Text(l)),
        const Spacer(),
        Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add_rounded),
                label: const Text('Add')))
      ]));
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Notifications',
          subtitle: 'Configure system-wide alert and reporting preferences.',
          actions: [
            FilledButton(
                onPressed: () {},
                style: FilledButton.styleFrom(backgroundColor: primary),
                child: const Text('Save Changes'))
          ],
          children: [
            AppCard(
                padding: EdgeInsets.zero,
                child: Column(children: const [
                  SwitchRow('Emergency Broadcast (SMS/Push)',
                      'Critical alerts requiring immediate attention.', true),
                  SwitchRow(
                      'Route Deviation Alerts',
                      'Notifications when vehicles stray from planned paths.',
                      true),
                  SwitchRow(
                      'Maintenance Reminders',
                      'Scheduled upkeep and service warnings for fleet.',
                      false),
                  SwitchRow(
                      'System Health Warnings',
                      'Alerts regarding database sync or GPS connectivity issues.',
                      true),
                  SwitchRow(
                      'Daily Operational Summaries',
                      'End-of-day reports on collection metrics and incidents.',
                      false),
                  SwitchRow(
                      'API Connection Alerts',
                      'Notifications on third-party integration statuses.',
                      true),
                ])),
          ]);
}

class SwitchRow extends StatelessWidget {
  const SwitchRow(this.title, this.desc, this.value, {super.key});
  final String title;
  final String desc;
  final bool value;
  @override
  Widget build(BuildContext context) => Container(
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: border))),
      child: Row(children: [
        Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Text(desc, style: const TextStyle(color: textMuted))
        ])),
        Switch(value: value, onChanged: (_) {})
      ]));
}

class SecurityPage extends StatelessWidget {
  const SecurityPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Security',
          subtitle:
              'Manage authentication, session policies, and IP restrictions.',
          actions: [
            FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.save_rounded),
                label: const Text('Save Changes'),
                style: FilledButton.styleFrom(backgroundColor: primary))
          ],
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: const [
              Expanded(
                  child: ConfigPanel(
                      'Password Policy', Icons.password_rounded, [
                'Minimum Complexity enabled',
                'Expiration Policy every 90 days'
              ])),
              SizedBox(width: 24),
              Expanded(
                  child: ConfigPanel('Two-Factor Authentication',
                      Icons.verified_user_rounded, [
                'Authenticator App recommended default',
                'SMS Verification optional'
              ])),
              SizedBox(width: 24),
              Expanded(
                  child: ConfigPanel('Session Management', Icons.timer_rounded,
                      ['Idle Timeout 15 minutes', 'Concurrent Login Limit 1'])),
            ]),
            const SizedBox(height: 24),
            DataTableCard(title: 'IP Whitelisting', columns: const [
              'IP Range / Address',
              'Department',
              'Description',
              'Status'
            ], rows: [
              tableRow([
                '192.168.1.0/24',
                'HQ Operations',
                'Main Office Internal Network',
                'Active'
              ]),
              tableRow([
                '10.0.50.0/28',
                'Dispatch Hub',
                'Fleet Management Center',
                'Active'
              ]),
              tableRow([
                '203.0.113.45/32',
                'External Auditors',
                'Temporary audit access',
                'Inactive'
              ])
            ]),
          ]);
}

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

class BackupPage extends StatelessWidget {
  const BackupPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Backup & Restore',
          subtitle: 'Manage system backups and disaster recovery.',
          children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              const Expanded(
                  child: AppCard(
                      height: 220,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SectionTitle('System Health: Optimal',
                                icon: Icons.cloud_done_rounded),
                            Spacer(),
                            Row(children: [
                              Expanded(
                                  child: MetricLine(
                                      'Last Backup', 'Today, 02:00 AM')),
                              Expanded(
                                  child: MetricLine('Total Size', '42.8 GB')),
                              Expanded(
                                  child: MetricLine(
                                      'Next Schedule', 'Tomorrow 02:00 AM'))
                            ])
                          ]))),
              const SizedBox(width: 24),
              SizedBox(
                  width: 190,
                  child: AppCard(
                      height: 220,
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text('Actions',
                                style: TextStyle(fontWeight: FontWeight.w800)),
                            const Spacer(),
                            FilledButton(
                                onPressed: () {},
                                style: FilledButton.styleFrom(
                                    backgroundColor: primary),
                                child: const Text('Backup Now')),
                            OutlinedButton(
                                onPressed: () {},
                                child: const Text('Restore from Point')),
                            TextButton(
                                onPressed: () {},
                                child: const Text('Download Archive'))
                          ]))),
            ]),
            const SizedBox(height: 24),
            DataTableCard(title: 'Recent Backups', columns: const [
              'Timestamp',
              'Type',
              'Size',
              'Integrity Check',
              'Action'
            ], rows: [
              tableRow([
                '2023-10-27 02:00:00',
                'Automated',
                '42.8 GB',
                'Verified',
                ''
              ]),
              tableRow(
                  ['2023-10-26 14:30:22', 'Manual', '42.7 GB', 'Verified', '']),
              tableRow([
                '2023-10-25 02:00:00',
                'Automated',
                '42.4 GB',
                'Archived',
                ''
              ])
            ]),
          ]);
}

class AuditPage extends StatelessWidget {
  const AuditPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'Audit Logs',
          subtitle: 'Track all system changes and user activities.',
          actions: [
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.download_rounded),
                label: const Text('Export CSV')),
            OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.picture_as_pdf_rounded),
                label: const Text('Export PDF'))
          ],
          children: [
            AppCard(
                child: Wrap(spacing: 18, runSpacing: 12, children: const [
              ChipPill('Last 7 Days'),
              ChipPill('All Users'),
              ChipPill('All Modules'),
              ChipPill('All Actions'),
              ChipPill('Clear Filters', active: true)
            ])),
            const SizedBox(height: 24),
            DataTableCard(columns: const [
              'Timestamp',
              'User',
              'Action',
              'Module',
              'IP Address',
              'Status'
            ], rows: [
              tableRow([
                '2026-07-27 10:44',
                'Sarah Jenkins',
                'Updated role',
                'Roles',
                '10.0.50.4',
                'Success'
              ]),
              tableRow([
                '2026-07-27 09:18',
                'David Chen',
                'Exported fleet',
                'Fleet',
                '10.0.50.9',
                'Success'
              ]),
              tableRow([
                '2026-07-26 17:55',
                'System',
                'Backup completed',
                'Backup',
                '127.0.0.1',
                'Success'
              ])
            ]),
          ]);
}

class ApiPage extends StatelessWidget {
  const ApiPage({super.key});
  @override
  Widget build(BuildContext context) => PageScaffold(
          title: 'API Integration',
          subtitle: 'Manage external service connections and webhooks.',
          children: [
            Wrap(spacing: 24, runSpacing: 24, children: const [
              IntegrationCard('Google Maps Platform', Icons.map_rounded,
                  'Connected', 'Monthly Usage 42,500 / 100,000 reqs'),
              IntegrationCard(
                  'Firebase Messaging',
                  Icons.notifications_active_rounded,
                  'Connected',
                  'Messages Sent (30d) 1.2M'),
              IntegrationCard('Enterprise ERP', Icons.table_view_rounded,
                  'Pending Sync', 'Last Sync Attempt Today, 14:15 - Timeout',
                  danger: true),
              IntegrationCard('Custom Webhooks', Icons.webhook_rounded,
                  '3 Active', 'Events Processed (24h) 4,892'),
            ]),
          ]);
}

class IntegrationCard extends StatelessWidget {
  const IntegrationCard(this.title, this.icon, this.status, this.detail,
      {super.key, this.danger = false});
  final String title;
  final IconData icon;
  final String status;
  final String detail;
  final bool danger;
  @override
  Widget build(BuildContext context) => Container(
        width: 304,
        height: 230,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          border: Border(
            left: BorderSide(
                color: danger ? const Color(0xFFE58BB0) : primary, width: 4),
            top: const BorderSide(color: border),
            right: const BorderSide(color: border),
            bottom: const BorderSide(color: border),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                    backgroundColor: background,
                    child: Icon(icon, color: primary)),
                const SizedBox(width: 12),
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800))),
                OutlinedButton(
                    onPressed: () {}, child: const Text('Configure')),
              ],
            ),
            Text(
              '● $status',
              style: TextStyle(
                  color: danger
                      ? const Color(0xFFD95C91)
                      : const Color(0xFF2E6735),
                  fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: 18),
            const AppCard(
              tint: Color(0xFFF2F3ED),
              padding: EdgeInsets.all(10),
              child: Text(
                  'ENDPOINT        ****************\nAPI KEY         AlzaSyB...9XqQ'),
            ),
            const Spacer(),
            Text(detail),
          ],
        ),
      );
}
