import 'package:flutter/material.dart';

import '../app/theme.dart';
import '../models/navigation.dart';

class SettingsRail extends StatelessWidget {
  const SettingsRail({
    super.key,
    required this.selected,
    required this.collapsed,
    required this.onToggleCollapsed,
    required this.onSelect,
  });
  final PageKey selected;
  final bool collapsed;
  final VoidCallback onToggleCollapsed;
  final ValueChanged<PageKey> onSelect;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      curve: Curves.easeOut,
      width: collapsed ? 76 : 320,
      decoration: const BoxDecoration(
        color: background,
        border: Border(right: BorderSide(color: border)),
      ),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(collapsed ? 16 : 48, 20, 16, 20),
            child: Row(
              children: [
                if (!collapsed)
                  const Expanded(
                      child: Text('Configuration',
                          style: TextStyle(fontWeight: FontWeight.w800))),
                IconButton(
                  tooltip: collapsed
                      ? 'Expand configuration'
                      : 'Collapse configuration',
                  onPressed: onToggleCollapsed,
                  icon: Icon(collapsed
                      ? Icons.chevron_right_rounded
                      : Icons.chevron_left_rounded),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              itemCount: adminItems.length,
              itemBuilder: (context, index) {
                final item = adminItems[index];
                final active = item.key == selected;
                return Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 3, horizontal: 16),
                  child: Material(
                    color: active ? primarySoft : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    child: InkWell(
                      onTap: () => onSelect(item.key),
                      borderRadius: BorderRadius.circular(12),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 13),
                        child: Row(
                          children: [
                            Icon(item.icon,
                                color: active
                                    ? const Color(0xFF2E7D43)
                                    : textMuted),
                            if (!collapsed) ...[
                              const SizedBox(width: 14),
                              Expanded(
                                child: Text(item.label,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        fontWeight: FontWeight.w700,
                                        color: active
                                            ? const Color(0xFF2E7D43)
                                            : textMuted)),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
