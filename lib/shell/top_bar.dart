import 'package:flutter/material.dart';

import '../app/theme.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 72,
      decoration: const BoxDecoration(
        color: background,
        border: Border(bottom: BorderSide(color: border)),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Row(
          children: [
            SizedBox(
              width: 360,
              child: SearchBar(
                elevation: const WidgetStatePropertyAll(0),
                backgroundColor: const WidgetStatePropertyAll(background),
                shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: const BorderSide(color: Color(0xFF7A8478)))),
                leading: const Icon(Icons.search_rounded),
                hintText: 'Search resources, locations, or IDs...',
                padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 14)),
              ),
            ),
            const Spacer(),
            Badge(
              smallSize: 8,
              backgroundColor: alert,
              child: IconButton(
                  onPressed: () {},
                  icon: const Icon(Icons.notifications_none_rounded)),
            ),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.help_outline_rounded)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.language_rounded)),
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.dark_mode_outlined)),
            const SizedBox(width: 12),
            const VerticalDivider(indent: 18, endIndent: 18),
            const SizedBox(width: 12),
            FilledButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add_rounded),
              label: const Text('New Report'),
              style: FilledButton.styleFrom(
                  backgroundColor: primary,
                  minimumSize: const Size(124, 42),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8))),
            ),
            const SizedBox(width: 20),
            const CircleAvatar(
                radius: 19,
                backgroundColor: Color(0xFFDDE8E1),
                child: Icon(Icons.eco_rounded, color: primary)),
          ],
        ),
      ),
    );
  }
}
