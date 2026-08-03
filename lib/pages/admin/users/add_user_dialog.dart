import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class AddUserDialog extends StatefulWidget {
  const AddUserDialog({super.key});

  @override
  State<AddUserDialog> createState() => _AddUserDialogState();
}

class _AddUserDialogState extends State<AddUserDialog> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _departmentController = TextEditingController();
  String? _role;
  bool _imageSelected = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _departmentController.dispose();
    super.dispose();
  }

  void _selectImage() {
    setState(() => _imageSelected = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Profile image selected.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _createUser() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      UserAccount(
        fullName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        role: _role!,
        department: _departmentController.text.trim(),
        hasProfileImage: _imageSelected,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(modalRadius)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 560,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: modalChromeHeight,
              padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
              decoration: modalHeaderDecoration,
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Add New User',
                        style: TextStyle(
                            fontSize: 22, fontWeight: FontWeight.w800)),
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
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Stack(
                            clipBehavior: Clip.none,
                            children: [
                              CircleAvatar(
                                radius: 48,
                                backgroundColor: const Color(0xFFE5E9E0),
                                child: Icon(
                                  _imageSelected
                                      ? Icons.person_rounded
                                      : Icons.account_circle_outlined,
                                  size: 62,
                                  color: _imageSelected ? primary : textMuted,
                                ),
                              ),
                              Positioned(
                                right: -2,
                                bottom: 0,
                                child: CircleAvatar(
                                  radius: 17,
                                  backgroundColor: primary,
                                  child: IconButton(
                                    tooltip: 'Upload image',
                                    padding: EdgeInsets.zero,
                                    onPressed: _selectImage,
                                    icon: const Icon(Icons.camera_alt_outlined,
                                        size: 17, color: Colors.white),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 22),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text('Profile Picture',
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w800)),
                                const SizedBox(height: 4),
                                const Text('JPG, GIF or PNG. Max size 2MB.',
                                    style: TextStyle(
                                        color: textMuted, fontSize: 12)),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  children: [
                                    TextButton(
                                      onPressed: _selectImage,
                                      child: const Text('Upload Image'),
                                    ),
                                    TextButton(
                                      onPressed: _imageSelected
                                          ? () => setState(
                                                () => _imageSelected = false,
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
                      const _FieldLabel('Full Name'),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(
                          hintText: 'e.g. Elena Rodriguez',
                          filled: true,
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Full name is required.'
                                : null,
                      ),
                      const _FieldLabel('Email Address'),
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          hintText: 'elena.r@gmail.com',
                          filled: true,
                        ),
                        validator: (value) {
                          final email = value?.trim() ?? '';
                          return email.contains('@') && email.contains('.')
                              ? null
                              : 'Enter a valid email address.';
                        },
                      ),
                      const SizedBox(height: 4),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final compact = constraints.maxWidth < 440;
                          final roleField = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('Role'),
                              DropdownButtonFormField<String>(
                                value: _role,
                                hint: const Text('Select Role'),
                                decoration: const InputDecoration(filled: true),
                                items: const ['Admin', 'Driver']
                                    .map((value) => DropdownMenuItem(
                                          value: value,
                                          child: Text(value),
                                        ))
                                    .toList(),
                                onChanged: (value) =>
                                    setState(() => _role = value),
                                validator: (value) =>
                                    value == null ? 'Select a role.' : null,
                              ),
                            ],
                          );
                          final departmentField = Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const _FieldLabel('Department'),
                              TextFormField(
                                controller: _departmentController,
                                decoration: const InputDecoration(
                                  hintText: 'e.g. Operations',
                                  filled: true,
                                ),
                                validator: (value) =>
                                    value == null || value.trim().isEmpty
                                        ? 'Department is required.'
                                        : null,
                              ),
                            ],
                          );
                          if (compact) {
                            return Column(
                              children: [
                                roleField,
                                const SizedBox(height: 6),
                                departmentField,
                              ],
                            );
                          }
                          return Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(child: roleField),
                              const SizedBox(width: 18),
                              Expanded(child: departmentField),
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
              height: modalChromeHeight,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: modalFooterDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 18),
                  FilledButton(
                    onPressed: _createUser,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(160, 46),
                    ),
                    child: const Text('Create User'),
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

class UserAccount {
  const UserAccount({
    required this.fullName,
    required this.email,
    required this.role,
    required this.department,
    this.hasProfileImage = false,
  });

  final String fullName;
  final String email;
  final String role;
  final String department;
  final bool hasProfileImage;

  String get initials {
    final names = fullName.trim().split(RegExp(r'\s+'));
    return names.take(2).map((name) => name[0].toUpperCase()).join();
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 14, bottom: 6),
        child: Text(label,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w800)),
      );
}
