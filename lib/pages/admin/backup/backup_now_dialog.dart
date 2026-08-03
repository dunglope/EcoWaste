import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class BackupNowDialog extends StatefulWidget {
  const BackupNowDialog({super.key});

  @override
  State<BackupNowDialog> createState() => _BackupNowDialogState();
}

class _BackupNowDialogState extends State<BackupNowDialog> {
  final _labelController = TextEditingController();
  String _scope = 'Full System';

  @override
  void dispose() {
    _labelController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _BackupDialogFrame(
      title: 'Initiate System Backup',
      primaryLabel: 'Initiate Backup',
      onPrimary: () => Navigator.of(context).pop(
        BackupRequest(
          label: _labelController.text.trim().isEmpty
              ? 'Manual System Backup'
              : _labelController.text.trim(),
          scope: _scope,
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const _DialogLabel('Backup Label / Note'),
          TextField(
            controller: _labelController,
            decoration: const InputDecoration(
              hintText: 'e.g., Weekly Maintenance - Q3',
              filled: true,
            ),
          ),
          const SizedBox(height: 16),
          const _DialogLabel('Backup Scope'),
          _ScopeOption(
            title: 'Full System',
            subtitle:
                'Includes all spatial data, database records, and system configurations.',
            selected: _scope == 'Full System',
            onTap: () => setState(() => _scope = 'Full System'),
          ),
          const SizedBox(height: 8),
          _ScopeOption(
            title: 'Database Only',
            subtitle:
                'Schedules a core SQL export of administrative and operational records.',
            selected: _scope == 'Database Only',
            onTap: () => setState(() => _scope = 'Database Only'),
          ),
          const SizedBox(height: 14),
          const Text(
            'A system backup will create a secure, point-in-time snapshot of your municipal data.',
            style: TextStyle(fontSize: 11, color: textMuted),
          ),
        ],
      ),
    );
  }
}

class BackupRequest {
  const BackupRequest({required this.label, required this.scope});

  final String label;
  final String scope;
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? primarySoft : Colors.transparent,
            border: Border.all(color: selected ? primary : border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 3),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 10, color: textMuted)),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.check_circle : Icons.circle_outlined,
                color: selected ? primary : textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      );
}

class _DialogLabel extends StatelessWidget {
  const _DialogLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );
}

class _BackupDialogFrame extends StatelessWidget {
  const _BackupDialogFrame({
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
  });

  final String title;
  final Widget body;
  final String primaryLabel;
  final VoidCallback onPrimary;

  @override
  Widget build(BuildContext context) => Dialog(
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
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(
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
                  child: body,
                ),
              ),
              Container(
                width: double.infinity,
                height: modalChromeHeight,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
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
                      onPressed: onPrimary,
                      style: FilledButton.styleFrom(backgroundColor: primary),
                      child: Text(primaryLabel),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}
