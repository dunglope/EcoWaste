import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class AddIpRangeDialog extends StatefulWidget {
  const AddIpRangeDialog({super.key, this.initial});

  final IpWhitelistEntry? initial;

  @override
  State<AddIpRangeDialog> createState() => _AddIpRangeDialogState();
}

class _AddIpRangeDialogState extends State<AddIpRangeDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _cidrController;
  late final TextEditingController _descriptionController;
  late bool _active;
  late Set<String> _permissions;

  static const _permissionOptions = [
    'Management API Access',
    'Mobile App Access',
    'Web Console Access',
  ];

  @override
  void initState() {
    super.initState();
    final initial = widget.initial;
    _nameController = TextEditingController(text: initial?.name ?? '');
    _cidrController = TextEditingController(text: initial?.cidr ?? '');
    _descriptionController =
        TextEditingController(text: initial?.description ?? '');
    _active = initial?.active ?? true;
    _permissions = {
      if (initial == null) ..._permissionOptions else ...initial.permissions,
    };
  }

  @override
  void dispose() {
    _nameController.dispose();
    _cidrController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  String? _validateCidr(String? value) {
    final input = value?.trim() ?? '';
    final parts = input.split('/');
    if (parts.length != 2)
      return 'Use CIDR format, for example 192.168.1.0/24.';
    final octets = parts.first.split('.');
    final prefix = int.tryParse(parts.last);
    final validOctets = octets.length == 4 &&
        octets.every((part) {
          final number = int.tryParse(part);
          return number != null && number >= 0 && number <= 255;
        });
    if (!validOctets || prefix == null || prefix < 0 || prefix > 32) {
      return 'Enter a valid IPv4 address and prefix.';
    }
    return null;
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (_permissions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Select at least one permission.'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    Navigator.of(context).pop(
      IpWhitelistEntry(
        name: _nameController.text.trim(),
        cidr: _cidrController.text.trim(),
        description: _descriptionController.text.trim(),
        active: _active,
        permissions: Set.unmodifiable(_permissions),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initial != null;
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      editing ? 'Edit IP Range' : 'Add Range',
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
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: alertSoft,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.warning_amber_rounded,
                                color: alert, size: 18),
                            SizedBox(width: 9),
                            Expanded(
                              child: Text(
                                'Security Warning: IP whitelisting restricts platform access to only the addresses listed. Ensure the current IP is included to avoid lockouts.',
                                style: TextStyle(fontSize: 10, color: alert),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const _FieldLabel('Name'),
                      TextFormField(
                        controller: _nameController,
                        decoration: const InputDecoration(
                          hintText: 'e.g., Office Headquarters',
                          filled: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Name is required.'
                                : null,
                      ),
                      const _FieldLabel('IP Address / CIDR Block'),
                      TextFormField(
                        controller: _cidrController,
                        decoration: const InputDecoration(
                          hintText: '192.168.1.0/24',
                          prefixIcon: Icon(Icons.lan_outlined),
                          filled: true,
                        ),
                        validator: _validateCidr,
                      ),
                      const _FieldLabel('Description'),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 3,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          hintText: 'Additional notes about this location...',
                          filled: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Description is required.'
                                : null,
                      ),
                      CheckboxListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        value: _active,
                        onChanged: (value) => setState(() => _active = value!),
                        title: const Text('Active immediately'),
                        controlAffinity: ListTileControlAffinity.leading,
                      ),
                      const _FieldLabel('Permissions / Scope'),
                      ..._permissionOptions.map((permission) {
                        return CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          dense: true,
                          value: _permissions.contains(permission),
                          onChanged: (selected) => setState(() {
                            selected!
                                ? _permissions.add(permission)
                                : _permissions.remove(permission);
                          }),
                          title: Text(permission),
                          controlAffinity: ListTileControlAffinity.leading,
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              color: const Color(0xFFF2F3ED),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 14),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(backgroundColor: primary),
                    child: Text(editing ? 'Save Range' : 'Add to Whitelist'),
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

class IpWhitelistEntry {
  const IpWhitelistEntry({
    required this.name,
    required this.cidr,
    required this.description,
    required this.active,
    required this.permissions,
  });

  final String name;
  final String cidr;
  final String description;
  final bool active;
  final Set<String> permissions;
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 5),
        child: Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );
}
