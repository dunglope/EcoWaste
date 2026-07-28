# EcoWaste GIS Solutions Flutter App

Desktop-style Flutter prototype based on the provided EcoWaste GIS site maps and screen references.

## Implemented

- Fixed Material 3 admin shell with left navigation, top app bar, and status bar.
- Main sitemap screens:
  - Dashboard
  - Collection Requests
  - Collection Routes
  - Waste Transfer Stations
  - Field Incident Reports
  - Fleet Management
  - Personnel & Shift Management
  - KPI Reports
  - Spatial Analysis Map
- System Administration screens:
  - General
  - Users
  - Roles
  - Permissions
  - Map Services
  - Fleet Configuration
  - Notifications
  - Security
  - Database
  - Backup & Restore
  - Audit Logs
  - API Integration

## Run

```bash
dart pub get
flutter run -d chrome
```

## Verification

```bash
dart analyze
```

The app uses built-in Material widgets only. Map areas are styled GIS mock panels, so no API keys are required.

## Structure

- `lib/main.dart` starts the app.
- `lib/app/` contains app theme and root `MaterialApp`.
- `lib/models/` contains navigation enums and menu metadata.
- `lib/shell/` contains the fixed sidebar, top bar, status bar, and admin shell.
- `lib/routing/` maps selected navigation items to pages.
- `lib/shared/` contains reusable cards, KPI widgets, tables, map mockups, and form helpers.
- `lib/pages/` contains feature pages grouped by sitemap area.
