import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'fleet/add_vehicle_class_dialog.dart';

class FleetConfigPage extends StatefulWidget {
  const FleetConfigPage({super.key});

  @override
  State<FleetConfigPage> createState() => _FleetConfigPageState();
}

class _FleetConfigPageState extends State<FleetConfigPage> {
  late FleetConfigurationData _configuration;
  late FleetConfigurationData _savedConfiguration;
  int _fieldRevision = 0;

  @override
  void initState() {
    super.initState();
    _configuration = FleetConfigurationData.defaults();
    _savedConfiguration = _configuration.copyWith();
  }

  Future<void> _addClass() async {
    final vehicleClass = await showDialog<VehicleClassConfig>(
      context: context,
      builder: (context) => const AddVehicleClassDialog(),
    );
    if (vehicleClass == null || !mounted) return;
    setState(() {
      _configuration = _configuration.copyWith(
        classes: [..._configuration.classes, vehicleClass],
      );
    });
    _showMessage('${vehicleClass.name} class added.');
  }

  void _saveConfiguration() {
    setState(() => _savedConfiguration = _configuration.copyWith());
    _showMessage('Fleet configuration saved successfully.');
  }

  void _discardChanges() {
    setState(() {
      _configuration = _savedConfiguration.copyWith();
      _fieldRevision++;
    });
    _showMessage('Unsaved fleet changes discarded.');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Fleet Configuration',
      subtitle: 'Global parameters for vehicle management.',
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final panelWidth = constraints.maxWidth >= 760
                ? (constraints.maxWidth - 24) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SizedBox(
                  width: panelWidth,
                  child: _buildVehicleClassesPanel(),
                ),
                SizedBox(
                  width: panelWidth,
                  child: _buildMaintenancePanel(),
                ),
                SizedBox(
                  width: panelWidth,
                  child: _buildFuelPanel(),
                ),
                SizedBox(
                  width: panelWidth,
                  child: _buildTelemetryPanel(),
                ),
              ],
            );
          },
        ),
        const SizedBox(height: 20),
        const Divider(),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            OutlinedButton(
              onPressed: _discardChanges,
              child: const Text('Discard Changes'),
            ),
            const SizedBox(width: 14),
            FilledButton(
              onPressed: _saveConfiguration,
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size(170, 44),
              ),
              child: const Text('Save Configuration'),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildVehicleClassesPanel() {
    return _FleetPanel(
      height: 430,
      title: 'Vehicle Classes',
      icon: Icons.directions_car_rounded,
      child: Column(
        children: [
          Expanded(
            child: ListView.separated(
              itemCount: _configuration.classes.length,
              separatorBuilder: (_, __) => const SizedBox(height: 10),
              itemBuilder: (context, index) {
                final vehicleClass = _configuration.classes[index];
                return Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF4F5F0),
                    border: Border.all(color: const Color(0xFFE5E8E0)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(vehicleClass.name,
                                style: const TextStyle(
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 4),
                            Text(vehicleClass.description,
                                style: const TextStyle(
                                    color: textMuted, fontSize: 12)),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 105,
                        child: TextFormField(
                          key: ValueKey(
                              'capacity-$_fieldRevision-$index-${vehicleClass.loadCapacityKg}'),
                          initialValue: '${vehicleClass.loadCapacityKg}',
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.right,
                          decoration: const InputDecoration(
                            isDense: true,
                            suffixText: 'kg',
                            filled: true,
                          ),
                          onChanged: (value) {
                            final capacity = int.tryParse(value);
                            if (capacity == null || capacity <= 0) return;
                            final classes = [..._configuration.classes];
                            classes[index] = vehicleClass.copyWith(
                              loadCapacityKg: capacity,
                            );
                            _configuration =
                                _configuration.copyWith(classes: classes);
                          },
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton.icon(
              onPressed: _addClass,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Add Class'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMaintenancePanel() {
    return _FleetPanel(
      height: 430,
      title: 'Maintenance',
      icon: Icons.build_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Standard Maintenance Interval',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _configuration.maintenanceIntervalKm.toDouble(),
                  min: 5000,
                  max: 30000,
                  divisions: 25,
                  onChanged: (value) => setState(() {
                    _configuration = _configuration.copyWith(
                      maintenanceIntervalKm: value.round(),
                    );
                  }),
                ),
              ),
              SizedBox(
                width: 90,
                child: Text(
                  '${_configuration.maintenanceIntervalKm} km',
                  textAlign: TextAlign.right,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Automated Alerts',
                    style:
                        TextStyle(fontSize: 16, fontWeight: FontWeight.w800)),
                const SizedBox(height: 14),
                _NumericSetting(
                  key: ValueKey('warning-$_fieldRevision'),
                  label: 'Pre-maintenance warning distance',
                  value: _configuration.warningDistanceKm,
                  suffix: 'km',
                  onChanged: (value) => _configuration =
                      _configuration.copyWith(warningDistanceKm: value),
                ),
                const SizedBox(height: 12),
                _NumericSetting(
                  key: ValueKey('critical-$_fieldRevision'),
                  label: 'Critical overdue threshold',
                  value: _configuration.criticalOverdueKm,
                  suffix: 'km',
                  danger: true,
                  onChanged: (value) => _configuration =
                      _configuration.copyWith(criticalOverdueKm: value),
                ),
                const SizedBox(height: 8),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _configuration.autoScheduleWorkshop,
                  onChanged: (value) => setState(() {
                    _configuration = _configuration.copyWith(
                      autoScheduleWorkshop: value,
                    );
                  }),
                  title: const Text('Auto-schedule workshop visits'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFuelPanel() {
    return _FleetPanel(
      height: 430,
      title: 'Fuel Management',
      icon: Icons.local_gas_station_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _DropdownSetting(
                  label: 'Primary Fuel Default',
                  value: _configuration.primaryFuel,
                  options: const ['Diesel', 'Petrol', 'Electric', 'CNG'],
                  onChanged: (value) => setState(() {
                    _configuration =
                        _configuration.copyWith(primaryFuel: value);
                  }),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: _DropdownSetting(
                  label: 'Secondary Fuel Default',
                  value: _configuration.secondaryFuel,
                  options: const ['None', 'Diesel', 'Electric', 'CNG'],
                  onChanged: (value) => setState(() {
                    _configuration =
                        _configuration.copyWith(secondaryFuel: value);
                  }),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Alert Thresholds',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                _ThresholdSlider(
                  label: 'Low Fuel Warning',
                  value: _configuration.lowFuelWarning,
                  onChanged: (value) => setState(() {
                    _configuration =
                        _configuration.copyWith(lowFuelWarning: value);
                  }),
                ),
                _ThresholdSlider(
                  label: 'Critical Fuel Level',
                  value: _configuration.criticalFuelLevel,
                  danger: true,
                  onChanged: (value) => setState(() {
                    _configuration =
                        _configuration.copyWith(criticalFuelLevel: value);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTelemetryPanel() {
    return _FleetPanel(
      height: 430,
      title: 'GPS Telemetry',
      icon: Icons.satellite_alt_rounded,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Ping Frequency (Active Status)',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          const Text(
            'Higher frequency increases data usage but improves real-time tracking accuracy.',
            style: TextStyle(fontSize: 11, color: textMuted),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              for (final option in const [
                ('5s', 'High Res'),
                ('10s', 'Standard'),
                ('30s', 'Economy'),
              ]) ...[
                Expanded(
                  child: _PingOption(
                    value: option.$1,
                    label: option.$2,
                    selected: _configuration.pingFrequency == option.$1,
                    onTap: () => setState(() {
                      _configuration =
                          _configuration.copyWith(pingFrequency: option.$1);
                    }),
                  ),
                ),
                if (option.$1 != '30s') const SizedBox(width: 10),
              ],
            ],
          ),
          const SizedBox(height: 18),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF4F5F0),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Data Retention',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                _CompactDropdownRow(
                  label: 'Detailed Route History',
                  value: _configuration.routeHistoryRetention,
                  options: const ['30 Days', '60 Days', '90 Days', '1 Year'],
                  onChanged: (value) => setState(() {
                    _configuration = _configuration.copyWith(
                      routeHistoryRetention: value,
                    );
                  }),
                ),
                _CompactDropdownRow(
                  label: 'Aggregated Metrics',
                  value: _configuration.metricsRetention,
                  options: const ['1 Year', '5 Years', 'Indefinite'],
                  onChanged: (value) => setState(() {
                    _configuration =
                        _configuration.copyWith(metricsRetention: value);
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FleetConfigurationData {
  const FleetConfigurationData({
    required this.classes,
    required this.maintenanceIntervalKm,
    required this.warningDistanceKm,
    required this.criticalOverdueKm,
    required this.autoScheduleWorkshop,
    required this.primaryFuel,
    required this.secondaryFuel,
    required this.lowFuelWarning,
    required this.criticalFuelLevel,
    required this.pingFrequency,
    required this.routeHistoryRetention,
    required this.metricsRetention,
  });

  factory FleetConfigurationData.defaults() => const FleetConfigurationData(
        classes: [
          VehicleClassConfig(
            name: 'Heavy',
            description: 'Heavy duty collection.',
            loadCapacityKg: 26000,
            fuelType: 'Diesel',
            maintenanceIntervalKm: 15000,
            capabilities: {'GPS Real-time Tracking', 'Load Weight Sensors'},
          ),
          VehicleClassConfig(
            name: 'Hookloader',
            description: 'Roll-on/roll-off skips.',
            loadCapacityKg: 32000,
            fuelType: 'Diesel',
            maintenanceIntervalKm: 15000,
            capabilities: {'GPS Real-time Tracking'},
          ),
          VehicleClassConfig(
            name: 'Van',
            description: 'Light transit & inspection.',
            loadCapacityKg: 3500,
            fuelType: 'Diesel',
            maintenanceIntervalKm: 10000,
            capabilities: {'GPS Real-time Tracking'},
          ),
        ],
        maintenanceIntervalKm: 15000,
        warningDistanceKm: 1000,
        criticalOverdueKm: 500,
        autoScheduleWorkshop: true,
        primaryFuel: 'Diesel',
        secondaryFuel: 'None',
        lowFuelWarning: 15,
        criticalFuelLevel: 5,
        pingFrequency: '10s',
        routeHistoryRetention: '90 Days',
        metricsRetention: 'Indefinite',
      );

  final List<VehicleClassConfig> classes;
  final int maintenanceIntervalKm;
  final int warningDistanceKm;
  final int criticalOverdueKm;
  final bool autoScheduleWorkshop;
  final String primaryFuel;
  final String secondaryFuel;
  final int lowFuelWarning;
  final int criticalFuelLevel;
  final String pingFrequency;
  final String routeHistoryRetention;
  final String metricsRetention;

  FleetConfigurationData copyWith({
    List<VehicleClassConfig>? classes,
    int? maintenanceIntervalKm,
    int? warningDistanceKm,
    int? criticalOverdueKm,
    bool? autoScheduleWorkshop,
    String? primaryFuel,
    String? secondaryFuel,
    int? lowFuelWarning,
    int? criticalFuelLevel,
    String? pingFrequency,
    String? routeHistoryRetention,
    String? metricsRetention,
  }) {
    return FleetConfigurationData(
      classes: List.unmodifiable(classes ?? this.classes),
      maintenanceIntervalKm:
          maintenanceIntervalKm ?? this.maintenanceIntervalKm,
      warningDistanceKm: warningDistanceKm ?? this.warningDistanceKm,
      criticalOverdueKm: criticalOverdueKm ?? this.criticalOverdueKm,
      autoScheduleWorkshop: autoScheduleWorkshop ?? this.autoScheduleWorkshop,
      primaryFuel: primaryFuel ?? this.primaryFuel,
      secondaryFuel: secondaryFuel ?? this.secondaryFuel,
      lowFuelWarning: lowFuelWarning ?? this.lowFuelWarning,
      criticalFuelLevel: criticalFuelLevel ?? this.criticalFuelLevel,
      pingFrequency: pingFrequency ?? this.pingFrequency,
      routeHistoryRetention:
          routeHistoryRetention ?? this.routeHistoryRetention,
      metricsRetention: metricsRetention ?? this.metricsRetention,
    );
  }
}

class _FleetPanel extends StatelessWidget {
  const _FleetPanel({
    required this.title,
    required this.icon,
    required this.child,
    required this.height,
  });

  final String title;
  final IconData icon;
  final Widget child;
  final double height;

  @override
  Widget build(BuildContext context) => Container(
        height: height,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SectionTitle(title, icon: icon),
            const Divider(height: 24),
            Expanded(child: child),
          ],
        ),
      );
}

class _NumericSetting extends StatelessWidget {
  const _NumericSetting({
    super.key,
    required this.label,
    required this.value,
    required this.suffix,
    required this.onChanged,
    this.danger = false,
  });

  final String label;
  final int value;
  final String suffix;
  final ValueChanged<int> onChanged;
  final bool danger;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: TextFormField(
              initialValue: '$value',
              keyboardType: TextInputType.number,
              textAlign: TextAlign.right,
              style: TextStyle(color: danger ? alert : null),
              decoration: InputDecoration(
                isDense: true,
                suffixText: suffix,
                filled: true,
              ),
              onChanged: (text) {
                final number = int.tryParse(text);
                if (number != null && number > 0) onChanged(number);
              },
            ),
          ),
        ],
      );
}

class _DropdownSetting extends StatelessWidget {
  const _DropdownSetting({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 11, color: textMuted)),
          const SizedBox(height: 6),
          DropdownButtonFormField<String>(
            value: value,
            decoration: const InputDecoration(isDense: true, filled: true),
            items: options
                .map((option) =>
                    DropdownMenuItem(value: option, child: Text(option)))
                .toList(),
            onChanged: (value) => onChanged(value!),
          ),
        ],
      );
}

class _ThresholdSlider extends StatelessWidget {
  const _ThresholdSlider({
    required this.label,
    required this.value,
    required this.onChanged,
    this.danger = false,
  });

  final String label;
  final int value;
  final ValueChanged<int> onChanged;
  final bool danger;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          SizedBox(width: 125, child: Text(label)),
          Expanded(
            child: Slider(
              value: value.toDouble(),
              min: 1,
              max: 30,
              divisions: 29,
              onChanged: (next) => onChanged(next.round()),
            ),
          ),
          SizedBox(
            width: 42,
            child: Text(
              '$value%',
              textAlign: TextAlign.right,
              style: TextStyle(
                color: danger ? alert : null,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ],
      );
}

class _PingOption extends StatelessWidget {
  const _PingOption({
    required this.value,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String value;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          height: 90,
          decoration: BoxDecoration(
            color: selected ? primarySoft : const Color(0xFFF7F8F3),
            border: Border.all(color: selected ? primary : border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(value,
                  style: const TextStyle(
                      fontSize: 21, fontWeight: FontWeight.w800)),
              const SizedBox(height: 4),
              Text(label,
                  style: const TextStyle(fontSize: 10, color: textMuted)),
            ],
          ),
        ),
      );
}

class _CompactDropdownRow extends StatelessWidget {
  const _CompactDropdownRow({
    required this.label,
    required this.value,
    required this.options,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> options;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(
          children: [
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
            SizedBox(
              width: 125,
              child: DropdownButtonFormField<String>(
                value: value,
                decoration: const InputDecoration(isDense: true, filled: true),
                items: options
                    .map((option) =>
                        DropdownMenuItem(value: option, child: Text(option)))
                    .toList(),
                onChanged: (value) => onChanged(value!),
              ),
            ),
          ],
        ),
      );
}
