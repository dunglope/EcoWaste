import 'package:flutter/material.dart';

import '../models/navigation.dart';
import '../routing/content_host.dart';
import 'main_drawer.dart';
import 'settings_rail.dart';
import 'status_bar.dart';
import 'top_bar.dart';

class AdminShell extends StatefulWidget {
  const AdminShell({super.key});

  @override
  State<AdminShell> createState() => _AdminShellState();
}

class _AdminShellState extends State<AdminShell> {
  PageKey selected = PageKey.dashboard;
  bool configurationCollapsed = false;

  bool get isAdmin => adminItems.any((item) => item.key == selected);

  void select(PageKey key) => setState(() => selected = key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          MainDrawer(selected: selected, onSelect: select),
          if (isAdmin)
            SettingsRail(
              selected: selected,
              collapsed: configurationCollapsed,
              onToggleCollapsed: () => setState(
                  () => configurationCollapsed = !configurationCollapsed),
              onSelect: select,
            ),
          Expanded(
            child: Column(
              children: [
                const TopBar(),
                Expanded(child: ContentHost(selected: selected)),
                const StatusBar(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
