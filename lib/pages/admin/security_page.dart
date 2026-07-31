import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'fleet_config_page.dart';

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
