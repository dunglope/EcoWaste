import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'api/firebase_dialog.dart';
import 'api/google_maps_dialog.dart';
import 'api/webhook_dialog.dart';

class ApiPage extends StatefulWidget {
  const ApiPage({super.key});

  @override
  State<ApiPage> createState() => _ApiPageState();
}

class _ApiPageState extends State<ApiPage> {
  bool _webhookConfigured = true;

  void _openDialog(BuildContext context, Widget dialog) {
    showDialog<void>(context: context, builder: (context) => dialog);
  }

  Future<void> _openWebhookDialog() async {
    final result = await showDialog<bool>(
      context: context,
      builder: (context) => WebhookConfigDialog(canRemove: _webhookConfigured),
    );
    if (result == null || !mounted) return;
    setState(() => _webhookConfigured = !result);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result
              ? 'Custom webhook removed.'
              : 'Custom webhook configuration saved.',
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'API Integration',
      subtitle: 'Manage external service connections and webhooks.',
      children: [
        Wrap(
          spacing: 24,
          runSpacing: 24,
          children: [
            IntegrationCard(
              type: IntegrationType.googleMaps,
              title: 'Google Maps Platform',
              icon: Icons.map_rounded,
              status: 'Connected',
              onPressed: () => _openDialog(
                context,
                const GoogleMapsConfigDialog(),
              ),
            ),
            IntegrationCard(
              type: IntegrationType.firebase,
              title: 'Firebase Messaging',
              icon: Icons.notifications_active_rounded,
              status: 'Connected',
              onPressed: () => _openDialog(
                context,
                const FirebaseConfigDialog(),
              ),
            ),
            IntegrationCard(
              type: IntegrationType.webhooks,
              title: 'Custom Webhooks',
              icon: Icons.webhook_rounded,
              status: _webhookConfigured ? '3 Active' : 'Not Configured',
              active: _webhookConfigured,
              actionLabel: _webhookConfigured ? 'Manage' : 'Configure',
              onPressed: _openWebhookDialog,
            ),
          ],
        ),
      ],
    );
  }
}

enum IntegrationType { googleMaps, firebase, webhooks }

class IntegrationCard extends StatelessWidget {
  const IntegrationCard({
    super.key,
    required this.type,
    required this.title,
    required this.icon,
    required this.status,
    required this.onPressed,
    this.actionLabel = 'Configure',
    this.active = true,
  });

  final IntegrationType type;
  final String title;
  final IconData icon;
  final String status;
  final String actionLabel;
  final VoidCallback onPressed;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 304,
      height: type == IntegrationType.webhooks ? 246 : 226,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(
            color: Color(0x10000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(width: 4, color: active ? primary : textMuted),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F3ED),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(icon, color: primary, size: 22),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.1,
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      OutlinedButton(
                        onPressed: onPressed,
                        style: OutlinedButton.styleFrom(
                          minimumSize: const Size(72, 34),
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          textStyle: const TextStyle(fontSize: 11),
                        ),
                        child: Text(actionLabel),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 50),
                    child: Text(
                      '●  $status',
                      style: TextStyle(
                        color: active ? const Color(0xFF2E6735) : textMuted,
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Expanded(child: _buildDetails()),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetails() {
    return switch (type) {
      IntegrationType.googleMaps => Column(
          children: [
            const _DetailsBox(
              children: [
                _KeyValueRow('ENDPOINT', '****************'),
                _KeyValueRow('API KEY', 'AIzaSyB...9XqQ'),
              ],
            ),
            const Spacer(),
            const _KeyValueRow(
              'Monthly Usage',
              '42,500 / 100,000 reqs',
              emphasizeValue: false,
            ),
            const SizedBox(height: 5),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: const LinearProgressIndicator(
                value: .425,
                minHeight: 6,
                backgroundColor: Color(0xFFE4E7DE),
                color: primary,
              ),
            ),
          ],
        ),
      IntegrationType.firebase => const Column(
          children: [
            _DetailsBox(
              children: [
                _KeyValueRow('PROJECT ID', 'db-prod-9a2f'),
                _KeyValueRow('SERVICE ACCT', 'firebase-adminsdk...'),
              ],
            ),
            Spacer(),
            _KeyValueRow(
              'Messages Sent (30d)',
              '1.2M',
              emphasizeValue: false,
            ),
          ],
        ),
      IntegrationType.webhooks => active
          ? const Column(
              children: [
                _DetailsBox(
                  children: [
                    _WebhookRow('Route Completed'),
                    _WebhookRow('Bin Overflow Alert'),
                    _WebhookRow('Vehicle Maintenance'),
                  ],
                ),
                Spacer(),
                _KeyValueRow(
                  'Events Processed (24h)',
                  '4,892',
                  emphasizeValue: false,
                ),
              ],
            )
          : const Center(
              child: Text(
                'No webhook endpoint is currently configured.',
                textAlign: TextAlign.center,
                style: TextStyle(color: textMuted, fontSize: 12),
              ),
            ),
    };
  }
}

class _DetailsBox extends StatelessWidget {
  const _DetailsBox({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: const Color(0xFFF2F3ED),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(children: children),
      );
}

class _KeyValueRow extends StatelessWidget {
  const _KeyValueRow(
    this.label,
    this.value, {
    this.emphasizeValue = true,
  });

  final String label;
  final String value;
  final bool emphasizeValue;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
              child: Text(
                label,
                style: const TextStyle(
                  color: textMuted,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Flexible(
              child: Text(
                value,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.right,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight:
                      emphasizeValue ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      );
}

class _WebhookRow extends StatelessWidget {
  const _WebhookRow(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 3),
        child: Row(
          children: [
            Expanded(
              child: Text(label, style: const TextStyle(fontSize: 10)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
              decoration: BoxDecoration(
                color: primarySoft,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'Active',
                style: TextStyle(
                  color: primary,
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      );
}
