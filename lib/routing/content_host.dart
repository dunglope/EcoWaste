import 'package:flutter/material.dart';

import '../models/navigation.dart';
import '../pages/admin_pages.dart';
import '../pages/dashboard_page.dart';
import '../pages/operations_pages.dart';
import '../pages/report_pages.dart';
import '../pages/resource_pages.dart';

class ContentHost extends StatelessWidget {
  const ContentHost({super.key, required this.selected});
  final PageKey selected;

  @override
  Widget build(BuildContext context) {
    return switch (selected) {
      PageKey.dashboard => const DashboardPage(),
      PageKey.collectionRequests => const CollectionRequestsPage(),
      PageKey.routes => const RoutesPage(),
      PageKey.transferStations => const TransferStationsPage(),
      PageKey.incidents => const IncidentsPage(),
      PageKey.fleet => const FleetPage(),
      PageKey.personnel => const PersonnelPage(),
      PageKey.kpi => const KpiPage(),
      PageKey.spatial => const SpatialAnalysisPage(),
      PageKey.general => const GeneralPage(),
      PageKey.users => const UsersPage(),
      PageKey.roles => const RolesPage(),
      PageKey.permissions => const PermissionsPage(),
      PageKey.mapServices => const MapServicesPage(),
      PageKey.fleetConfig => const FleetConfigPage(),
      PageKey.notifications => const NotificationsPage(),
      PageKey.security => const SecurityPage(),
      PageKey.database => const DatabasePage(),
      PageKey.backup => const BackupPage(),
      PageKey.audit => const AuditPage(),
      PageKey.api => const ApiPage(),
    };
  }
}
