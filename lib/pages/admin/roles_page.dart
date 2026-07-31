import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

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
