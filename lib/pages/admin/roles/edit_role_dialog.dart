import 'package:flutter/material.dart';

import '../../../app/theme.dart';

class EditRoleDialog extends StatefulWidget {
  const EditRoleDialog({super.key, required this.initial});

  final RoleConfiguration initial;

  @override
  State<EditRoleDialog> createState() => _EditRoleDialogState();
}

class _EditRoleDialogState extends State<EditRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late Map<String, ModulePermissions> _permissions;
  late String _scope;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initial.name);
    _descriptionController =
        TextEditingController(text: widget.initial.description);
    _permissions = {
      for (final entry in widget.initial.permissions.entries)
        entry.key: entry.value.copyWith(),
    };
    _scope = widget.initial.scope;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      RoleConfiguration(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        permissions: Map.unmodifiable(_permissions),
        scope: _scope,
      ),
    );
  }

  void _updatePermission(
    String module,
    ModulePermissions Function(ModulePermissions current) update,
  ) {
    setState(() => _permissions[module] = update(_permissions[module]!));
  }

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
              padding: const EdgeInsets.fromLTRB(14, 7, 7, 7),
              color: const Color(0xFFF2F3ED),
              child: Row(
                children: [
                  const Expanded(
                    child: Text('Edit Role Configuration',
                        style: TextStyle(
                            fontSize: 19, fontWeight: FontWeight.w800)),
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
                      const _FieldLabel('Role Name'),
                      TextFormField(
                        controller: _nameController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(filled: true),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Role name is required.'
                                : null,
                      ),
                      const _FieldLabel('Role Description'),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 3,
                        maxLines: 3,
                        decoration: const InputDecoration(filled: true),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Role description is required.'
                                : null,
                      ),
                      const SizedBox(height: 22),
                      Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: BoxDecoration(
                          border: Border.all(color: border),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Table(
                          columnWidths: const {
                            0: FlexColumnWidth(1.7),
                            1: FlexColumnWidth(1),
                            2: FlexColumnWidth(1),
                            3: FlexColumnWidth(1),
                          },
                          children: [
                            const TableRow(
                              decoration:
                                  BoxDecoration(color: Color(0xFFE9ECE5)),
                              children: [
                                _PermissionCell('MODULE', header: true),
                                _PermissionCell('VIEW', header: true),
                                _PermissionCell('EDIT', header: true),
                                _PermissionCell('DELETE', header: true),
                              ],
                            ),
                            ..._permissions.entries.map((entry) {
                              final module = entry.key;
                              final permission = entry.value;
                              return TableRow(
                                decoration: const BoxDecoration(
                                  border: Border(
                                    bottom: BorderSide(
                                      color: Color(0xFFE8EBE3),
                                    ),
                                  ),
                                ),
                                children: [
                                  _PermissionCell(module),
                                  _PermissionCheckbox(
                                    value: permission.view,
                                    onChanged: (value) => _updatePermission(
                                      module,
                                      (current) =>
                                          current.copyWith(view: value),
                                    ),
                                  ),
                                  _PermissionCheckbox(
                                    value: permission.edit,
                                    onChanged: (value) => _updatePermission(
                                      module,
                                      (current) =>
                                          current.copyWith(edit: value),
                                    ),
                                  ),
                                  _PermissionCheckbox(
                                    value: permission.delete,
                                    onChanged: (value) => _updatePermission(
                                      module,
                                      (current) =>
                                          current.copyWith(delete: value),
                                    ),
                                  ),
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                      const SizedBox(height: 22),
                      LayoutBuilder(
                        builder: (context, constraints) {
                          final width = constraints.maxWidth < 460
                              ? constraints.maxWidth
                              : (constraints.maxWidth - 20) / 3;
                          return Wrap(
                            spacing: 10,
                            runSpacing: 10,
                            children: [
                              _ScopeOption(
                                width: width,
                                title: 'Global',
                                description: 'Full system-wide data access',
                                selected: _scope == 'Global',
                                onTap: () => setState(() => _scope = 'Global'),
                              ),
                              _ScopeOption(
                                width: width,
                                title: 'Regional',
                                description: 'Specific regional zones only',
                                selected: _scope == 'Regional',
                                onTap: () =>
                                    setState(() => _scope = 'Regional'),
                              ),
                              _ScopeOption(
                                width: width,
                                title: 'Department',
                                description: 'Limited to single department',
                                selected: _scope == 'Department',
                                onTap: () =>
                                    setState(() => _scope = 'Department'),
                              ),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                      minimumSize: const Size(90, 42),
                    ),
                    child: const Text('Save'),
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

class RoleConfiguration {
  const RoleConfiguration({
    required this.name,
    required this.description,
    required this.permissions,
    required this.scope,
  });

  final String name;
  final String description;
  final Map<String, ModulePermissions> permissions;
  final String scope;

  int get enabledPermissionCount => permissions.values.fold(
        0,
        (total, permission) =>
            total +
            (permission.view ? 1 : 0) +
            (permission.edit ? 1 : 0) +
            (permission.delete ? 1 : 0),
      );
}

class ModulePermissions {
  const ModulePermissions({
    this.view = false,
    this.edit = false,
    this.delete = false,
  });

  final bool view;
  final bool edit;
  final bool delete;

  ModulePermissions copyWith({bool? view, bool? edit, bool? delete}) {
    return ModulePermissions(
      view: view ?? this.view,
      edit: edit ?? this.edit,
      delete: delete ?? this.delete,
    );
  }
}

class _FieldLabel extends StatelessWidget {
  const _FieldLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 12, bottom: 6),
        child: Text(label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w800)),
      );
}

class _PermissionCell extends StatelessWidget {
  const _PermissionCell(this.text, {this.header = false});

  final String text;
  final bool header;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 13),
        child: Text(
          text,
          style: TextStyle(
            fontSize: header ? 10 : 11,
            color: header ? textMuted : const Color(0xFF222720),
            fontWeight: header ? FontWeight.w900 : FontWeight.w700,
          ),
        ),
      );
}

class _PermissionCheckbox extends StatelessWidget {
  const _PermissionCheckbox({required this.value, required this.onChanged});

  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => Center(
        child: Checkbox(
          value: value,
          onChanged: (selected) => onChanged(selected!),
        ),
      );
}

class _ScopeOption extends StatelessWidget {
  const _ScopeOption({
    required this.width,
    required this.title,
    required this.description,
    required this.selected,
    required this.onTap,
  });

  final double width;
  final String title;
  final String description;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: width,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(8),
          child: Container(
            height: 100,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: selected ? primarySoft : const Color(0xFFF7F8F3),
              border: Border.all(color: selected ? primary : border),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(title,
                          style: const TextStyle(fontWeight: FontWeight.w800)),
                    ),
                    Icon(
                      selected
                          ? Icons.radio_button_checked
                          : Icons.radio_button_off,
                      size: 17,
                      color: selected ? primary : textMuted,
                    ),
                  ],
                ),
                const SizedBox(height: 7),
                Text(description,
                    style: const TextStyle(fontSize: 10, color: textMuted)),
              ],
            ),
          ),
        ),
      );
}
