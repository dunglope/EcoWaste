import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'users/add_user_dialog.dart';

class UsersPage extends StatefulWidget {
  const UsersPage({super.key});

  @override
  State<UsersPage> createState() => _UsersPageState();
}

class _UsersPageState extends State<UsersPage> {
  final _searchController = TextEditingController();
  String _roleFilter = 'All';
  int _rowsPerPage = 4;
  int _page = 0;
  int? _selectedUser;

  final List<UserAccount> _users = [
    const UserAccount(
      fullName: 'Sarah Jenkins',
      email: 's.jenkins@eco.gov',
      role: 'Admin',
      department: 'IT Systems',
      hasProfileImage: true,
    ),
    const UserAccount(
      fullName: 'David Chen',
      email: 'd.chen@eco.gov',
      role: 'Driver',
      department: 'Fleet Operations',
      hasProfileImage: true,
    ),
    const UserAccount(
      fullName: 'Marcus Johnson',
      email: 'm.johnson@eco.gov',
      role: 'Driver',
      department: 'Fleet Operations',
    ),
    const UserAccount(
      fullName: 'Elena Rodriguez',
      email: 'e.rodriguez@eco.gov',
      role: 'Driver',
      department: 'Fleet Operations',
      hasProfileImage: true,
    ),
    const UserAccount(
      fullName: 'Amelia Wilson',
      email: 'a.wilson@eco.gov',
      role: 'Admin',
      department: 'Operations',
    ),
    const UserAccount(
      fullName: 'Noah Williams',
      email: 'n.williams@eco.gov',
      role: 'Driver',
      department: 'Analytics',
    ),
    const UserAccount(
      fullName: 'Sophia Brown',
      email: 's.brown@eco.gov',
      role: 'Driver',
      department: 'North District',
    ),
    const UserAccount(
      fullName: 'Liam Davis',
      email: 'l.davis@eco.gov',
      role: 'Driver',
      department: 'Compliance',
    ),
    const UserAccount(
      fullName: 'Olivia Miller',
      email: 'o.miller@eco.gov',
      role: 'Driver',
      department: 'South District',
    ),
    const UserAccount(
      fullName: 'James Moore',
      email: 'j.moore@eco.gov',
      role: 'Admin',
      department: 'System Security',
    ),
    const UserAccount(
      fullName: 'Mia Taylor',
      email: 'm.taylor@eco.gov',
      role: 'Driver',
      department: 'Fleet Operations',
    ),
    const UserAccount(
      fullName: 'Ethan Anderson',
      email: 'e.anderson@eco.gov',
      role: 'Driver',
      department: 'Planning',
    ),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<UserAccount> get _filteredUsers {
    final query = _searchController.text.trim().toLowerCase();
    return _users.where((user) {
      final matchesQuery = query.isEmpty ||
          user.fullName.toLowerCase().contains(query) ||
          user.email.toLowerCase().contains(query);
      final matchesRole = _roleFilter == 'All' || user.role == _roleFilter;
      return matchesQuery && matchesRole;
    }).toList();
  }

  List<UserAccount> get _visibleUsers {
    final start = _page * _rowsPerPage;
    if (start >= _filteredUsers.length)
      return _filteredUsers.take(_rowsPerPage).toList();
    return _filteredUsers.skip(start).take(_rowsPerPage).toList();
  }

  int get _lastPage =>
      _filteredUsers.isEmpty ? 0 : (_filteredUsers.length - 1) ~/ _rowsPerPage;

  void _setRoleFilter(String role) {
    setState(() {
      _roleFilter = _roleFilter == role ? 'All' : role;
      _page = 0;
      _selectedUser = null;
    });
  }

  Future<void> _addUser() async {
    final user = await showDialog<UserAccount>(
      context: context,
      builder: (context) => const AddUserDialog(),
    );
    if (user == null || !mounted) return;
    setState(() {
      _users.insert(0, user);
      _searchController.clear();
      _roleFilter = 'All';
      _page = 0;
      _selectedUser = 0;
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${user.fullName} was added successfully.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'User Management',
      subtitle: 'Manage system users, roles, and access levels.',
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: surface,
            border: Border.all(color: border),
            borderRadius: BorderRadius.circular(8),
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final search = SearchBar(
                controller: _searchController,
                hintText: 'Search users by name or email...',
                leading: const Icon(Icons.search_rounded),
                onChanged: (_) => setState(() {
                  _page = 0;
                  _selectedUser = null;
                }),
              );
              final controls = Wrap(
                spacing: 8,
                runSpacing: 8,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  FilterChip(
                    label: const Text('Driver'),
                    selected: _roleFilter == 'Driver',
                    showCheckmark: false,
                    selectedColor: primarySoft,
                    onSelected: (_) => _setRoleFilter('Driver'),
                  ),
                  FilterChip(
                    label: const Text('Admin'),
                    selected: _roleFilter == 'Admin',
                    showCheckmark: false,
                    selectedColor: primarySoft,
                    onSelected: (_) => _setRoleFilter('Admin'),
                  ),
                  FilledButton.icon(
                    onPressed: _addUser,
                    icon: const Icon(Icons.person_add_alt_1_rounded),
                    label: const Text('Add User'),
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(120, 44),
                    ),
                  ),
                ],
              );
              if (constraints.maxWidth < 680) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    search,
                    const SizedBox(height: 12),
                    controls,
                  ],
                );
              }
              return Row(
                children: [
                  Expanded(child: search),
                  const SizedBox(width: 16),
                  controls,
                ],
              );
            },
          ),
        ),
        const SizedBox(height: 20),
        _buildUserTable(),
      ],
    );
  }

  Widget _buildUserTable() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: surface,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              final tableWidth =
                  constraints.maxWidth < 820 ? 820.0 : constraints.maxWidth;
              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Table(
                    columnWidths: const {
                      0: FixedColumnWidth(70),
                      1: FlexColumnWidth(1.2),
                      2: FlexColumnWidth(2.2),
                      3: FlexColumnWidth(1),
                      4: FlexColumnWidth(1.4),
                    },
                    children: [
                      const TableRow(
                        decoration: BoxDecoration(color: Color(0xFFF2F3ED)),
                        children: [
                          _UserCell('Avatar', header: true),
                          _UserCell('Full Name', header: true),
                          _UserCell('Email', header: true),
                          _UserCell('Role', header: true),
                          _UserCell('Department', header: true),
                        ],
                      ),
                      ...List.generate(_visibleUsers.length, (rowIndex) {
                        final user = _visibleUsers[rowIndex];
                        final absoluteIndex = _users.indexOf(user);
                        final selected = _selectedUser == absoluteIndex;
                        void select() =>
                            setState(() => _selectedUser = absoluteIndex);
                        return TableRow(
                          decoration: BoxDecoration(
                            color: selected
                                ? const Color(0xFFEEF8EC)
                                : Colors.transparent,
                            border: const Border(
                              bottom: BorderSide(color: Color(0xFFE8EBE3)),
                            ),
                          ),
                          children: [
                            _UserCellWidget(
                              onTap: select,
                              child: CircleAvatar(
                                radius: 17,
                                backgroundColor: user.hasProfileImage
                                    ? const Color(0xFFDDE7D9)
                                    : primary,
                                child: Text(
                                  user.initials,
                                  style: TextStyle(
                                    color: user.hasProfileImage
                                        ? primary
                                        : Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ),
                            ),
                            _UserCell(user.fullName,
                                onTap: select, strong: true),
                            _UserCell(user.email, onTap: select),
                            _UserCellWidget(
                              onTap: select,
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: _RoleBadge(user.role),
                              ),
                            ),
                            _UserCell(user.department, onTap: select),
                          ],
                        );
                      }),
                    ],
                  ),
                ),
              );
            },
          ),
          Container(
            height: 54,
            padding: const EdgeInsets.symmetric(horizontal: 14),
            color: const Color(0xFFF2F3ED),
            child: Row(
              children: [
                const Text('Rows per page:',
                    style: TextStyle(fontSize: 11, color: textMuted)),
                const SizedBox(width: 8),
                DropdownButton<int>(
                  value: _rowsPerPage,
                  underline: const SizedBox.shrink(),
                  items: const [4, 8, 10]
                      .map((value) => DropdownMenuItem(
                            value: value,
                            child: Text('$value'),
                          ))
                      .toList(),
                  onChanged: (value) => setState(() {
                    _rowsPerPage = value!;
                    _page = 0;
                  }),
                ),
                const Spacer(),
                Text(
                  _filteredUsers.isEmpty
                      ? '0 of 0'
                      : '${_page * _rowsPerPage + 1}-${_page * _rowsPerPage + _visibleUsers.length} of ${_filteredUsers.length}',
                  style: const TextStyle(fontSize: 11),
                ),
                const SizedBox(width: 10),
                IconButton(
                  tooltip: 'First page',
                  onPressed: _page > 0 ? () => setState(() => _page = 0) : null,
                  icon: const Icon(Icons.first_page_rounded, size: 19),
                ),
                IconButton(
                  tooltip: 'Previous page',
                  onPressed: _page > 0 ? () => setState(() => _page--) : null,
                  icon: const Icon(Icons.chevron_left_rounded, size: 19),
                ),
                IconButton(
                  tooltip: 'Next page',
                  onPressed:
                      _page < _lastPage ? () => setState(() => _page++) : null,
                  icon: const Icon(Icons.chevron_right_rounded, size: 19),
                ),
                IconButton(
                  tooltip: 'Last page',
                  onPressed: _page < _lastPage
                      ? () => setState(() => _page = _lastPage)
                      : null,
                  icon: const Icon(Icons.last_page_rounded, size: 19),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _UserCell extends StatelessWidget {
  const _UserCell(
    this.text, {
    this.header = false,
    this.strong = false,
    this.onTap,
  });

  final String text;
  final bool header;
  final bool strong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 17),
          child: Text(
            text,
            style: TextStyle(
              color: header ? textMuted : const Color(0xFF222720),
              fontSize: header ? 10 : 12,
              fontWeight: header || strong ? FontWeight.w800 : FontWeight.w500,
            ),
          ),
        ),
      );
}

class _UserCellWidget extends StatelessWidget {
  const _UserCellWidget({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: child,
        ),
      );
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge(this.role);
  final String role;

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'Admin';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: isAdmin ? purple : const Color(0xFFE9ECE5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        role,
        style: TextStyle(
          color: isAdmin ? Colors.white : const Color(0xFF30352E),
          fontSize: 10,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
