import 'package:flutter/material.dart';

import '../../app/theme.dart';

class GenerateReportDialog extends StatefulWidget {
  const GenerateReportDialog({super.key});

  @override
  State<GenerateReportDialog> createState() => _GenerateReportDialogState();
}

class _GenerateReportDialogState extends State<GenerateReportDialog> {
  DateTime _startDate = DateTime(2023, 10, 1);
  DateTime _endDate = DateTime(2023, 10, 31);
  String _grouping = 'By Route';
  final Set<String> _metrics = {
    'Collection Efficiency',
    'Resource Recovery Rate',
  };

  static const _allMetrics = [
    'Collection Efficiency',
    'Fuel Consumption',
    'Resource Recovery Rate',
    'Total Tonnage',
    'Route Deviations',
  ];

  String _formatDate(DateTime date) {
    String twoDigits(int value) => value.toString().padLeft(2, '0');
    return '${twoDigits(date.month)}/${twoDigits(date.day)}/${date.year}';
  }

  Future<void> _pickDate({required bool start}) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: start ? _startDate : _endDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (selected == null) return;
    setState(() {
      if (start) {
        _startDate = selected;
        if (_endDate.isBefore(selected)) _endDate = selected;
      } else {
        _endDate = selected;
        if (_startDate.isAfter(selected)) _startDate = selected;
      }
    });
  }

  void _startReport() {
    if (_metrics.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one metric.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content:
            Text('Report generation started for ${_metrics.length} metrics.'),
        behavior: SnackBarBehavior.floating,
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
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .9,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _DialogHeader(
              title: 'Generate Report',
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _DialogLabel('Date Range'),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Expanded(
                          child: _DateField(
                            label: 'Start Date',
                            value: _formatDate(_startDate),
                            onTap: () => _pickDate(start: true),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: _DateField(
                            label: 'End Date',
                            value: _formatDate(_endDate),
                            onTap: () => _pickDate(start: false),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                            child: _DialogLabel('Metrics Selection')),
                        TextButton(
                          onPressed: () => setState(() {
                            if (_metrics.length == _allMetrics.length) {
                              _metrics.clear();
                            } else {
                              _metrics
                                ..clear()
                                ..addAll(_allMetrics);
                            }
                          }),
                          child: Text(
                            _metrics.length == _allMetrics.length
                                ? 'Clear All'
                                : 'Select All',
                          ),
                        ),
                      ],
                    ),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _allMetrics.map((metric) {
                        final selected = _metrics.contains(metric);
                        return FilterChip(
                          label: Text(metric),
                          selected: selected,
                          selectedColor: primarySoft,
                          checkmarkColor: primary,
                          onSelected: (_) => setState(() {
                            selected
                                ? _metrics.remove(metric)
                                : _metrics.add(metric);
                          }),
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 22),
                    const _DialogLabel('Grouping & Aggregation'),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      value: _grouping,
                      decoration: const InputDecoration(filled: true),
                      items: const ['By Route', 'By District', 'By Waste Type']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() => _grouping = value!),
                    ),
                  ],
                ),
              ),
            ),
            _DialogFooter(
              actionLabel: 'Start Report',
              onCancel: () => Navigator.of(context).pop(),
              onAction: _startReport,
            ),
          ],
        ),
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.label,
    required this.value,
    required this.onTap,
  });

  final String label;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11, color: textMuted)),
        const SizedBox(height: 4),
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 48,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F2EE),
              border: Border.all(color: border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.calendar_today_outlined, size: 17),
                const SizedBox(width: 10),
                Text(value),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _DialogLabel extends StatelessWidget {
  const _DialogLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) => Text(
        text,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800),
      );
}

class _DialogHeader extends StatelessWidget {
  const _DialogHeader({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
        decoration: const BoxDecoration(
          color: Color(0xFFF2F3ED),
          border: Border(bottom: BorderSide(color: border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
              ),
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

class _DialogFooter extends StatelessWidget {
  const _DialogFooter({
    required this.actionLabel,
    required this.onCancel,
    required this.onAction,
  });

  final String actionLabel;
  final VoidCallback onCancel;
  final VoidCallback onAction;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: const Color(0xFFF2F3ED),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(onPressed: onCancel, child: const Text('Cancel')),
            const SizedBox(width: 16),
            FilledButton(
              onPressed: onAction,
              style: FilledButton.styleFrom(
                backgroundColor: primary,
                minimumSize: const Size(126, 42),
              ),
              child: Text(actionLabel),
            ),
          ],
        ),
      );
}
