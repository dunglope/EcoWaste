import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class ReindexTablesDialog extends StatefulWidget {
  const ReindexTablesDialog({super.key});

  @override
  State<ReindexTablesDialog> createState() => _ReindexTablesDialogState();
}

class _ReindexTablesDialogState extends State<ReindexTablesDialog> {
  String _method = 'Full Re-index';

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(modalRadius)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 520,
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
                    child: Text('Re-index Database Tables',
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
                    Container(
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: modalControlFill,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Text(
                        'Optimizing indexes can improve query performance and reduce storage fragmentation. This process may temporarily impact write performance.',
                        style: TextStyle(color: textMuted),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Row(
                      children: [
                        Icon(Icons.history_rounded, size: 17, color: textMuted),
                        SizedBox(width: 6),
                        Text('Last re-indexed 12 days ago.',
                            style: TextStyle(color: textMuted)),
                      ],
                    ),
                    const SizedBox(height: 24),
                    const Text('SELECT OPTIMIZATION METHOD',
                        style: TextStyle(
                            fontSize: 12,
                            color: textMuted,
                            fontWeight: FontWeight.w900)),
                    const SizedBox(height: 10),
                    _MethodOption(
                      title: 'Full Re-index',
                      description:
                          'Comprehensive rebuild of all relational and spatial indexes. Recommended during maintenance.',
                      selected: _method == 'Full Re-index',
                      onTap: () => setState(() => _method = 'Full Re-index'),
                    ),
                    const SizedBox(height: 10),
                    _MethodOption(
                      title: 'Targeted Re-index',
                      description:
                          'Optimizes spatial R-tree and GiST indexes only. Low impact on relational transactional flow.',
                      selected: _method == 'Targeted Re-index',
                      onTap: () =>
                          setState(() => _method = 'Targeted Re-index'),
                    ),
                    const SizedBox(height: 16),
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF6F4),
                        border: Border.all(color: const Color(0xFFFFCBC5)),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: alert, size: 20),
                          SizedBox(width: 9),
                          Expanded(
                            child: Text(
                              'Proceeding will lock write access for approximately 4-8 minutes depending on table size.',
                              style: TextStyle(fontSize: 12, color: textMuted),
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
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: modalFooterDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 14),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pop(_method),
                    style: FilledButton.styleFrom(backgroundColor: primary),
                    child: const Text('Initiate Re-indexing'),
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

class _MethodOption extends StatelessWidget {
  const _MethodOption({
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            border: Border.all(
              color: selected ? primary : border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? primary : textMuted,
                size: 18,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(description,
                        style: const TextStyle(color: textMuted, fontSize: 12)),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
