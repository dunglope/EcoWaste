import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class TransferStationsPage extends StatefulWidget {
  const TransferStationsPage({super.key});

  @override
  State<TransferStationsPage> createState() => _TransferStationsPageState();
}

class _TransferStationsPageState extends State<TransferStationsPage> {
  final List<_StationData> _stations = const [
    _StationData(
      name: 'Oakwood Transfer',
      district: 'North District',
      id: 'WTS-1042',
      status: 'Operational',
      utilization: 0.45,
      acceptedWaste: 'Municipal Solid, Recyclables, Yard Waste',
      coordinates: '41.8781° N, 87.6298° W',
    ),
    _StationData(
      name: 'Riverside Facility',
      district: 'Central District',
      id: 'WTS-1128',
      status: 'Needs Attention',
      utilization: 0.92,
      acceptedWaste: 'Organic Compost, Hazardous',
      coordinates: '41.8545° N, 87.6010° W',
    ),
    _StationData(
      name: 'Harbor Recycling Hub',
      district: 'Coastal District',
      id: 'WTS-1189',
      status: 'Operational',
      utilization: 0.68,
      acceptedWaste: 'Recyclables, Industrial',
      coordinates: '41.9136° N, 87.6388° W',
    ),
  ];

  String selectedStatus = 'All';
  String selectedDistrict = 'All Districts';
  int selectedStationIndex = 0;

  List<String> get districtOptions => [
        'All Districts',
        ..._stations.map((station) => station.district).toSet().toList(),
      ];

  List<_StationData> get filteredStations {
    return _stations.where((station) {
      final statusOk =
          selectedStatus == 'All' || station.status == selectedStatus;
      final districtOk = selectedDistrict == 'All Districts' ||
          station.district == selectedDistrict;
      return statusOk && districtOk;
    }).toList();
  }

  _StationData get selectedStation {
    final items = filteredStations;
    if (items.isEmpty) return _stations.first;
    return items[selectedStationIndex.clamp(0, items.length - 1)];
  }

  void _openCreateStationDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const CreateStationDialog(),
    );
  }

  void _openImportGisDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const ImportGisDialog(),
    );
  }

  void _openExportGisDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const ExportGisDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final filtered = filteredStations;

    return PageScaffold(
      title: 'Waste Transfer Stations',
      breadcrumb: 'Spatial Infrastructure › Waste Transfer Stations',
      actions: [
        OutlinedButton.icon(
          onPressed: _openCreateStationDialog,
          icon: const Icon(Icons.add_rounded),
          label: const Text('Create Station'),
        ),
        TextButton.icon(
          onPressed: _openImportGisDialog,
          icon: const Icon(Icons.upload_rounded),
          label: const Text('Import GIS Data'),
        ),
        TextButton.icon(
          onPressed: _openExportGisDialog,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export GIS Data'),
        ),
      ],
      children: [
        const Row(
          children: [
            KpiCard(
              title: 'Total Stations',
              value: '142',
              trend: '',
              icon: Icons.business_rounded,
            ),
            SizedBox(width: 16),
            KpiCard(
              title: 'Operational Stations',
              value: '118',
              trend: '+2 this week',
              icon: Icons.check_circle_rounded,
            ),
            SizedBox(width: 16),
            KpiCard(
              title: 'Avg. Capacity Utilization',
              value: '68%',
              trend: '',
              icon: Icons.speed_rounded,
            ),
            SizedBox(width: 16),
            KpiCard(
              title: 'Requiring Attention',
              value: '12',
              trend: '',
              icon: Icons.warning_rounded,
              warning: true,
            ),
          ],
        ),
        const SizedBox(height: 16),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.filter_list_rounded, color: textMuted),
              ...['All', 'Operational', 'Needs Attention', 'Offline'].map(
                (status) => ChoiceChip(
                  label: Text(status),
                  selected: selectedStatus == status,
                  selectedColor: primarySoft,
                  onSelected: (_) => setState(() {
                    selectedStatus = status;
                    selectedStationIndex = 0;
                  }),
                  labelStyle: TextStyle(
                    color: selectedStatus == status ? primary : textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: selectedStatus == status ? primary : border,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ...districtOptions.map(
                (district) => ChoiceChip(
                  label: Text(district),
                  selected: selectedDistrict == district,
                  selectedColor: const Color(0xFFDDEFD6),
                  onSelected: (_) => setState(() {
                    selectedDistrict = district;
                    selectedStationIndex = 0;
                  }),
                  labelStyle: TextStyle(
                    color: selectedDistrict == district ? primary : textMuted,
                    fontWeight: FontWeight.w700,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                    side: BorderSide(
                      color: selectedDistrict == district ? primary : border,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 300,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SectionTitle('District Explorer'),
                    const SizedBox(height: 12),
                    const Wrap(
                      spacing: 8,
                      children: [
                        ChipPill('Operational', active: true),
                        ChipPill('Low Load'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (filtered.isEmpty)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 20),
                        child: Text('No stations match the current filters.'),
                      )
                    else
                      ...List.generate(filtered.length, (index) {
                        final station = filtered[index];
                        final selected = index == selectedStationIndex;
                        return Material(
                          color: selected ? primarySoft : Colors.transparent,
                          borderRadius: BorderRadius.circular(10),
                          child: ListTile(
                            onTap: () =>
                                setState(() => selectedStationIndex = index),
                            title: Text(
                              station.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w700),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 4),
                                Text(station.district),
                                const SizedBox(height: 8),
                                LinearProgressIndicator(
                                  value: station.utilization,
                                  minHeight: 6,
                                  color: station.status == 'Needs Attention'
                                      ? alert
                                      : primary,
                                  backgroundColor: const Color(0xFFE7E9E3),
                                ),
                              ],
                            ),
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 6,
                            ),
                          ),
                        );
                      }),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 16),
            const Expanded(
              child: FakeMap(height: 610, label: 'Station GIS Map'),
            ),
            const SizedBox(width: 16),
            SizedBox(
              width: 330,
              child: AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SELECTED ASSET',
                      style: TextStyle(
                        fontWeight: FontWeight.w800,
                        color: textMuted,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      selectedStation.name,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    Text('ID: ${selectedStation.id}'),
                    const SizedBox(height: 24),
                    ChipPill(
                      selectedStation.status.toUpperCase(),
                      active: selectedStation.status == 'Operational',
                      danger: selectedStation.status == 'Needs Attention' ||
                          selectedStation.status == 'Offline',
                    ),
                    const SizedBox(height: 16),
                    MetricLine(
                      'Capacity vs Load',
                      '${(selectedStation.utilization * 100).round()}%',
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: selectedStation.utilization,
                      color: primary,
                      minHeight: 8,
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'Properties\nDistrict: ${selectedStation.district}\nCoordinates: ${selectedStation.coordinates}\nAccepted Waste: ${selectedStation.acceptedWaste}',
                      style: const TextStyle(height: 1.5),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _StationData {
  const _StationData({
    required this.name,
    required this.district,
    required this.id,
    required this.status,
    required this.utilization,
    required this.acceptedWaste,
    required this.coordinates,
  });

  final String name;
  final String district;
  final String id;
  final String status;
  final double utilization;
  final String acceptedWaste;
  final String coordinates;
}

class CreateStationDialog extends StatefulWidget {
  const CreateStationDialog({super.key});

  @override
  State<CreateStationDialog> createState() => _CreateStationDialogState();
}

class _CreateStationDialogState extends State<CreateStationDialog> {
  final Set<String> wasteTypes = {'Municipal Solid', 'Organic Compost'};

  @override
  Widget build(BuildContext context) {
    const allWasteTypes = [
      'Municipal Solid',
      'Organic Compost',
      'Recyclables',
      'Hazardous',
      'Industrial',
    ];

    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 920,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 920,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF4F4F2),
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(14),
                      topRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Create New Waste Transfer Station',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel('Station Name'),
                      const SizedBox(height: 6),
                      TextField(
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F2EE),
                          hintText: 'e.g. North Metropolitan Recycling Hub',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: border),
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                formLabel('Latitude'),
                                const SizedBox(height: 6),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF1F2EE),
                                    hintText: '47.6062',
                                    suffixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: border),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                formLabel('Longitude'),
                                const SizedBox(height: 6),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF1F2EE),
                                    hintText: '-122.3321',
                                    suffixIcon:
                                        const Icon(Icons.location_on_outlined),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: border),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                formLabel('Handling Capacity (Tons/Day)'),
                                const SizedBox(height: 6),
                                TextField(
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF1F2EE),
                                    hintText: '500',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: border),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                formLabel('Operational Status'),
                                const SizedBox(height: 6),
                                DropdownButtonFormField<String>(
                                  value: 'Operational (Active)',
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: const Color(0xFFF1F2EE),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      borderSide:
                                          const BorderSide(color: border),
                                    ),
                                  ),
                                  items: const [
                                    DropdownMenuItem(
                                      value: 'Operational (Active)',
                                      child: Text('Operational (Active)'),
                                    ),
                                    DropdownMenuItem(
                                      value: 'Standby',
                                      child: Text('Standby'),
                                    ),
                                  ],
                                  onChanged: (_) {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      formLabel('Waste Types Handled'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: allWasteTypes.map((type) {
                          final selected = wasteTypes.contains(type);
                          return FilterChip(
                            label: Text(type),
                            selected: selected,
                            showCheckmark: false,
                            selectedColor: const Color(0xFFDBF0D9),
                            backgroundColor: const Color(0xFFF1F3EE),
                            side: BorderSide(
                              color:
                                  selected ? const Color(0xFF9BC7A5) : border,
                            ),
                            onSelected: (_) {
                              setState(() {
                                if (selected) {
                                  wasteTypes.remove(type);
                                } else {
                                  wasteTypes.add(type);
                                }
                              });
                            },
                            labelStyle: TextStyle(
                              color: selected ? primary : textMuted,
                              fontWeight: FontWeight.w700,
                            ),
                          );
                        }).toList(),
                      ),
                      const SizedBox(height: 18),
                      Container(
                        height: 180,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: border),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: const FakeMap(height: 180, label: ''),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F3ED),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 18),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Station added successfully.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primary,
                          minimumSize: const Size(150, 42),
                        ),
                        child: const Text('Deploy Station'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ImportGisDialog extends StatelessWidget {
  const ImportGisDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 900,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Import GIS Data',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: const Color(0xFFB7BFB0),
                              width: 1.5,
                            ),
                            borderRadius: BorderRadius.circular(12),
                            color: const Color(0xFFF5F5F2),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: const [
                              Icon(
                                Icons.cloud_upload_outlined,
                                size: 44,
                                color: textMuted,
                              ),
                              SizedBox(height: 14),
                              Text(
                                'Drag and drop or browse',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                'Supported: GeoJSON, KML, Shapefiles (ZIP)',
                                style: TextStyle(color: textMuted),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.all(18),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F2EE),
                            border: Border.all(color: border),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Data Structure Preview',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 16),
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFEEF1EB),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Text(
                                  '{\n  "type": "FeatureCollection",\n  "name": "bin_locations_g3",\n  "features": [\n    {\n      "type": "Feature",\n      "properties": {\n        "id": "B-902",\n        "type": "Mixed Waste",\n        "status": "active"\n      }\n    }\n  ]\n}',
                                  style: TextStyle(
                                    fontFamily: 'monospace',
                                    fontSize: 12,
                                    height: 1.5,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: const [
                                  Expanded(child: Text('Total Records')),
                                  Text(
                                    '1,245 Features',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: const [
                                  Expanded(child: Text('Geometry Type')),
                                  Text(
                                    'Point Data',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Row(
                                children: const [
                                  Expanded(child: Text('File Size')),
                                  Text(
                                    '2.4 MB',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w700),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 22),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel('Coordinate System (CRS)'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: 'WGS 84 (EPSG:4326)',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F2EE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: border),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'WGS 84 (EPSG:4326)',
                            child: Text('WGS 84 (EPSG:4326)'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                      const SizedBox(height: 16),
                      formLabel('Target Layer'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: 'Waste Receptacles (Current)',
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: const Color(0xFFF1F2EE),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: const BorderSide(color: border),
                          ),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Waste Receptacles (Current)',
                            child: Text('Waste Receptacles (Current)'),
                          ),
                        ],
                        onChanged: (_) {},
                      ),
                    ],
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  decoration: const BoxDecoration(
                    color: Color(0xFFF2F3ED),
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(14),
                      bottomRight: Radius.circular(14),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel'),
                      ),
                      const SizedBox(width: 18),
                      FilledButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('GIS import started.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: FilledButton.styleFrom(
                          backgroundColor: primary,
                          minimumSize: const Size(150, 42),
                        ),
                        child: const Text('Import'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExportGisDialog extends StatefulWidget {
  const ExportGisDialog({super.key});

  @override
  State<ExportGisDialog> createState() => _ExportGisDialogState();
}

class _ExportGisDialogState extends State<ExportGisDialog> {
  String selectedFormat = 'GeoJSON';
  bool includeMetadata = true;
  bool includeThumbnails = false;
  bool includeHistoricalDelta = false;

  @override
  Widget build(BuildContext context) {
    final formatOptions = ['CSV Spreadsheet', 'GeoJSON', 'ESRI Shapefile'];

    return Dialog(
      insetPadding: const EdgeInsets.all(32),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 900,
          maxHeight: MediaQuery.of(context).size.height * 0.9,
        ),
        child: SingleChildScrollView(
          child: SizedBox(
            width: 900,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
                  child: Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'Export GIS Data',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formLabel('Region Selection'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: 'Primary District',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF1F2EE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: border),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Primary District',
                                  child: Text('Primary District'),
                                ),
                                DropdownMenuItem(
                                  value: 'Central Metro',
                                  child: Text('Central Metro'),
                                ),
                              ],
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            formLabel('Coordinates Scale'),
                            const SizedBox(height: 6),
                            DropdownButtonFormField<String>(
                              value: 'Standard (UTM-32N)',
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF1F2EE),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: const BorderSide(color: border),
                                ),
                              ),
                              items: const [
                                DropdownMenuItem(
                                  value: 'Standard (UTM-32N)',
                                  child: Text('Standard (UTM-32N)'),
                                ),
                              ],
                              onChanged: (_) {},
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Asset Data Layers',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w700),
                      ),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: const [
                          ChoiceChip(label: Text('Smart Bins'), selected: true),
                          ChoiceChip(
                              label: Text('Collection Routes'), selected: true),
                          ChoiceChip(
                              label: Text('Vehicle Fleet'), selected: true),
                          ChoiceChip(
                              label: Text('Disposal Sites'), selected: true),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFFB8C5B0)),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          '+ Add Custom Layer',
                          style: TextStyle(
                              color: primary, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Export Format',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            ...formatOptions.map((option) {
                              final active = selectedFormat == option;
                              return InkWell(
                                onTap: () =>
                                    setState(() => selectedFormat = option),
                                borderRadius: BorderRadius.circular(12),
                                child: Container(
                                  margin: const EdgeInsets.only(bottom: 10),
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 10,
                                  ),
                                  decoration: BoxDecoration(
                                    color: active
                                        ? const Color(0xFFEAF5EB)
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: active
                                          ? primary
                                          : const Color(0xFFBFC7B6),
                                    ),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Row(
                                    children: [
                                      Icon(
                                        option == 'CSV Spreadsheet'
                                            ? Icons.table_chart_outlined
                                            : option == 'GeoJSON'
                                                ? Icons.public_outlined
                                                : Icons.map_outlined,
                                        color: active ? primary : textMuted,
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Text(
                                          option,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w700,
                                          ),
                                        ),
                                      ),
                                      Radio<String>(
                                        value: option,
                                        groupValue: selectedFormat,
                                        onChanged: (value) => setState(
                                          () => selectedFormat = value!,
                                        ),
                                        activeColor: primary,
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(width: 18),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Data Options',
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(height: 12),
                            _OptionToggle(
                              title: 'Include Metadata',
                              subtitle: 'Last edit, sensor health, UUIDs',
                              value: includeMetadata,
                              onChanged: (value) =>
                                  setState(() => includeMetadata = value),
                            ),
                            _OptionToggle(
                              title: 'Asset Thumbnails',
                              subtitle: 'Attach high-res site photos',
                              value: includeThumbnails,
                              onChanged: (value) =>
                                  setState(() => includeThumbnails = value),
                            ),
                            _OptionToggle(
                              title: 'Historical Delta',
                              subtitle: 'Include change logs for 30 days',
                              value: includeHistoricalDelta,
                              onChanged: (value) => setState(
                                  () => includeHistoricalDelta = value),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              size: 18, color: textMuted),
                          SizedBox(width: 8),
                          Text('Estimated file size: 2.4 MB'),
                        ],
                      ),
                      Row(
                        children: [
                          TextButton(
                            onPressed: () => Navigator.of(context).pop(),
                            child: const Text('Cancel'),
                          ),
                          const SizedBox(width: 18),
                          FilledButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Export started successfully.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: primary,
                              minimumSize: const Size(150, 42),
                            ),
                            child: const Text('Export'),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OptionToggle extends StatelessWidget {
  const _OptionToggle({
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: const TextStyle(color: textMuted, fontSize: 12),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: primary,
          ),
        ],
      ),
    );
  }
}
