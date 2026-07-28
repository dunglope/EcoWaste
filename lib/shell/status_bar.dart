import 'package:flutter/material.dart';

import '../app/theme.dart';

class StatusBar extends StatelessWidget {
  const StatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 28,
      decoration: const BoxDecoration(
        color: background,
        border: Border(top: BorderSide(color: border)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Row(
        children: const [
          Text('Database Online', style: TextStyle(fontSize: 12)),
          SizedBox(width: 18),
          Text('GPS Service Active', style: TextStyle(fontSize: 12)),
          SizedBox(width: 18),
          Text('API Healthy', style: TextStyle(fontSize: 12)),
          Spacer(),
          Text('© 2026 EcoWaste GIS Solutions • v1.0.0',
              style: TextStyle(fontSize: 12)),
          Spacer(),
          Text('Privacy Policy', style: TextStyle(fontSize: 12)),
          SizedBox(width: 18),
          Text('About', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
