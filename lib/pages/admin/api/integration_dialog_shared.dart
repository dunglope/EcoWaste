import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class IntegrationDialogShell extends StatelessWidget {
  const IntegrationDialogShell({
    super.key,
    required this.title,
    required this.body,
    required this.primaryLabel,
    required this.onPrimary,
    this.leadingAction,
  });

  final String title;
  final Widget body;
  final String primaryLabel;
  final VoidCallback onPrimary;
  final Widget? leadingAction;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(10, 6, 6, 6),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                      ),
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
                padding: const EdgeInsets.all(12),
                child: body,
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  if (leadingAction != null) leadingAction!,
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: onPrimary,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(150, 42),
                    ),
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
}

class IntegrationFieldLabel extends StatelessWidget {
  const IntegrationFieldLabel(this.label, {super.key, this.helper});

  final String label;
  final String? helper;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label,
                style:
                    const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
            if (helper != null)
              Text(helper!,
                  style: const TextStyle(fontSize: 10, color: textMuted)),
          ],
        ),
      );
}

void showIntegrationMessage(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}

void closeWithIntegrationMessage(BuildContext context, String message) {
  final messenger = ScaffoldMessenger.of(context);
  Navigator.of(context).pop();
  messenger.showSnackBar(
    SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
  );
}
