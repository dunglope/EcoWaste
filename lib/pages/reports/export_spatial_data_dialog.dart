import 'package:flutter/material.dart';

import '../../app/theme.dart';

class ExportSpatialDataDialog extends StatefulWidget {
  const ExportSpatialDataDialog({super.key});

  @override
  State<ExportSpatialDataDialog> createState() =>
      _ExportSpatialDataDialogState();
}

class _ExportSpatialDataDialogState extends State<ExportSpatialDataDialog> {
  final Set<String> _layers = {
    'Waste Bins',
    'Collection Routes',
    'Station Locations',
  };
  String _format = 'GeoJSON';
  String _constraint = 'Current Map Bounds';

  static const _allLayers = [
    'Waste Bins',
    'Collection Routes',
    'Vehicle History',
    'Station Locations',
  ];

  void _export() {
    if (_layers.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one data layer.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$_format export started for ${_layers.length} layers.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(modalRadius)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: modalChromeHeight,
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              decoration: modalHeaderDecoration,
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Export Spatial Data',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w800)),
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Data Layer Selection',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                        ),
                        Text('${_allLayers.length} Layers Available',
                            style: const TextStyle(
                                color: textMuted, fontSize: 12)),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allLayers.map((layer) {
                        final selected = _layers.contains(layer);
                        return FilterChip(
                          label: Text(layer),
                          selected: selected,
                          selectedColor: primarySoft,
                          onSelected: (_) => setState(() {
                            selected
                                ? _layers.remove(layer)
                                : _layers.add(layer);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Export Format',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: const {
                        'PDF': Icons.picture_as_pdf_outlined,
                        'GeoJSON': Icons.code_rounded,
                        'CSV': Icons.grid_on_outlined,
                        'SHP': Icons.layers_outlined,
                      }.entries.map((entry) {
                        final selected = _format == entry.key;
                        return SizedBox(
                          width: 92,
                          child: InkWell(
                            onTap: () => setState(() => _format = entry.key),
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              height: 92,
                              decoration: BoxDecoration(
                                color: selected
                                    ? const Color(0xFFDDE6DC)
                                    : modalControlFill,
                                border: Border.all(
                                    color: selected
                                        ? primary
                                        : Colors.transparent),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(entry.value, color: primary),
                                  const SizedBox(height: 8),
                                  Text(entry.key,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.w800)),
                                ],
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                    const Text('Spatial Constraints',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    const SizedBox(height: 10),
                    DropdownButtonFormField<String>(
                      value: _constraint,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.my_location_outlined),
                        filled: true,
                      ),
                      items: const [
                        'Current Map Bounds',
                        'Selected District',
                        'Entire Service Area',
                      ]
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) =>
                          setState(() => _constraint = value!),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7F8F5),
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline_rounded,
                              color: primary, size: 18),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Exporting within $_constraint: 42.36° N, '
                              '71.05° W. ${_layers.length * 415} features detected.',
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: modalChromeHeight,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              decoration: modalFooterDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _export,
                    style: FilledButton.styleFrom(backgroundColor: primary),
                    child: const Text('Initiate Export'),
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
