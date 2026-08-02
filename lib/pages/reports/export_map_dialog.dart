import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class ExportMapDialog extends StatefulWidget {
  const ExportMapDialog({super.key});

  @override
  State<ExportMapDialog> createState() => _ExportMapDialogState();
}

class _ExportMapDialogState extends State<ExportMapDialog> {
  String _resolution = 'Ultra-HD';
  String _format = 'PNG';
  bool _currentViewport = true;
  bool _showLegends = false;
  bool _includeScaleBar = true;

  void _download() {
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content:
            Text('$_format map export started at $_resolution resolution.'),
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
          maxWidth: 900,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _Header(
              title: 'Export Map View',
              onClose: () => Navigator.of(context).pop(),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(12),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final compact = constraints.maxWidth < 680;
                    final preview = Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text('MAP SNAPSHOT PREVIEW',
                            style: TextStyle(
                                color: textMuted,
                                fontSize: 12,
                                fontWeight: FontWeight.w700)),
                        SizedBox(height: 10),
                        FakeMap(height: 480, label: 'City Sector 4C'),
                      ],
                    );
                    final settings = _mapSettings();

                    if (compact) {
                      return Column(
                        children: [
                          preview,
                          const SizedBox(height: 18),
                          settings
                        ],
                      );
                    }
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(flex: 3, child: preview),
                        const SizedBox(width: 22),
                        SizedBox(width: 300, child: settings),
                      ],
                    );
                  },
                ),
              ),
            ),
            _Footer(
              actionLabel: 'Download Map',
              onCancel: () => Navigator.of(context).pop(),
              onAction: _download,
            ),
          ],
        ),
      ),
    );
  }

  Widget _mapSettings() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Resolution', style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        ...const {
          'Standard': '1920 × 1080',
          'High': '3840 × 2160',
          'Ultra-HD': '7680 × 4320',
        }.entries.map((entry) {
          final selected = _resolution == entry.key;
          return InkWell(
            onTap: () => setState(() => _resolution = entry.key),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: selected ? const Color(0xFFDDE6DC) : Colors.transparent,
                border: Border.all(color: selected ? primary : border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(entry.key,
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        Text(entry.value,
                            style: const TextStyle(
                                fontSize: 11, color: textMuted)),
                      ],
                    ),
                  ),
                  Icon(
                    selected
                        ? Icons.radio_button_checked
                        : Icons.radio_button_off,
                    size: 18,
                    color: selected ? primary : textMuted,
                  ),
                ],
              ),
            ),
          );
        }),
        const SizedBox(height: 14),
        const Text('File Format',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        SegmentedButton<String>(
          segments: const [
            ButtonSegment(value: 'PNG', label: Text('PNG')),
            ButtonSegment(value: 'JPEG', label: Text('JPEG')),
            ButtonSegment(value: 'PDF', label: Text('PDF')),
          ],
          selected: {_format},
          onSelectionChanged: (values) =>
              setState(() => _format = values.first),
          showSelectedIcon: false,
        ),
        const SizedBox(height: 20),
        const Text('Layer Settings',
            style: TextStyle(fontWeight: FontWeight.w800)),
        _SettingSwitch(
          label: 'Current Viewport',
          value: _currentViewport,
          onChanged: (value) => setState(() => _currentViewport = value),
        ),
        _SettingSwitch(
          label: 'Show Legends',
          value: _showLegends,
          onChanged: (value) => setState(() => _showLegends = value),
        ),
        _SettingSwitch(
          label: 'Include Scale Bar',
          value: _includeScaleBar,
          onChanged: (value) => setState(() => _includeScaleBar = value),
        ),
      ],
    );
  }
}

class _SettingSwitch extends StatelessWidget {
  const _SettingSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
          Switch(value: value, onChanged: onChanged, activeColor: primary),
        ],
      );
}

class _Header extends StatelessWidget {
  const _Header({required this.title, required this.onClose});

  final String title;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
        color: const Color(0xFFF2F3ED),
        child: Row(
          children: [
            Expanded(
              child: Text(title,
                  style: const TextStyle(
                      fontSize: 18, fontWeight: FontWeight.w800)),
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

class _Footer extends StatelessWidget {
  const _Footer({
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
              style: FilledButton.styleFrom(backgroundColor: primary),
              child: Text(actionLabel),
            ),
          ],
        ),
      );
}
