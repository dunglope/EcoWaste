import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import 'integration_dialog_shared.dart';

class GoogleMapsConfigDialog extends StatefulWidget {
  const GoogleMapsConfigDialog({super.key});

  @override
  State<GoogleMapsConfigDialog> createState() => _GoogleMapsConfigDialogState();
}

class _GoogleMapsConfigDialogState extends State<GoogleMapsConfigDialog> {
  final _formKey = GlobalKey<FormState>();
  final _apiKey = TextEditingController(
    text: 'AIzaSyB3X_m9vY29tLnRhcmdldC5hcGlrZXk',
  );
  final _projectId = TextEditingController(text: 'ecosmart-waste-prod-0042');
  final Set<String> _services = {
    'Geocoding API',
    'Places API',
    'Distance Matrix API',
  };
  bool _hideKey = true;
  bool _restrictUsage = true;

  @override
  void dispose() {
    _apiKey.dispose();
    _projectId.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    closeWithIntegrationMessage(context, 'Google Maps configuration saved.');
  }

  @override
  Widget build(BuildContext context) {
    return IntegrationDialogShell(
      title: 'Configure Google Maps Platform',
      primaryLabel: 'Save Configuration',
      onPrimary: _save,
      leadingAction: OutlinedButton(
        onPressed: () => showIntegrationMessage(
          context,
          'Google Maps connection validated successfully.',
        ),
        child: const Text('Validate Connection'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const IntegrationFieldLabel('API Key'),
            TextFormField(
              controller: _apiKey,
              obscureText: _hideKey,
              decoration: InputDecoration(
                filled: true,
                suffixIcon: IconButton(
                  tooltip: _hideKey ? 'Show API key' : 'Hide API key',
                  onPressed: () => setState(() => _hideKey = !_hideKey),
                  icon: Icon(
                    _hideKey
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                  ),
                ),
              ),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'API key is required.'
                  : null,
            ),
            const Text('Requires billing-enabled account.',
                style: TextStyle(fontSize: 10, color: textMuted)),
            const IntegrationFieldLabel('Project ID'),
            TextFormField(
              controller: _projectId,
              decoration: const InputDecoration(filled: true),
              validator: (value) => value == null || value.trim().isEmpty
                  ? 'Project ID is required.'
                  : null,
            ),
            const IntegrationFieldLabel('Enabled Services'),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: const [
                'Geocoding API',
                'Places API',
                'Distance Matrix API',
                'Maps Static API',
              ].map((service) {
                return SizedBox(
                  width: 250,
                  child: CheckboxListTile(
                    value: _services.contains(service),
                    onChanged: (selected) => setState(() {
                      selected!
                          ? _services.add(service)
                          : _services.remove(service);
                    }),
                    title: Text(service,
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w700)),
                    controlAffinity: ListTileControlAffinity.trailing,
                    tileColor: const Color(0xFFF2F3ED),
                    shape: RoundedRectangleBorder(
                      side: const BorderSide(color: border),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 12),
            Container(
              decoration: BoxDecoration(
                color: const Color(0xFFEDF9EC),
                border: Border.all(color: primarySoft),
                borderRadius: BorderRadius.circular(8),
              ),
              child: SwitchListTile(
                value: _restrictUsage,
                onChanged: (value) => setState(() => _restrictUsage = value),
                title: const Text('Restrict API Key Usage',
                    style:
                        TextStyle(color: primary, fontWeight: FontWeight.w800)),
                subtitle: const Text(
                  'Only allow requests from specific IP addresses.',
                  style: TextStyle(fontSize: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
