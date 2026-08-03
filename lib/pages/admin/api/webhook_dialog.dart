import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets.dart';
import 'integration_dialog_shared.dart';

class WebhookConfigDialog extends StatefulWidget {
  const WebhookConfigDialog({super.key, this.canRemove = true});

  final bool canRemove;

  @override
  State<WebhookConfigDialog> createState() => _WebhookConfigDialogState();
}

class _WebhookConfigDialogState extends State<WebhookConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _url = TextEditingController(text: 'https://api.example.com/webhook');
  final _secret = TextEditingController(text: 'secret-key-2042');
  String _contentType = 'application/json';
  bool _hideSecret = true;
  bool _sslVerification = true;

  @override
  void dispose() {
    _url.dispose();
    _secret.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(false);
  }

  Future<void> _removeWebhook() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => EcoModalDialog(
        title: 'Remove Webhook?',
        body: const Text(
          'This stops event delivery and removes the saved endpoint and secret.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: FilledButton.styleFrom(backgroundColor: alert),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    Navigator.of(context).pop(true);
  }

  @override
  Widget build(BuildContext context) {
    return IntegrationDialogShell(
      title: 'Configure Custom Webhook',
      primaryLabel: 'Save',
      onPrimary: _save,
      leadingAction: widget.canRemove
          ? TextButton.icon(
              onPressed: _removeWebhook,
              style: TextButton.styleFrom(foregroundColor: alert),
              label: const Text('Remove Webhook'),
            )
          : null,
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IntegrationFieldLabel(
              'Payload URL',
              helper: 'Specify the URL where JSON payloads will be delivered.',
            ),
            TextFormField(
              controller: _url,
              keyboardType: TextInputType.url,
              decoration: const InputDecoration(filled: true),
              validator: (value) {
                final url = value?.trim() ?? '';
                return url.startsWith('https://')
                    ? null
                    : 'Enter a secure HTTPS URL.';
              },
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IntegrationFieldLabel('Content Type'),
                      DropdownButtonFormField<String>(
                        value: _contentType,
                        decoration: const InputDecoration(filled: true),
                        items: const ['application/json', 'application/xml']
                            .map((value) => DropdownMenuItem(
                                  value: value,
                                  child: Text(value),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _contentType = value!),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const IntegrationFieldLabel('Secret (HMAC)'),
                      TextFormField(
                        controller: _secret,
                        obscureText: _hideSecret,
                        decoration: InputDecoration(
                          filled: true,
                          suffixIcon: IconButton(
                            tooltip:
                                _hideSecret ? 'Show secret' : 'Hide secret',
                            onPressed: () =>
                                setState(() => _hideSecret = !_hideSecret),
                            icon: Icon(
                              _hideSecret
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFF3F4EF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  SwitchListTile(
                    value: _sslVerification,
                    onChanged: (value) =>
                        setState(() => _sslVerification = value),
                    title: const Text('SSL Verification',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: const Text(
                      'Perform certificate validation for secure delivery.',
                      style: TextStyle(fontSize: 10),
                    ),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    title: const Text('Test Connectivity',
                        style: TextStyle(fontWeight: FontWeight.w800)),
                    subtitle: const Text(
                        'Send a ping event to verify the endpoint.',
                        style: TextStyle(fontSize: 10)),
                    trailing: OutlinedButton(
                      onPressed: () => showIntegrationMessage(
                        context,
                        'Webhook responded with HTTP 200.',
                      ),
                      child: const Text('Test Hook'),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 14),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEDF9EC),
                border: Border.all(color: primarySoft),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.info_outline_rounded, color: primary, size: 18),
                  SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      'This webhook triggers for Resource Management and Collection Management events.',
                      style: TextStyle(fontSize: 11, color: Color(0xFF37653B)),
                    ),
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
