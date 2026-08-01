import 'package:flutter/material.dart';

import '../../app/theme.dart';

class ExportReportDialog extends StatefulWidget {
  const ExportReportDialog({super.key});

  @override
  State<ExportReportDialog> createState() => _ExportReportDialogState();
}

class _ExportReportDialogState extends State<ExportReportDialog> {
  String _format = 'PDF';
  bool _includeCharts = true;
  bool _appendDictionary = false;

  void _startExport() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$_format export started.'),
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
            Container(
              padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
              decoration: const BoxDecoration(
                color: Color(0xFFF2F3ED),
                border: Border(bottom: BorderSide(color: border)),
              ),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Export',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w800),
                    ),
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
                    const Text(
                      'SELECT EXPORT FORMAT',
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        const formats = [
                          (
                            'PDF',
                            Icons.picture_as_pdf_outlined,
                            'Optimized for executive presentations.'
                          ),
                          (
                            'XLSX',
                            Icons.table_chart_outlined,
                            'Best for complex data analysis.'
                          ),
                          (
                            'CSV',
                            Icons.grid_on_outlined,
                            'Raw data for machine systems.'
                          ),
                        ];
                        final width = constraints.maxWidth < 480
                            ? constraints.maxWidth
                            : (constraints.maxWidth - 20) / 3;
                        return Wrap(
                          spacing: 10,
                          runSpacing: 10,
                          children: formats.map((item) {
                            final selected = _format == item.$1;
                            return SizedBox(
                              width: width,
                              child: InkWell(
                                onTap: () => setState(() => _format = item.$1),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  height: 112,
                                  padding: const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: selected
                                        ? primarySoft
                                        : Colors.transparent,
                                    border: Border.all(
                                      color: selected ? primary : border,
                                      width: selected ? 1.5 : 1,
                                    ),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Icon(item.$2,
                                              size: 18, color: primary),
                                          const Spacer(),
                                          Icon(
                                            selected
                                                ? Icons.radio_button_checked
                                                : Icons.radio_button_off,
                                            size: 16,
                                            color: selected ? primary : border,
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 8),
                                      Text(item.$1,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w800)),
                                      const SizedBox(height: 4),
                                      Text(item.$3,
                                          style: const TextStyle(
                                              fontSize: 10, color: textMuted)),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'REPORT CONFIGURATION',
                      style: TextStyle(
                        color: primary,
                        fontSize: 11,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    _ExportOption(
                      icon: Icons.bar_chart_rounded,
                      title: 'Include Visual Charts',
                      subtitle:
                          'Embed high-resolution visualizations for each metric.',
                      value: _includeCharts,
                      onChanged: (value) =>
                          setState(() => _includeCharts = value),
                    ),
                    const SizedBox(height: 10),
                    _ExportOption(
                      icon: Icons.menu_book_outlined,
                      title: 'Append Data Dictionary',
                      subtitle:
                          'Add metadata and field definitions as a trailing section.',
                      value: _appendDictionary,
                      onChanged: (value) =>
                          setState(() => _appendDictionary = value),
                    ),
                    const SizedBox(height: 24),
                    const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.info_outline_rounded,
                            size: 17, color: primary),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Note: Performance exports contain sensitive geospatial data. Exported documents are watermarked with your administrative ID for audit compliance.',
                            style: TextStyle(fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
              color: const Color(0xFFF2F3ED),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _startExport,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(126, 42),
                    ),
                    child: const Text('Start Export'),
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

class _ExportOption extends StatelessWidget {
  const _ExportOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F7F2),
          border: Border.all(color: const Color(0xFFE4E8DF)),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: primarySoft,
              child: Icon(icon, size: 18, color: primary),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  Text(subtitle,
                      style: const TextStyle(fontSize: 10, color: textMuted)),
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
