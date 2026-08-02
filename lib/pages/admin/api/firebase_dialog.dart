import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'integration_dialog_shared.dart';

class FirebaseConfigDialog extends StatefulWidget {
  const FirebaseConfigDialog({super.key});

  @override
  State<FirebaseConfigDialog> createState() => _FirebaseConfigDialogState();
}

class _FirebaseConfigDialogState extends State<FirebaseConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _serverKey =
      TextEditingController(text: 'AIzaSyA_ExampleKey_8Xp3N_0k9Qj2m4...');
  final _senderId = TextEditingController(text: '88219475023');
  final _vapidKey = TextEditingController(
    text:
        'BCo-5O3s1n_v_H3K9m_Example_Long_VAPID_String_h_9mQ4uP_3kL09asD821m...',
  );
  String _environment = 'Production';

  @override
  void dispose() {
    _serverKey.dispose();
    _senderId.dispose();
    _vapidKey.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    closeWithIntegrationMessage(context, 'Firebase configuration saved.');
  }

  @override
  Widget build(BuildContext context) {
    return IntegrationDialogShell(
      title: 'Configure Firebase Messaging',
      primaryLabel: 'Save Configuration',
      onPrimary: _save,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IntegrationFieldLabel('Server Key'),
            TextFormField(
              controller: _serverKey,
              decoration: const InputDecoration(filled: true),
              validator: _required,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IntegrationFieldLabel('Sender ID'),
                      TextFormField(
                        controller: _senderId,
                        decoration: const InputDecoration(filled: true),
                        validator: _required,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IntegrationFieldLabel('Environment'),
                      DropdownButtonFormField<String>(
                        value: _environment,
                        decoration: const InputDecoration(filled: true),
                        items: const ['Production', 'Staging', 'Development']
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _environment = value!),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const IntegrationFieldLabel('Web Push Certificate (VAPID Key)'),
            TextFormField(
              controller: _vapidKey,
              minLines: 3,
              maxLines: 3,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
              decoration: const InputDecoration(filled: true),
              validator: _required,
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F6F1),
                border: Border.all(color: border),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Test Notification',
                      style: TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 12),
                  const Text(
                    'Verify your credentials by sending a dry-run notification to the current administrator device.',
                    style: TextStyle(fontSize: 11, color: textMuted),
                  ),
                  const SizedBox(height: 14),
                  OutlinedButton(
                    onPressed: () => showIntegrationMessage(
                      context,
                      'Firebase dry-run notification delivered.',
                    ),
                    child: const Text('Trigger Dry Run'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'This field is required.' : null;
}
