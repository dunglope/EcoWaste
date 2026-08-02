import 'package:flutter/material.dart';

import '../../app/theme.dart';
import 'register_vehicle_dialog.dart';

class FleetPage extends StatefulWidget {
  const FleetPage({super.key});

  @override
  State<FleetPage> createState() => _FleetPageState();
}

class _FleetPageState extends State<FleetPage> {
  final _searchController = TextEditingController();
  String _filter = 'All Vehicles';
  int _selectedIndex = 0;
  late List<_Vehicle> _vehicles = [
    const _Vehicle('TRK-842', 'GZA-9231', 'Heavy Compactor', 'In Service',
        'Robert K.', 45, 'Diesel', '142,850 km', '18,500 kg'),
    const _Vehicle('TRK-843', 'GZA-9232', 'Standard Loader', 'Available',
        'Unassigned', 83, 'Diesel', '98,240 km', '12,000 kg'),
    const _Vehicle('TRK-844', 'GZA-9233', 'Heavy Compactor', 'Maintenance',
        'Sarah J.', 12, 'Diesel', '176,410 km', '18,500 kg'),
    const _Vehicle('TRK-845', 'GZA-9234', 'Light EV', 'In Service', 'Mike T.',
        72, 'Electric', '61,320 km', '3,500 kg'),
    const _Vehicle('TRK-846', 'GZA-9235', 'Standard Loader', 'In Service',
        'David W.', 66, 'Diesel', '112,080 km', '12,000 kg'),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_Vehicle> get _visibleVehicles {
    final query = _searchController.text.trim().toLowerCase();
    return _vehicles.where((vehicle) {
      final filterMatches = switch (_filter) {
        'Available' => vehicle.status == 'Available',
        'Assigned' => vehicle.driver != 'Unassigned',
        'In Service' => vehicle.status == 'In Service',
        'Maintenance' => vehicle.status == 'Maintenance',
        _ => true,
      };
      final searchMatches = query.isEmpty ||
          '${vehicle.id} ${vehicle.plate} ${vehicle.type} ${vehicle.driver}'
              .toLowerCase()
              .contains(query);
      return filterMatches && searchMatches;
    }).toList();
  }

  _Vehicle get _selectedVehicle {
    final visible = _visibleVehicles;
    if (visible.isEmpty) return _vehicles.first;
    return visible[_selectedIndex.clamp(0, visible.length - 1)];
  }

  void _message(String text) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(text), behavior: SnackBarBehavior.floating),
      );

  Future<void> _registerVehicle() async {
    final registration = await showDialog<VehicleRegistration>(
      context: context,
      builder: (context) => const RegisterVehicleDialog(),
    );
    if (registration == null || !mounted) return;
    setState(() {
      _vehicles = [
        _Vehicle(
          registration.vehicleId,
          registration.licensePlate,
          registration.vehicleType,
          registration.status == 'Active' ? 'In Service' : registration.status,
          'Unassigned',
          100,
          registration.fuelType,
          '0 km',
          '${registration.payloadTons.toStringAsFixed(1)} t',
        ),
        ..._vehicles,
      ];
      _filter = 'All Vehicles';
      _selectedIndex = 0;
      _searchController.clear();
    });
    _message('${registration.vehicleId} registered successfully.');
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 880;
          return SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
            child: Column(
              children: [
                _KpiStrip(compact: compact),
                const SizedBox(height: 24),
                if (compact) ...[
                  _FleetTablePanel(
                    vehicles: _visibleVehicles,
                    selected: _selectedVehicle,
                    filter: _filter,
                    searchController: _searchController,
                    onRegister: _registerVehicle,
                    onFilter: (value) => setState(() {
                      _filter = value;
                      _selectedIndex = 0;
                    }),
                    onSearch: (_) => setState(() => _selectedIndex = 0),
                    onSelect: (vehicle) => setState(
                      () => _selectedIndex = _visibleVehicles.indexOf(vehicle),
                    ),
                    onAction: _message,
                  ),
                  const SizedBox(height: 16),
                  _VehicleDetail(vehicle: _selectedVehicle, onAction: _message),
                ] else
                  SizedBox(
                    height: 720,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: _FleetTablePanel(
                            vehicles: _visibleVehicles,
                            selected: _selectedVehicle,
                            filter: _filter,
                            searchController: _searchController,
                            onRegister: _registerVehicle,
                            onFilter: (value) => setState(() {
                              _filter = value;
                              _selectedIndex = 0;
                            }),
                            onSearch: (_) => setState(() => _selectedIndex = 0),
                            onSelect: (vehicle) => setState(() =>
                                _selectedIndex =
                                    _visibleVehicles.indexOf(vehicle)),
                            onAction: _message,
                          ),
                        ),
                        const SizedBox(width: 24),
                        SizedBox(
                          width: 300,
                          child: _VehicleDetail(
                              vehicle: _selectedVehicle, onAction: _message),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          );
        },
      );
}

class _KpiStrip extends StatelessWidget {
  const _KpiStrip({required this.compact});
  final bool compact;

  @override
  Widget build(BuildContext context) {
    const values = [
      ('TOTAL VEHICLES', '156', null, null),
      ('IN SERVICE', '142', primary, null),
      ('MAINTENANCE', '8', alert, null),
      ('AVAILABLE', '6', Color(0xFF3F7648), null),
      ('AVG FUEL', '2.4', null, 'km/L'),
      ('GPS ONLINE', '154', null, null),
    ];
    final cards = values
        .map((item) => _FleetKpi(
              label: item.$1,
              value: item.$2,
              color: item.$3,
              suffix: item.$4,
            ))
        .toList();
    if (compact) {
      return GridView.count(
        crossAxisCount: 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
        childAspectRatio: 2.2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        children: cards,
      );
    }
    return SizedBox(
      height: 116,
      child: Row(
        children: [
          for (var i = 0; i < cards.length; i++) ...[
            Expanded(child: cards[i]),
            if (i != cards.length - 1) const SizedBox(width: 14),
          ],
        ],
      ),
    );
  }
}

class _FleetKpi extends StatelessWidget {
  const _FleetKpi(
      {required this.label, required this.value, this.color, this.suffix});
  final String label;
  final String value;
  final Color? color;
  final String? suffix;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: textMuted)),
            Row(crossAxisAlignment: CrossAxisAlignment.end, children: [
              Text(value,
                  style: TextStyle(
                      fontSize: 30,
                      height: 1,
                      fontWeight: FontWeight.w500,
                      color: color ?? const Color(0xFF1C211B))),
              if (suffix != null) ...[
                const SizedBox(width: 6),
                Padding(
                  padding: const EdgeInsets.only(bottom: 2),
                  child: Text(suffix!,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                ),
              ],
            ]),
          ],
        ),
      );
}

class _FleetTablePanel extends StatelessWidget {
  const _FleetTablePanel({
    required this.vehicles,
    required this.selected,
    required this.filter,
    required this.searchController,
    required this.onRegister,
    required this.onFilter,
    required this.onSearch,
    required this.onSelect,
    required this.onAction,
  });

  final List<_Vehicle> vehicles;
  final _Vehicle selected;
  final String filter;
  final TextEditingController searchController;
  final VoidCallback onRegister;
  final ValueChanged<String> onFilter;
  final ValueChanged<String> onSearch;
  final ValueChanged<_Vehicle> onSelect;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Wrap(
                spacing: 10,
                runSpacing: 10,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilledButton.icon(
                    onPressed: onRegister,
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Register Vehicle'),
                    style: FilledButton.styleFrom(backgroundColor: primary),
                  ),
                  SizedBox(
                    width: 280,
                    child: TextField(
                      controller: searchController,
                      onChanged: onSearch,
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: true,
                        prefixIcon: Icon(Icons.search_rounded, size: 20),
                        hintText: 'Search VIN, Plate, Driver...',
                      ),
                    ),
                  ),
                  IconButton.outlined(
                    tooltip: 'Download fleet list',
                    onPressed: () => onAction('Fleet list downloaded.'),
                    icon: const Icon(Icons.download_rounded, size: 19),
                  ),
                  IconButton.outlined(
                    tooltip: 'Import fleet list',
                    onPressed: () => onAction('Import vehicle file selected.'),
                    icon: const Icon(Icons.upload_rounded, size: 19),
                  ),
                  IconButton.outlined(
                    tooltip: 'Refresh vehicles',
                    onPressed: () => onAction('Fleet data refreshed.'),
                    icon: const Icon(Icons.refresh_rounded, size: 19),
                  ),
                ],
              ),
            ),
            Container(
              color: const Color(0xFFF6F7F2),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final option in const [
                    'All Vehicles',
                    'Available',
                    'Assigned',
                    'In Service',
                    'Maintenance'
                  ])
                    ChoiceChip(
                      label: Text(option),
                      selected: filter == option,
                      onSelected: (_) => onFilter(option),
                    ),
                ],
              ),
            ),
            LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width:
                      constraints.maxWidth < 720 ? 720 : constraints.maxWidth,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const _VehicleTableHeader(),
                      if (vehicles.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(48),
                          child: Center(
                              child: Text('No vehicles match these filters.')),
                        )
                      else
                        ...vehicles.map((vehicle) => _VehicleTableRow(
                              vehicle: vehicle,
                              selected: vehicle == selected,
                              onTap: () => onSelect(vehicle),
                            )),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}

class _VehicleTableHeader extends StatelessWidget {
  const _VehicleTableHeader();
  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
        decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: border))),
        child: const Row(children: [
          Expanded(flex: 14, child: Text('Vehicle ID')),
          Expanded(flex: 15, child: Text('License Plate')),
          Expanded(flex: 20, child: Text('Type')),
          Expanded(flex: 17, child: Text('Status')),
          Expanded(flex: 19, child: Text('Assigned Driver')),
          Expanded(flex: 10, child: Text('Fuel')),
        ]),
      );
}

class _VehicleTableRow extends StatelessWidget {
  const _VehicleTableRow(
      {required this.vehicle, required this.selected, required this.onTap});
  final _Vehicle vehicle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFEEFAEE) : Colors.white,
            border: const Border(bottom: BorderSide(color: Color(0xFFE8EBE3))),
          ),
          child: Row(children: [
            Expanded(flex: 14, child: _cell(vehicle.id, strong: true)),
            Expanded(flex: 15, child: _cell(vehicle.plate)),
            Expanded(flex: 20, child: _cell(vehicle.type)),
            Expanded(flex: 17, child: _StatusBadge(vehicle.status)),
            Expanded(flex: 19, child: _cell(vehicle.driver)),
            Expanded(
              flex: 10,
              child: Padding(
                padding: const EdgeInsets.only(right: 8),
                child: LinearProgressIndicator(
                  value: vehicle.fuel / 100,
                  minHeight: 6,
                  color: vehicle.fuel < 20 ? alert : primary,
                  backgroundColor: const Color(0xFFE2E6DE),
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
          ]),
        ),
      );

  Widget _cell(String value, {bool strong = false}) => Text(value,
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
          fontSize: 12,
          fontWeight: strong ? FontWeight.w800 : FontWeight.w500));
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge(this.status);
  final String status;
  @override
  Widget build(BuildContext context) {
    final danger = status == 'Maintenance' || status == 'Out of Service';
    final available = status == 'Available';
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        color: danger
            ? alertSoft
            : available
                ? primarySoft
                : const Color(0xFFE7ECE6),
        child: Text(status,
            style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                color: danger ? alert : primary)),
      ),
    );
  }
}

class _VehicleDetail extends StatelessWidget {
  const _VehicleDetail({required this.vehicle, required this.onAction});
  final _Vehicle vehicle;
  final ValueChanged<String> onAction;

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        clipBehavior: Clip.antiAlias,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _TruckVisual(),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(children: [
                      Expanded(
                        child: Text(vehicle.id,
                            style: const TextStyle(
                                fontSize: 28, fontWeight: FontWeight.w500)),
                      ),
                      _StatusBadge(vehicle.status),
                    ]),
                    const SizedBox(height: 4),
                    Text('${vehicle.type} • ${vehicle.plate}',
                        style: const TextStyle(color: textMuted)),
                    const SizedBox(height: 22),
                    const Row(children: [
                      Expanded(child: _SmallLabel('ASSIGNED DRIVER')),
                      Expanded(child: _SmallLabel('PAYLOAD CAP.')),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: Text(vehicle.driver)),
                      Expanded(child: Text(vehicle.payload)),
                    ]),
                    const SizedBox(height: 18),
                    const Row(children: [
                      Expanded(child: _SmallLabel('CURRENT MILEAGE')),
                      Expanded(child: _SmallLabel('FUEL TYPE')),
                    ]),
                    const SizedBox(height: 6),
                    Row(children: [
                      Expanded(child: Text(vehicle.mileage)),
                      Expanded(child: Text(vehicle.fuelType)),
                    ]),
                    const SizedBox(height: 24),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F3),
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('○ Telemetry',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 14),
                          _TelemetryBar(
                              label: 'Fuel Level', value: vehicle.fuel / 100),
                          const _TelemetryBar(label: 'Engine Temp', value: .60),
                          const SizedBox(height: 10),
                          const Text('GPS Signal Strong (14 Satellites)',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w700)),
                          const Text('▂▃▅▇',
                              style: TextStyle(color: primary, fontSize: 18)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 22),
                    const Text('⌕  Maintenance',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 14),
                    const _MaintenanceItem(
                      title: 'Last Maintenance',
                      detail: 'Oct 12, 2023 - Routine Oil & Filter',
                      active: true,
                    ),
                    const _MaintenanceItem(
                      title: 'Next Scheduled',
                      detail: 'Nov 15, 2023 - Hydraulic System Check',
                      active: false,
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () => onAction(
                            'Maintenance history opened for ${vehicle.id}.'),
                        icon: const Icon(Icons.history_rounded),
                        label: const Text('Maintenance History'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class _TruckVisual extends StatelessWidget {
  const _TruckVisual();
  @override
  Widget build(BuildContext context) => Container(
        height: 190,
        color: const Color(0xFFDDE5DF),
        child: Stack(children: [
          Positioned.fill(child: CustomPaint(painter: _TruckPainter())),
          Positioned(
            right: 12,
            top: 12,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              color: Colors.white,
              child: const Text('● GPS Online',
                  style: TextStyle(
                      fontSize: 11,
                      color: primary,
                      fontWeight: FontWeight.w800)),
            ),
          ),
        ]),
      );
}

class _TruckPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
        Offset(0, size.height * .76) & Size(size.width, size.height),
        Paint()..color = const Color(0xFF9DA8A0));
    final body = Paint()..color = Colors.white;
    final green = Paint()..color = primary;
    final dark = Paint()..color = const Color(0xFF26342C);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            Rect.fromLTWH(size.width * .31, size.height * .38, size.width * .55,
                size.height * .38),
            const Radius.circular(8)),
        body);
    canvas.drawRect(
        Rect.fromLTWH(
            size.width * .48, size.height * .48, size.width * .38, 16),
        green);
    canvas.drawPath(
        Path()
          ..moveTo(size.width * .14, size.height * .42)
          ..lineTo(size.width * .38, size.height * .42)
          ..lineTo(size.width * .43, size.height * .75)
          ..lineTo(size.width * .12, size.height * .75)
          ..close(),
        body);
    canvas.drawRect(
        Rect.fromLTWH(size.width * .18, size.height * .47, size.width * .15,
            size.height * .13),
        Paint()..color = const Color(0xFF8EAAA9));
    canvas.drawRect(
        Rect.fromLTWH(size.width * .1, size.height * .7, size.width * .78, 8),
        dark);
    for (final x in [.22, .68, .82]) {
      canvas.drawCircle(Offset(size.width * x, size.height * .78), 16, dark);
      canvas.drawCircle(Offset(size.width * x, size.height * .78), 7,
          Paint()..color = const Color(0xFFBEC6BF));
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _SmallLabel extends StatelessWidget {
  const _SmallLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Text(text,
      style: const TextStyle(
          fontSize: 10, fontWeight: FontWeight.w800, color: textMuted));
}

class _TelemetryBar extends StatelessWidget {
  const _TelemetryBar({required this.label, required this.value});
  final String label;
  final double value;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 11))),
            Text('${(value * 100).round()}%',
                style:
                    const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
          ]),
          const SizedBox(height: 5),
          LinearProgressIndicator(
            value: value,
            minHeight: 6,
            color: primary,
            backgroundColor: const Color(0xFFE2E6DE),
          ),
        ]),
      );
}

class _MaintenanceItem extends StatelessWidget {
  const _MaintenanceItem(
      {required this.title, required this.detail, required this.active});
  final String title;
  final String detail;
  final bool active;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Icon(active ? Icons.circle : Icons.circle_outlined,
                color: primary, size: 10),
          ),
          const SizedBox(width: 10),
          Expanded(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w700)),
              Text(detail, style: const TextStyle(fontSize: 12)),
            ]),
          ),
        ]),
      );
}

class _Vehicle {
  const _Vehicle(this.id, this.plate, this.type, this.status, this.driver,
      this.fuel, this.fuelType, this.mileage, this.payload);
  final String id;
  final String plate;
  final String type;
  final String status;
  final String driver;
  final int fuel;
  final String fuelType;
  final String mileage;
  final String payload;
}
