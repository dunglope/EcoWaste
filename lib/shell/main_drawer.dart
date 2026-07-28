import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/navigation.dart';

class MainDrawer extends StatelessWidget {
  const MainDrawer({super.key, required this.selected, required this.onSelect});

  final PageKey selected;
  final ValueChanged<PageKey> onSelect;

  @override
  Widget build(BuildContext context) {
    final adminActive = adminItems.any((item) => item.key == selected);
    return Container(
      width: 280,
      decoration: const BoxDecoration(
        color: Color(0xFFF5F7F0),
        border: Border(right: BorderSide(color: border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 26, 24, 18),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.eco_rounded, color: primary),
                ),
                const SizedBox(width: 12),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Eco Waste',
                        style: TextStyle(
                            color: primary,
                            fontSize: 22,
                            fontWeight: FontWeight.w800)),
                    Text('Admin',
                        style: TextStyle(fontSize: 13, color: textMuted)),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('Quick Request'),
              style: FilledButton.styleFrom(
                minimumSize: const Size.fromHeight(42),
                backgroundColor: primary,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24)),
              ),
            ),
          ),
          const SizedBox(height: 22),
          const Divider(height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.fromLTRB(12, 18, 0, 18),
              children: [
                DrawerButton(
                    item: const NavItem(PageKey.dashboard, 'Dashboard',
                        Icons.dashboard_rounded),
                    selected: selected == PageKey.dashboard,
                    onTap: onSelect),
                DrawerGroup(
                  title: 'Collection Management',
                  icon: Icons.assignment_rounded,
                  active: selected == PageKey.collectionRequests,
                  children: [
                    DrawerSubButton(
                        label: 'Collection Requests',
                        selected: selected == PageKey.collectionRequests,
                        onTap: () => onSelect(PageKey.collectionRequests)),
                  ],
                ),
                DrawerGroup(
                  title: 'Spatial Infrastructure',
                  icon: Icons.map_rounded,
                  active: selected == PageKey.routes ||
                      selected == PageKey.transferStations ||
                      selected == PageKey.incidents,
                  children: [
                    DrawerSubButton(
                        label: 'Collection Routes',
                        selected: selected == PageKey.routes,
                        onTap: () => onSelect(PageKey.routes)),
                    DrawerSubButton(
                        label: 'Waste Transfer Stations',
                        selected: selected == PageKey.transferStations,
                        onTap: () => onSelect(PageKey.transferStations)),
                    DrawerSubButton(
                        label: 'Field Incident Reports',
                        selected: selected == PageKey.incidents,
                        onTap: () => onSelect(PageKey.incidents)),
                  ],
                ),
                DrawerGroup(
                  title: 'Resource Management',
                  icon: Icons.local_shipping_rounded,
                  active: selected == PageKey.fleet ||
                      selected == PageKey.personnel,
                  children: [
                    DrawerSubButton(
                        label: 'Fleet Management',
                        selected: selected == PageKey.fleet,
                        onTap: () => onSelect(PageKey.fleet)),
                    DrawerSubButton(
                        label: 'Personnel & Shift Management',
                        selected: selected == PageKey.personnel,
                        onTap: () => onSelect(PageKey.personnel)),
                  ],
                ),
                DrawerGroup(
                  title: 'Reports & Analytics',
                  icon: Icons.analytics_rounded,
                  active:
                      selected == PageKey.kpi || selected == PageKey.spatial,
                  children: [
                    DrawerSubButton(
                        label: 'KPI Reports',
                        selected: selected == PageKey.kpi,
                        onTap: () => onSelect(PageKey.kpi)),
                    DrawerSubButton(
                        label: 'Spatial Analysis Map',
                        selected: selected == PageKey.spatial,
                        onTap: () => onSelect(PageKey.spatial)),
                  ],
                ),
                DrawerButton(
                  item: const NavItem(PageKey.general, 'System Administration',
                      Icons.settings_rounded),
                  selected: adminActive,
                  onTap: onSelect,
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 16, 0, 22),
            child: Column(
              children: [
                DrawerPlain(icon: Icons.help_outline_rounded, label: 'Support'),
                DrawerPlain(icon: Icons.logout_rounded, label: 'Sign Out'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DrawerButton extends StatelessWidget {
  const DrawerButton(
      {super.key,
      required this.item,
      required this.selected,
      required this.onTap});
  final NavItem item;
  final bool selected;
  final ValueChanged<PageKey> onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12, bottom: 6),
      child: Material(
        color: selected ? primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(22),
        child: InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () => onTap(item.key),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
            child: Row(
              children: [
                Icon(item.icon,
                    color: selected ? primary : textMuted, size: 23),
                const SizedBox(width: 16),
                Expanded(
                    child: Text(item.label,
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            color: selected ? primary : textMuted))),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DrawerGroup extends StatelessWidget {
  const DrawerGroup(
      {super.key,
      required this.title,
      required this.icon,
      required this.active,
      required this.children});
  final String title;
  final IconData icon;
  final bool active;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 13, 8, 10),
          child: Row(
            children: [
              Icon(icon, color: active ? primary : textMuted, size: 23),
              const SizedBox(width: 16),
              Expanded(
                  child: Text(title,
                      style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: active ? primary : textMuted))),
            ],
          ),
        ),
        ...children,
      ],
    );
  }
}

class DrawerSubButton extends StatelessWidget {
  const DrawerSubButton(
      {super.key,
      required this.label,
      required this.selected,
      required this.onTap});
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 36, right: 10, bottom: 4),
      child: Material(
        color: selected ? primarySoft : Colors.transparent,
        borderRadius: BorderRadius.circular(18),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
            child: Text(label,
                style: TextStyle(
                    fontSize: 13,
                    color: selected ? primary : textMuted,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w600)),
          ),
        ),
      ),
    );
  }
}

class DrawerPlain extends StatelessWidget {
  const DrawerPlain({super.key, required this.icon, required this.label});
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 13),
      child: Row(
        children: [
          Icon(icon, color: textMuted),
          const SizedBox(width: 16),
          Text(label,
              style: const TextStyle(
                  fontWeight: FontWeight.w700, color: textMuted)),
        ],
      ),
    );
  }
}
