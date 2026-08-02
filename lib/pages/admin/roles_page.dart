import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'roles/edit_role_dialog.dart';

class RolesPage extends StatefulWidget {
  const RolesPage({super.key});

  @override
  State<RolesPage> createState() => _RolesPageState();
}

class _RolesPageState extends State<RolesPage> {
  final List<_RoleEntry> _roles = [
    const _RoleEntry(
      icon: Icons.admin_panel_settings_rounded,
      users: '3 Users',
      configuration: RoleConfiguration(
        name: 'Admin',
        description:
            'Full access to all system features, including user management, global settings, and sensitive data access.',
        scope: 'Global',
        permissions: {
          'Waste Collection': ModulePermissions(
            view: true,
            edit: true,
            delete: true,
          ),
          'Spatial Analysis': ModulePermissions(
            view: true,
            edit: true,
            delete: true,
          ),
          'System Admin': ModulePermissions(
            view: true,
            edit: true,
            delete: true,
          ),
        },
      ),
    ),
    const _RoleEntry(
      icon: Icons.groups_rounded,
      users: '9 Users',
      configuration: RoleConfiguration(
        name: 'Driver',
        description:
            'Access to field operations, assigned collection routes, shift schedules, and compliance tasks.',
        scope: 'Regional',
        permissions: {
          'Waste Collection': ModulePermissions(view: true, edit: true),
          'Spatial Analysis': ModulePermissions(view: true),
          'System Admin': ModulePermissions(),
        },
      ),
    ),
  ];

  Future<void> _editRole(int index) async {
    final configuration = await showDialog<RoleConfiguration>(
      context: context,
      builder: (context) => EditRoleDialog(
        initial: _roles[index].configuration,
      ),
    );
    if (configuration == null || !mounted) return;
    setState(() {
      _roles[index] = _RoleEntry(
        icon: _roles[index].icon,
        users: _roles[index].users,
        configuration: configuration,
      );
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${configuration.name} role updated.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Role Management',
      subtitle: 'Define and manage organizational roles.',
      children: [
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: List.generate(_roles.length, (index) {
            final role = _roles[index];
            return RoleCard(
              role: role,
              onEdit: () => _editRole(index),
            );
          }),
        ),
      ],
    );
  }
}

class _RoleEntry {
  const _RoleEntry({
    required this.icon,
    required this.users,
    required this.configuration,
  });

  final IconData icon;
  final String users;
  final RoleConfiguration configuration;
}

class RoleCard extends StatelessWidget {
  const RoleCard({
    super.key,
    required this.role,
    required this.onEdit,
  });

  final _RoleEntry role;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    final config = role.configuration;
    return Container(
      width: 260,
      height: 340,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: primary,
                child: Icon(role.icon, color: Colors.white),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: Text(
                  config.name,
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              ChipPill(role.users),
            ],
          ),
          const SizedBox(height: 20),
          Text(config.description),
          const Spacer(),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF2F3ED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'PERMISSIONS',
                  style: TextStyle(
                    fontSize: 10,
                    color: textMuted,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  '${config.enabledPermissionCount} enabled · ${config.scope} scope',
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: onEdit,
              icon: const Icon(Icons.edit_rounded),
              label: const Text('Edit Role'),
            ),
          ),
        ],
      ),
    );
  }
}
