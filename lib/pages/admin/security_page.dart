import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'security/add_ip_range_dialog.dart';

class SecurityPage extends StatefulWidget {
  const SecurityPage({super.key});

  @override
  State<SecurityPage> createState() => _SecurityPageState();
}

class _SecurityPageState extends State<SecurityPage> {
  final _idleTimeoutController = TextEditingController(text: '15');
  final _loginLimitController = TextEditingController(text: '1');

  bool _passwordPolicyEnabled = true;
  bool _minimumComplexity = true;
  bool _expirationEnabled = false;
  String _expirationPeriod = 'Every 90 days';
  String _twoFactorMethod = 'Authenticator App';

  final List<IpWhitelistEntry> _ranges = [
    const IpWhitelistEntry(
      name: 'HQ Operations',
      cidr: '192.168.1.0/24',
      description: 'Main Office Internal Network',
      active: true,
      permissions: {
        'Management API Access',
        'Mobile App Access',
        'Web Console Access',
      },
    ),
    const IpWhitelistEntry(
      name: 'Dispatch Hub',
      cidr: '10.0.50.0/28',
      description: 'Fleet Management Center',
      active: true,
      permissions: {'Mobile App Access', 'Web Console Access'},
    ),
    const IpWhitelistEntry(
      name: 'External Auditors',
      cidr: '203.0.113.45/32',
      description: 'Temporary audit access',
      active: false,
      permissions: {'Web Console Access'},
    ),
  ];

  @override
  void dispose() {
    _idleTimeoutController.dispose();
    _loginLimitController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    final timeout = int.tryParse(_idleTimeoutController.text);
    final limit = int.tryParse(_loginLimitController.text);
    if (timeout == null || timeout < 1 || limit == null || limit < 1) {
      _showMessage('Session values must be positive whole numbers.');
      return;
    }
    _showMessage('Security settings saved successfully.');
  }

  Future<void> _addRange() async {
    final entry = await showDialog<IpWhitelistEntry>(
      context: context,
      builder: (context) => const AddIpRangeDialog(),
    );
    if (entry == null || !mounted) return;
    setState(() => _ranges.add(entry));
    _showMessage('${entry.name} added to the IP whitelist.');
  }

  Future<void> _editRange(int index) async {
    final entry = await showDialog<IpWhitelistEntry>(
      context: context,
      builder: (context) => AddIpRangeDialog(initial: _ranges[index]),
    );
    if (entry == null || !mounted) return;
    setState(() => _ranges[index] = entry);
    _showMessage('${entry.name} updated.');
  }

  Future<void> _deleteRange(int index) async {
    final entry = _ranges[index];
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => EcoModalDialog(
        title: 'Remove IP Range?',
        body: Text(
          '${entry.cidr} will immediately lose access to protected services.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.of(context).pop(true),
            style: FilledButton.styleFrom(backgroundColor: alert),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('Remove'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    setState(() => _ranges.removeAt(index));
    _showMessage('${entry.cidr} removed from the whitelist.');
  }

  void _toggleRange(int index) {
    final entry = _ranges[index];
    setState(() {
      _ranges[index] = IpWhitelistEntry(
        name: entry.name,
        cidr: entry.cidr,
        description: entry.description,
        active: !entry.active,
        permissions: entry.permissions,
      );
    });
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Security',
      subtitle: 'Manage authentication, session policies, and IP restrictions.',
      actions: [
        FilledButton.icon(
          onPressed: _saveChanges,
          icon: const Icon(Icons.save_rounded),
          label: const Text('Save Changes'),
          style: FilledButton.styleFrom(backgroundColor: primary),
        ),
      ],
      children: [
        LayoutBuilder(
          builder: (context, constraints) {
            final cardWidth = constraints.maxWidth >= 700
                ? (constraints.maxWidth - 24) / 2
                : constraints.maxWidth;
            return Wrap(
              spacing: 24,
              runSpacing: 24,
              children: [
                SizedBox(width: cardWidth, child: _buildPasswordCard()),
                SizedBox(width: cardWidth, child: _buildTwoFactorCard()),
                SizedBox(width: cardWidth, child: _buildSessionCard()),
              ],
            );
          },
        ),
        const SizedBox(height: 24),
        _buildWhitelistTable(),
      ],
    );
  }

  Widget _buildPasswordCard() {
    return _SecurityCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const CircleAvatar(
                backgroundColor: Color(0xFFF1F3ED),
                child: Icon(Icons.password_rounded, color: primary),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text('Password Policy',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
              Switch(
                value: _passwordPolicyEnabled,
                onChanged: (value) =>
                    setState(() => _passwordPolicyEnabled = value),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Opacity(
            opacity: _passwordPolicyEnabled ? 1 : .45,
            child: IgnorePointer(
              ignoring: !_passwordPolicyEnabled,
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFF4F5F0),
                    child: CheckboxListTile(
                      value: _minimumComplexity,
                      onChanged: (value) =>
                          setState(() => _minimumComplexity = value!),
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      title: const Text('Minimum Complexity',
                          style: TextStyle(fontWeight: FontWeight.w800)),
                      subtitle: const Text(
                        'Requires 12+ characters, numbers, symbols, uppercase and lowercase letters.',
                        style: TextStyle(fontSize: 11),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(10),
                    color: const Color(0xFFF4F5F0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Radio<bool>(
                          value: true,
                          groupValue: _expirationEnabled,
                          toggleable: true,
                          onChanged: (value) => setState(
                            () => _expirationEnabled = value ?? false,
                          ),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Expiration Policy',
                                    style:
                                        TextStyle(fontWeight: FontWeight.w800)),
                              ),
                              const SizedBox(height: 8),
                              DropdownButtonFormField<String>(
                                value: _expirationPeriod,
                                decoration: const InputDecoration(
                                  isDense: true,
                                  filled: true,
                                ),
                                items: const [
                                  'Every 30 days',
                                  'Every 60 days',
                                  'Every 90 days',
                                  'Every 180 days',
                                ]
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: _expirationEnabled
                                    ? (value) => setState(
                                          () => _expirationPeriod = value!,
                                        )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTwoFactorCard() {
    return _SecurityCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF1F3ED),
                child: Icon(Icons.verified_user_outlined, color: primary),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Two-Factor Authentication',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 18),
          const Text(
            'Require all administrative and operations personnel to verify identity using a secondary method.',
            style: TextStyle(color: textMuted),
          ),
          const SizedBox(height: 18),
          _TwoFactorOption(
            icon: Icons.phone_android_rounded,
            title: 'Authenticator App',
            subtitle: 'Recommended default',
            selected: _twoFactorMethod == 'Authenticator App',
            onTap: () => setState(() => _twoFactorMethod = 'Authenticator App'),
          ),
          const SizedBox(height: 10),
          _TwoFactorOption(
            icon: Icons.sms_outlined,
            title: 'SMS Verification',
            subtitle: 'Carrier messaging rates may apply',
            selected: _twoFactorMethod == 'SMS Verification',
            onTap: () => setState(() => _twoFactorMethod = 'SMS Verification'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard() {
    return _SecurityCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              CircleAvatar(
                backgroundColor: Color(0xFFF1F3ED),
                child: Icon(Icons.timer_outlined, color: primary),
              ),
              SizedBox(width: 10),
              Expanded(
                child: Text('Session Management',
                    style:
                        TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text('Idle Timeout Duration (Minutes)',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _idleTimeoutController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(filled: true),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Users will be automatically logged out after this period of inactivity.',
                  style: TextStyle(color: textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
          const Divider(height: 32),
          const Text('Concurrent Login Limit',
              style: TextStyle(fontWeight: FontWeight.w800)),
          const SizedBox(height: 8),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: TextField(
                  controller: _loginLimitController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(filled: true),
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Maximum number of active sessions allowed per user account.',
                  style: TextStyle(color: textMuted, fontSize: 12),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildWhitelistTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  backgroundColor: Color(0xFFF1F3ED),
                  child: Icon(Icons.router_outlined, color: primary),
                ),
                const SizedBox(width: 10),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('IP Whitelisting',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w800)),
                      Text('Restrict system access to approved network ranges.',
                          style: TextStyle(fontSize: 11, color: textMuted)),
                    ],
                  ),
                ),
                TextButton.icon(
                  onPressed: _addRange,
                  icon: const Icon(Icons.add_rounded),
                  label: const Text('Add Range'),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth =
                  constraints.maxWidth < 840 ? 840.0 : constraints.maxWidth;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FlexColumnWidth(1.4),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(1.8),
                      3: FlexColumnWidth(.8),
                      4: FixedColumnWidth(100),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF2F3ED)),
                        children: [
                          _SecurityTableCell('IP Range / Address',
                              header: true),
                          _SecurityTableCell('Department', header: true),
                          _SecurityTableCell('Description', header: true),
                          _SecurityTableCell('Status', header: true),
                          _SecurityTableCell('Actions', header: true),
                        ],
                      ),
                      ...List.generate(_ranges.length, (index) {
                        final entry = _ranges[index];
                        return TableRow(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(color: Color(0xFFE8EBE3)),
                            ),
                          ),
                          children: [
                            _SecurityTableCell(entry.cidr),
                            _SecurityTableCell(entry.name),
                            _SecurityTableCell(entry.description),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12, vertical: 14),
                              child: InkWell(
                                onTap: () => _toggleRange(index),
                                borderRadius: BorderRadius.circular(12),
                                child: ChipPill(
                                  entry.active ? '● Active' : '● Inactive',
                                  active: entry.active,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              child: Row(
                                children: [
                                  IconButton(
                                    tooltip: 'Edit range',
                                    onPressed: () => _editRange(index),
                                    icon: const Icon(Icons.edit_outlined,
                                        size: 18),
                                  ),
                                  IconButton(
                                    tooltip: 'Remove range',
                                    onPressed: () => _deleteRange(index),
                                    icon: const Icon(
                                        Icons.delete_outline_rounded,
                                        size: 18),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _SecurityCard extends StatelessWidget {
  const _SecurityCard({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: surface,
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
        ),
        child: child,
      );
}

class _TwoFactorOption extends StatelessWidget {
  const _TwoFactorOption({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
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
            border: Border.all(
              color: selected ? primary : border,
              width: selected ? 1.5 : 1,
            ),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(icon, color: primary),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    Text(subtitle,
                        style: const TextStyle(fontSize: 11, color: textMuted)),
                  ],
                ),
              ),
              Icon(
                selected ? Icons.radio_button_checked : Icons.radio_button_off,
                color: selected ? primary : textMuted,
                size: 18,
              ),
            ],
          ),
        ),
      );
}

class _SecurityTableCell extends StatelessWidget {
  const _SecurityTableCell(this.text, {this.header = false});

  final String text;
  final bool header;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 16),
        child: Text(
          text,
          style: TextStyle(
            color: header ? textMuted : const Color(0xFF222720),
            fontSize: header ? 10 : 12,
            fontWeight: header ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      );
}
