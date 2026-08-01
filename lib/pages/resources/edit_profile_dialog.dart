import 'package:flutter/material.dart';

import '../../app/theme.dart';

class EditProfileDialog extends StatefulWidget {
  const EditProfileDialog({super.key});

  @override
  State<EditProfileDialog> createState() => _EditProfileDialogState();
}

class _EditProfileDialogState extends State<EditProfileDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Robert Kilian');
  final _emailController = TextEditingController(
    text: 'robert.k@ecosystem.com',
  );
  final _phoneController = TextEditingController(text: '+1 (555) 019-2837');

  String _primaryShift = 'Afternoon (14:00 - 22:00)';
  bool _availableForOvertime = true;
  bool _hasProfilePhoto = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _changePhoto() {
    setState(() => _hasProfilePhoto = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile photo selected.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      const SnackBar(
        content: Text('Profile changes saved.'),
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
          maxWidth: 720,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Edit Profile',
                      style:
                          TextStyle(fontSize: 26, fontWeight: FontWeight.w800),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Close',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, size: 28),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF1F2EE),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Wrap(
                          spacing: 24,
                          runSpacing: 16,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            Stack(
                              clipBehavior: Clip.none,
                              children: [
                                CircleAvatar(
                                  radius: 54,
                                  backgroundColor: const Color(0xFFDDE5D9),
                                  child: _hasProfilePhoto
                                      ? const Text(
                                          'RK',
                                          style: TextStyle(
                                            color: primary,
                                            fontSize: 28,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        )
                                      : const Icon(
                                          Icons.person_outline_rounded,
                                          size: 42,
                                          color: textMuted,
                                        ),
                                ),
                                Positioned(
                                  right: -2,
                                  bottom: -2,
                                  child: CircleAvatar(
                                    radius: 19,
                                    backgroundColor: primary,
                                    child: IconButton(
                                      tooltip: 'Change photo',
                                      padding: EdgeInsets.zero,
                                      onPressed: _changePhoto,
                                      icon: const Icon(
                                        Icons.edit_rounded,
                                        size: 17,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 480),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Profile Picture',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  const Text(
                                    'Upload a new photo for your employee profile. JPG or PNG, max 2MB.',
                                    style: TextStyle(color: textMuted),
                                  ),
                                  const SizedBox(height: 14),
                                  Wrap(
                                    spacing: 14,
                                    runSpacing: 8,
                                    children: [
                                      OutlinedButton(
                                        onPressed: _changePhoto,
                                        child: const Text('Change Photo'),
                                      ),
                                      TextButton(
                                        onPressed: _hasProfilePhoto
                                            ? () => setState(
                                                  () =>
                                                      _hasProfilePhoto = false,
                                                )
                                            : null,
                                        style: TextButton.styleFrom(
                                          foregroundColor: alert,
                                        ),
                                        child: const Text('Remove'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 28),
                      const Text(
                        'Basic Information',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 600;
                          final fields = [
                            _ProfileField(
                              label: 'Full Name',
                              child: TextFormField(
                                controller: _nameController,
                                decoration: const InputDecoration(
                                  hintText: 'Full name',
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? 'Full name is required.'
                                        : null,
                              ),
                            ),
                            const _ProfileField(
                              label: 'Employee ID (Read-only)',
                              child: TextField(
                                enabled: false,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(Icons.lock_outline_rounded),
                                  hintText: 'EMP-0492',
                                ),
                              ),
                            ),
                            _ProfileField(
                              label: 'Email Address',
                              child: TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: const InputDecoration(
                                  hintText: 'Email address',
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  return email.contains('@')
                                      ? null
                                      : 'Enter a valid email address.';
                                },
                              ),
                            ),
                            _ProfileField(
                              label: 'Phone Number',
                              child: TextFormField(
                                controller: _phoneController,
                                keyboardType: TextInputType.phone,
                                decoration: const InputDecoration(
                                  hintText: 'Phone number',
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? 'Phone number is required.'
                                        : null,
                              ),
                            ),
                          ];

                          if (compact) {
                            return Column(
                              children: fields
                                  .map((field) => Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 14),
                                        child: field,
                                      ))
                                  .toList(),
                            );
                          }

                          return Wrap(
                            spacing: 28,
                            runSpacing: 18,
                            children: fields
                                .map((field) => SizedBox(
                                      width: (constraints.maxWidth - 28) / 2,
                                      child: field,
                                    ))
                                .toList(),
                          );
                        },
                      ),
                      const SizedBox(height: 26),
                      const Text(
                        'Shift Preferences',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      const SizedBox(height: 14),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 600;
                          final shift = _ProfileField(
                            label: 'Primary Shift',
                            child: DropdownButtonFormField<String>(
                              value: _primaryShift,
                              items: const [
                                'Morning (06:00 - 14:00)',
                                'Afternoon (14:00 - 22:00)',
                                'Night (22:00 - 06:00)',
                              ]
                                  .map((value) => DropdownMenuItem(
                                        value: value,
                                        child: Text(value),
                                      ))
                                  .toList(),
                              onChanged: (value) =>
                                  setState(() => _primaryShift = value!),
                            ),
                          );
                          final overtime = Row(
                            children: [
                              Switch(
                                value: _availableForOvertime,
                                onChanged: (value) => setState(
                                  () => _availableForOvertime = value,
                                ),
                                activeColor: primary,
                              ),
                              const SizedBox(width: 8),
                              const Flexible(
                                child: Text(
                                  'Available for Overtime',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          );

                          if (compact) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                shift,
                                const SizedBox(height: 14),
                                overtime
                              ],
                            );
                          }
                          return Row(
                            children: [
                              Expanded(child: shift),
                              const SizedBox(width: 28),
                              Expanded(child: overtime),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
              color: const Color(0xFFF2F3ED),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 18),
                  FilledButton(
                    onPressed: _save,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(168, 48),
                    ),
                    child: const Text('Save Changes'),
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

class _ProfileField extends StatelessWidget {
  const _ProfileField({required this.label, required this.child});

  final String label;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 8, bottom: 6),
          child: Text(
            label,
            style: const TextStyle(
              color: textMuted,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        child,
      ],
    );
  }
}
