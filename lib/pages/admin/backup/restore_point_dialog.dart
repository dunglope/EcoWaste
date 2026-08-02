import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class RestorePointDialog extends StatefulWidget {
  const RestorePointDialog({super.key});

  @override
  State<RestorePointDialog> createState() => _RestorePointDialogState();
}

class _RestorePointDialogState extends State<RestorePointDialog> {
  String _range = 'Stable Build';
  int _selectedPoint = 0;
  bool _riskAccepted = false;
  String _search = '';

  static const _points = [
    RestorePoint('Oct 24, 2023', '14:02:11 UTC', 'Pre-Update Auto Backup',
        '4.2 GB', 'READY'),
    RestorePoint('Oct 23, 2023', '23:59:00 UTC', 'Daily Infrastructure Sync',
        '3.8 GB', 'READY'),
    RestorePoint('Oct 20, 2023', '18:15:00 UTC', 'Manual: Bulk Asset Import',
        '12.5 GB', 'ARCHIVED'),
  ];

  List<RestorePoint> get _visiblePoints => _points
      .where((point) =>
          point.label.toLowerCase().contains(_search.toLowerCase()) ||
          point.date.toLowerCase().contains(_search.toLowerCase()))
      .toList();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 720,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _RestoreHeader(onClose: () => Navigator.of(context).pop()),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Revert system state to a previous historical snapshot. This action affects spatial metadata and routing logs.',
                      style: TextStyle(fontSize: 11, color: textMuted),
                    ),
                    const SizedBox(height: 14),
                    const Text('Fast Selection: Point-in-Time',
                        style: TextStyle(
                            fontSize: 11, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        'Latest Snapshot',
                        'Stable Build',
                        'EO Week',
                        'Custom Range',
                      ].map((value) {
                        return ChoiceChip(
                          label: Text(value),
                          selected: _range == value,
                          selectedColor: primarySoft,
                          onSelected: (_) => setState(() => _range = value),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Expanded(
                          child: Text('Available Recovery Points',
                              style: TextStyle(
                                  fontSize: 11, fontWeight: FontWeight.w800)),
                        ),
                        SizedBox(
                          width: 200,
                          height: 38,
                          child: TextField(
                            onChanged: (value) =>
                                setState(() => _search = value),
                            decoration: const InputDecoration(
                              hintText: 'Filter by label...',
                              prefixIcon: Icon(Icons.search_rounded, size: 18),
                              contentPadding: EdgeInsets.zero,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: border),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: List.generate(_visiblePoints.length, (index) {
                          final point = _visiblePoints[index];
                          final originalIndex = _points.indexOf(point);
                          final selected = _selectedPoint == originalIndex;
                          return InkWell(
                            onTap: () =>
                                setState(() => _selectedPoint = originalIndex),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              color: selected
                                  ? const Color(0xFFEEF8EC)
                                  : Colors.transparent,
                              child: Row(
                                children: [
                                  Icon(
                                    selected
                                        ? Icons.radio_button_checked
                                        : Icons.radio_button_off,
                                    color: selected ? primary : textMuted,
                                    size: 17,
                                  ),
                                  const SizedBox(width: 9),
                                  SizedBox(
                                    width: 105,
                                    child: Text('${point.date}\n${point.time}',
                                        style: const TextStyle(fontSize: 10)),
                                  ),
                                  Expanded(
                                    child: Text(point.label,
                                        style: const TextStyle(fontSize: 11)),
                                  ),
                                  Text(point.size,
                                      style: const TextStyle(
                                          fontSize: 10, color: textMuted)),
                                  const SizedBox(width: 12),
                                  Chip(
                                    label: Text(point.status),
                                    visualDensity: VisualDensity.compact,
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: alertSoft,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: alert, size: 20),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'CRITICAL: Data Overwrite Warning\nInitiating this restoration will overwrite current system modifications, spatial markers, and routing schedules created after the selected point.',
                              style: TextStyle(fontSize: 11, color: alert),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  Expanded(
                    child: CheckboxListTile(
                      dense: true,
                      contentPadding: EdgeInsets.zero,
                      value: _riskAccepted,
                      onChanged: (value) =>
                          setState(() => _riskAccepted = value!),
                      title: const Text('I understand the risks of data loss.',
                          style: TextStyle(fontSize: 10)),
                      controlAffinity: ListTileControlAffinity.leading,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 10),
                  FilledButton(
                    onPressed: _riskAccepted
                        ? () =>
                            Navigator.of(context).pop(_points[_selectedPoint])
                        : null,
                    style: FilledButton.styleFrom(backgroundColor: alert),
                    child: const Text('Begin Restoration'),
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

class RestorePoint {
  const RestorePoint(this.date, this.time, this.label, this.size, this.status);

  final String date;
  final String time;
  final String label;
  final String size;
  final String status;
}

class _RestoreHeader extends StatelessWidget {
  const _RestoreHeader({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        color: const Color(0xFFF2F3ED),
        child: Row(
          children: [
            const Expanded(
              child: Text('Restore from Point',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
            ),
            IconButton(
              tooltip: 'Close',
              onPressed: onClose,
              icon: const Icon(Icons.close_rounded),
            ),
          ],
        ),
      );
}
