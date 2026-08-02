import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class AddVehicleClassDialog extends StatefulWidget {
  const AddVehicleClassDialog({super.key});

  @override
  State<AddVehicleClassDialog> createState() => _AddVehicleClassDialogState();
}

class _AddVehicleClassDialogState extends State<AddVehicleClassDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _capacityController = TextEditingController();
  final _maintenanceController = TextEditingController(text: '10000');
  String _fuelType = 'Diesel';
  final Set<String> _capabilities = {
    'GPS Real-time Tracking',
    'Load Weight Sensors',
  };

  static const _capabilityOptions = [
    'GPS Real-time Tracking',
    'RFID Bin Reader',
    'Load Weight Sensors',
    'On-board Diagnostics (OBD-II)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _capacityController.dispose();
    _maintenanceController.dispose();
    super.dispose();
  }

  String? _positiveNumber(String? value) {
    final number = double.tryParse(value?.trim() ?? '');
    return number == null || number <= 0 ? 'Enter a positive number.' : null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      VehicleClassConfig(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        loadCapacityKg:
            (double.parse(_capacityController.text.trim()) * 1000).round(),
        fuelType: _fuelType,
        maintenanceIntervalKm:
            double.parse(_maintenanceController.text.trim()).round(),
        capabilities: Set.unmodifiable(_capabilities),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Add New Vehicle Class',
                        style: TextStyle(
                            color: primary,
                            fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded),
                  ),
                ],
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 560;
                          final name = _LabeledField(
                            label: 'Class Name',
                            child: TextFormField(
                              controller: _nameController,
                              textCapitalization: TextCapitalization.words,
                              decoration: const InputDecoration(
                                hintText: 'e.g., Heavy Duty Compactor',
                                filled: true,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Class name is required.'
                                      : null,
                            ),
                          );
                          final description = _LabeledField(
                            label: 'Class Description',
                            child: TextFormField(
                              controller: _descriptionController,
                              decoration: const InputDecoration(
                                hintText: 'Brief functional summary',
                                filled: true,
                              ),
                              validator: (value) =>
                                  value == null || value.trim().isEmpty
                                      ? 'Description is required.'
                                      : null,
                            ),
                          );
                          if (compact) {
                            return Column(children: [name, description]);
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: name),
                              const SizedBox(width: 18),
                              Expanded(child: description),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 18),
                      const Text('Operational Specifications',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth < 620
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 32) / 3;
                          return Wrap(
                            spacing: 16,
                            runSpacing: 12,
                            children: [
                              SizedBox(
                                width: width,
                                child: _LabeledField(
                                  label: 'Load Capacity (Tons)',
                                  child: TextFormField(
                                    controller: _capacityController,
                                    keyboardType:
                                        const TextInputType.numberWithOptions(
                                      decimal: true,
                                    ),
                                    decoration: const InputDecoration(
                                      hintText: '0.0',
                                      filled: true,
                                    ),
                                    validator: _positiveNumber,
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: _LabeledField(
                                  label: 'Fuel Type',
                                  child: DropdownButtonFormField<String>(
                                    value: _fuelType,
                                    decoration:
                                        const InputDecoration(filled: true),
                                    items: const [
                                      'Diesel',
                                      'Petrol',
                                      'Electric',
                                      'Hybrid',
                                      'CNG',
                                    ]
                                        .map((value) => DropdownMenuItem(
                                              value: value,
                                              child: Text(value),
                                            ))
                                        .toList(),
                                    onChanged: (value) =>
                                        setState(() => _fuelType = value!),
                                  ),
                                ),
                              ),
                              SizedBox(
                                width: width,
                                child: _LabeledField(
                                  label: 'Maintenance Interval (km)',
                                  child: TextFormField(
                                    controller: _maintenanceController,
                                    keyboardType: TextInputType.number,
                                    decoration: const InputDecoration(
                                      hintText: '10,000',
                                      filled: true,
                                    ),
                                    validator: _positiveNumber,
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                      const SizedBox(height: 20),
                      const Text('Specialized Capabilities',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF2F3ED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final width = constraints.maxWidth < 520
                                ? constraints.maxWidth
                                : (constraints.maxWidth - 12) / 2;
                            return Wrap(
                              spacing: 12,
                              children: _capabilityOptions.map((capability) {
                                return SizedBox(
                                  width: width,
                                  child: CheckboxListTile(
                                    dense: true,
                                    contentPadding: EdgeInsets.zero,
                                    value: _capabilities.contains(capability),
                                    onChanged: (selected) => setState(() {
                                      selected!
                                          ? _capabilities.add(capability)
                                          : _capabilities.remove(capability);
                                    }),
                                    title: Text(capability,
                                        style: const TextStyle(fontSize: 12)),
                                    controlAffinity:
                                        ListTileControlAffinity.leading,
                                  ),
                                );
                              }).toList(),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              color: const Color(0xFFF2F3ED),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 18),
                  FilledButton.icon(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(backgroundColor: primary),
                    icon: const Icon(Icons.add_rounded),
                    label: const Text('Add Class'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VehicleClassConfig {
  const VehicleClassConfig({
    required this.name,
    required this.description,
    required this.loadCapacityKg,
    required this.fuelType,
    required this.maintenanceIntervalKm,
    required this.capabilities,
  });

  final String name;
  final String description;
  final int loadCapacityKg;
  final String fuelType;
  final int maintenanceIntervalKm;
  final Set<String> capabilities;

  VehicleClassConfig copyWith({int? loadCapacityKg}) {
    return VehicleClassConfig(
      name: name,
      description: description,
      loadCapacityKg: loadCapacityKg ?? this.loadCapacityKg,
      fuelType: fuelType,
      maintenanceIntervalKm: maintenanceIntervalKm,
      capabilities: capabilities,
    );
  }
}

class _LabeledField extends StatelessWidget {
  const _LabeledField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: Text(label,
                  style: const TextStyle(
                      fontSize: 11, fontWeight: FontWeight.w800)),
            ),
            child,
          ],
        ),
      );
}
