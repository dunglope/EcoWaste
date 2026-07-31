import 'package:flutter/material.dart';

import '../models/navigation.dart';
import '../pages/admin_pages.dart';
import '../pages/dashboard_page.dart';
import '../pages/operations/collection_requests_page.dart'
    as collection_requests_page;
import '../pages/operations/incidents_page.dart' as incidents_page;
import '../pages/operations/routes_page.dart' as routes_page;
import '../pages/operations/transfer_stations_page.dart'
    as transfer_station_page;
import '../pages/report_pages.dart';
import '../pages/resource_pages.dart';

class ContentHost extends StatelessWidget {
  const ContentHost({super.key, required this.selected});
  final PageKey selected;

  @override
  Widget build(BuildContext context) {
    return switch (selected) {
      PageKey.dashboard => const DashboardPage(),
      PageKey.collectionRequests =>
        const collection_requests_page.CollectionRequestsPage(),
      PageKey.routes => const routes_page.RoutesPage(),
      PageKey.transferStations =>
        const transfer_station_page.TransferStationsPage(),
      PageKey.incidents => const incidents_page.IncidentsPage(),
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
