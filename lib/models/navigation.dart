import 'package:flutter/material.dart';

enum PageKey {
  dashboard,
  collectionRequests,
  routes,
  transferStations,
  incidents,
  fleet,
  personnel,
  kpi,
  spatial,
  general,
  users,
  roles,
  permissions,
  mapServices,
  fleetConfig,
  notifications,
  security,
  database,
  backup,
  audit,
  api,
}

class NavItem {
  const NavItem(this.key, this.label, this.icon);
  final PageKey key;
  final String label;
  final IconData icon;
}

const adminItems = [
  NavItem(PageKey.general, 'General', Icons.tune_rounded),
  NavItem(PageKey.users, 'Users', Icons.group_rounded),
  NavItem(PageKey.roles, 'Roles', Icons.badge_rounded),
  NavItem(PageKey.permissions, 'Permissions', Icons.key_rounded),
  NavItem(PageKey.mapServices, 'Map Services', Icons.layers_rounded),
  NavItem(
      PageKey.fleetConfig, 'Fleet Configuration', Icons.directions_car_rounded),
  NavItem(PageKey.notifications, 'Notifications', Icons.campaign_rounded),
  NavItem(PageKey.security, 'Security', Icons.shield_rounded),
  NavItem(PageKey.database, 'Database', Icons.storage_rounded),
  NavItem(PageKey.backup, 'Backup & Restore',
      Icons.settings_backup_restore_rounded),
  NavItem(PageKey.audit, 'Audit Logs', Icons.history_rounded),
  NavItem(PageKey.api, 'API Integration', Icons.webhook_rounded),
];
