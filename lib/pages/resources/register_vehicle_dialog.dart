import 'package:flutter/material.dart';

import '../../app/theme.dart';

class VehicleRegistration {
  const VehicleRegistration({
    required this.vehicleId,
    required this.licensePlate,
    required this.vehicleType,
    required this.fuelType,
    required this.payloadTons,
    required this.vin,
    required this.status,
  });

  final String vehicleId;
  final String licensePlate;
  final String vehicleType;
  final String fuelType;
  final double payloadTons;
  final String vin;
  final String status;
}

class RegisterVehicleDialog extends StatefulWidget {
  const RegisterVehicleDialog({super.key});

  @override
  State<RegisterVehicleDialog> createState() => _RegisterVehicleDialogState();
}

class _RegisterVehicleDialogState extends State<RegisterVehicleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _vehicleId = TextEditingController();
  final _licensePlate = TextEditingController();
  final _payload = TextEditingController();
  final _vin = TextEditingController();
  String? _vehicleType;
  String? _fuelType;
  String _status = 'Active';

  @override
  void dispose() {
    _vehicleId.dispose();
    _licensePlate.dispose();
    _payload.dispose();
    _vin.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(VehicleRegistration(
      vehicleId: _vehicleId.text.trim().toUpperCase(),
      licensePlate: _licensePlate.text.trim().toUpperCase(),
      vehicleType: _vehicleType!,
      fuelType: _fuelType!,
      payloadTons: double.parse(_payload.text),
      vin: _vin.text.trim().toUpperCase(),
      status: _status,
    ));
  }

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(modalRadius)),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: 620,
            maxHeight: MediaQuery.sizeOf(context).height * .92,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _DialogHeader(onClose: () => Navigator.of(context).pop()),
              Flexible(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const _SectionLabel('BASIC IDENTITY'),
                        _ResponsiveFields(children: [
                          _DialogField(
                            label: 'Vehicle Name / ID',
                            child: TextFormField(
                              controller: _vehicleId,
                              decoration: const InputDecoration(
                                hintText: 'e.g., RCV-204',
                                filled: true,
                              ),
                              validator: _required,
                            ),
                          ),
                          _DialogField(
                            label: 'License Plate Number',
                            child: TextFormField(
                              controller: _licensePlate,
                              decoration: const InputDecoration(
                                hintText: 'ABC-1234',
                                filled: true,
                              ),
                              validator: _required,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        const _SectionLabel('TECHNICAL SPECIFICATIONS'),
                        _ResponsiveFields(children: [
                          _DialogField(
                            label: 'Vehicle Type',
                            child: DropdownButtonFormField<String>(
                              value: _vehicleType,
                              hint: const Text('Select type'),
                              decoration: const InputDecoration(filled: true),
                              items: const [
                                'Heavy Compactor',
                                'Standard Loader',
                                'Hookloader',
                                'Light EV',
                              ]
                                  .map((value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _vehicleType = value),
                              validator: (value) => value == null
                                  ? 'Select a vehicle type.'
                                  : null,
                            ),
                          ),
                          _DialogField(
                            label: 'Fuel Type',
                            child: DropdownButtonFormField<String>(
                              value: _fuelType,
                              hint: const Text('Select fuel'),
                              decoration: const InputDecoration(filled: true),
                              items: const [
                                'Diesel',
                                'Electric',
                                'CNG',
                                'Hybrid'
                              ]
                                  .map((value) => DropdownMenuItem(
                                      value: value, child: Text(value)))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _fuelType = value),
                              validator: (value) =>
                                  value == null ? 'Select a fuel type.' : null,
                            ),
                          ),
                          _DialogField(
                            label: 'Payload Capacity (Tons)',
                            child: TextFormField(
                              controller: _payload,
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                      decimal: true),
                              decoration: const InputDecoration(
                                hintText: '24.5',
                                filled: true,
                              ),
                              validator: (value) {
                                final payload = double.tryParse(value ?? '');
                                return payload == null || payload <= 0
                                    ? 'Enter a valid capacity.'
                                    : null;
                              },
                            ),
                          ),
                          _DialogField(
                            label: 'Vehicle ID',
                            child: TextFormField(
                              controller: _vin,
                              decoration: const InputDecoration(
                                hintText: '17-digit code',
                                filled: true,
                              ),
                              validator: (value) =>
                                  (value?.trim().length ?? 0) < 6
                                      ? 'Enter at least 6 characters.'
                                      : null,
                            ),
                          ),
                        ]),
                        const SizedBox(height: 20),
                        const _SectionLabel('OPERATIONAL STATUS'),
                        Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: ['Active', 'Maintenance', 'Out of Service']
                              .map((status) => ChoiceChip(
                                    label: Text(status),
                                    selected: _status == status,
                                    onSelected: (_) =>
                                        setState(() => _status = status),
                                  ))
                              .toList(),
                        ),
                        const SizedBox(height: 18),
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F4ED),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(Icons.info_outline_rounded,
                                  color: primary, size: 20),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'Registering this vehicle will automatically provision a new IoT endpoint for the GPS tracking module. Verify the hardware is installed before activation.',
                                  style:
                                      TextStyle(fontSize: 12, color: textMuted),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                height: modalChromeHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: modalFooterDecoration,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 16),
                    FilledButton.icon(
                      onPressed: _submit,
                      icon: const Icon(Icons.add_rounded),
                      label: const Text('Register Vehicle'),
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size(170, 44),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
        height: modalChromeHeight,
        decoration: modalHeaderDecoration,
        padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
        child: Row(children: [
          const Expanded(
            child: Text('Register New Vehicle',
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.w800)),
          ),
          IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded)),
        ]),
      );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;
  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: primary)),
      );
}

class _DialogField extends StatelessWidget {
  const _DialogField({required this.label, required this.child});
  final String label;
  final Widget child;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style:
                  const TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          child,
        ],
      );
}

class _ResponsiveFields extends StatelessWidget {
  const _ResponsiveFields({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          if (constraints.maxWidth < 500) {
            return Column(
              children: [
                for (var i = 0; i < children.length; i++) ...[
                  children[i],
                  if (i != children.length - 1) const SizedBox(height: 12),
                ],
              ],
            );
          }
          return Wrap(
            spacing: 16,
            runSpacing: 12,
            children: children
                .map((child) => SizedBox(
                    width: (constraints.maxWidth - 16) / 2, child: child))
                .toList(),
          );
        },
      );
}
