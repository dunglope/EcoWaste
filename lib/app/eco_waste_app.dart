import 'package:flutter/material.dart';

import '../shell/admin_shell.dart';
import 'theme.dart';

class EcoWasteApp extends StatelessWidget {
  const EcoWasteApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'EcoWaste GIS Solutions',
      theme: buildEcoWasteTheme(),
      home: const AdminShell(),
    );
  }
}
