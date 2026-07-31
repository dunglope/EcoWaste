import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

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
