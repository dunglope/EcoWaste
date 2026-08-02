import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

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
                  'Driver'
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
