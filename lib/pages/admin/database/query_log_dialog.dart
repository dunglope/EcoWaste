import 'package:flutter/material.dart';

import '../../../app/theme.dart';
import '../../../shared/widgets.dart';

class QueryLogDialog extends StatefulWidget {
  const QueryLogDialog({super.key});

  @override
  State<QueryLogDialog> createState() => _QueryLogDialogState();
}

class _QueryLogDialogState extends State<QueryLogDialog> {
  String _queryType = 'All Query Types';
  bool _slowOnly = false;
  int _page = 0;
  String _lastRefresh = 'Latest First';

  static const _logs = [
    _QueryLog(
        '2023-11-24\n14:28:45.021',
        'SELECT',
        'SELECT * FROM assets.bin_sensors WHERE bin_id = ?',
        '12ms',
        'Jane Doe',
        true),
    _QueryLog(
        '2023-11-24\n14:28:42.880',
        'UPDATE',
        'UPDATE logistics.route_schedule SET status = ?',
        '45ms',
        'Admin Main',
        true),
    _QueryLog(
        '2023-11-24\n14:28:39.112',
        'SELECT',
        'SELECT geometry, capacity_rate FROM assets.bins JOIN...',
        '1,420ms',
        'Sys_Agent_04',
        false),
    _QueryLog(
        '2023-11-24\n14:28:35.452',
        'INSERT',
        'INSERT INTO logs.incident_report (type, severity, ...)',
        '32ms',
        'Jane Doe',
        true),
    _QueryLog(
        '2023-11-24\n14:28:31.002',
        'SELECT',
        'SELECT * FROM metadata.system_config WHERE key LIKE ?',
        '8ms',
        'Admin Main',
        true),
    _QueryLog(
        '2023-11-24\n14:28:28.115',
        'SELECT',
        'SELECT count(*) FROM assets.truck_locations WHERE ...',
        '15ms',
        'Jane Doe',
        true),
    _QueryLog(
        '2023-11-24\n14:28:25.044',
        'UPDATE',
        'UPDATE assets.bin_sensors SET battery_level = 94',
        '28ms',
        'Sys_Agent_04',
        true),
  ];

  List<_QueryLog> get _filteredLogs => _logs.where((log) {
        final typeMatches =
            _queryType == 'All Query Types' || log.type == _queryType;
        final slowMatches = !_slowOnly || log.duration.contains(',');
        return typeMatches && slowMatches;
      }).toList();

  List<_QueryLog> get _visibleLogs {
    final start = _page * 5;
    if (start >= _filteredLogs.length) return _filteredLogs.take(5).toList();
    return _filteredLogs.skip(start).take(5).toList();
  }

  void _showStatement(_QueryLog log) {
    showDialog<void>(
      context: context,
      builder: (context) => EcoModalDialog(
        title: '${log.type} Statement',
        body: SelectableText(log.statement),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(18),
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(modalRadius)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1040,
          maxHeight: MediaQuery.sizeOf(context).height * .94,
        ),
        child: Column(
          children: [
            Container(
              height: modalChromeHeight,
              padding: const EdgeInsets.fromLTRB(12, 8, 6, 8),
              decoration: modalHeaderDecoration,
              child: Row(
                children: [
                  const Icon(Icons.history_rounded, color: primary),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Query Log Viewer',
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.w800)),
                        Text(
                            'Viewing top 1000 rows | Filtered by $_lastRefresh',
                            style: const TextStyle(
                                fontSize: 10, color: textMuted)),
                      ],
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
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  SizedBox(
                    width: 160,
                    child: DropdownButtonFormField<String>(
                      value: _queryType,
                      decoration: const InputDecoration(
                        isDense: true,
                        filled: true,
                      ),
                      items: const [
                        'All Query Types',
                        'SELECT',
                        'UPDATE',
                        'INSERT',
                      ]
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _queryType = value!;
                        _page = 0;
                      }),
                    ),
                  ),
                  const SizedBox(width: 10),
                  FilterChip(
                    label: const Text('Advanced Filters'),
                    avatar: const Icon(Icons.filter_list_rounded, size: 17),
                    selected: _slowOnly,
                    selectedColor: primarySoft,
                    onSelected: (value) => setState(() {
                      _slowOnly = value;
                      _page = 0;
                    }),
                  ),
                  const Spacer(),
                  FilledButton.icon(
                    onPressed: () {
                      setState(() => _lastRefresh = 'Latest First · Just now');
                      _showMessage('Query logs refreshed.');
                    },
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Refresh Logs'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton.icon(
                    onPressed: () =>
                        _showMessage('Query logs exported to CSV.'),
                    icon: const Icon(Icons.download_rounded),
                    label: const Text('Export to CSV'),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: 1000,
                  child: SingleChildScrollView(
                    child: DataTable(
                      headingRowColor: WidgetStateProperty.all(
                        modalControlFill,
                      ),
                      columns: const [
                        DataColumn(label: Text('TIMESTAMP')),
                        DataColumn(label: Text('QUERY TYPE')),
                        DataColumn(label: Text('STATEMENT SNIPPET')),
                        DataColumn(label: Text('DURATION')),
                        DataColumn(label: Text('USER')),
                        DataColumn(label: Text('STATUS')),
                      ],
                      rows: _visibleLogs.map((log) {
                        final slow = log.duration.contains(',');
                        return DataRow(cells: [
                          DataCell(Text(log.timestamp,
                              style: const TextStyle(fontSize: 11))),
                          DataCell(_QueryTypeBadge(log.type)),
                          DataCell(
                            SizedBox(
                              width: 340,
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(log.statement,
                                        overflow: TextOverflow.ellipsis,
                                        style: const TextStyle(
                                            fontFamily: 'monospace',
                                            fontSize: 10)),
                                  ),
                                  IconButton(
                                    tooltip: 'View statement',
                                    onPressed: () => _showStatement(log),
                                    icon: const Icon(Icons.visibility_outlined,
                                        size: 16),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          DataCell(Text(log.duration,
                              style: TextStyle(
                                  color: slow ? alert : null,
                                  fontWeight: slow
                                      ? FontWeight.w800
                                      : FontWeight.w500))),
                          DataCell(Text(log.user,
                              style: const TextStyle(fontSize: 11))),
                          DataCell(Icon(
                            log.success
                                ? Icons.check_circle_outline_rounded
                                : Icons.warning_amber_rounded,
                            color: log.success ? primary : alert,
                            size: 18,
                          )),
                        ]);
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: modalChromeHeight,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: modalFooterDecoration,
              child: Row(
                children: [
                  Text(
                    'Showing ${_visibleLogs.length} of ${_filteredLogs.length} filtered transactions',
                    style: const TextStyle(fontSize: 10),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    tooltip: 'Previous page',
                    onPressed: _page > 0 ? () => setState(() => _page--) : null,
                    icon: const Icon(Icons.chevron_left_rounded),
                  ),
                  IconButton(
                    tooltip: 'Next page',
                    onPressed: (_page + 1) * 5 < _filteredLogs.length
                        ? () => setState(() => _page++)
                        : null,
                    icon: const Icon(Icons.chevron_right_rounded),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Close'),
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

class _QueryLog {
  const _QueryLog(this.timestamp, this.type, this.statement, this.duration,
      this.user, this.success);

  final String timestamp;
  final String type;
  final String statement;
  final String duration;
  final String user;
  final bool success;
}

class _QueryTypeBadge extends StatelessWidget {
  const _QueryTypeBadge(this.type);
  final String type;

  @override
  Widget build(BuildContext context) {
    final color = switch (type) {
      'UPDATE' => const Color(0xFF1A9B67),
      'INSERT' => const Color(0xFFC46A18),
      _ => const Color(0xFF3367B1),
    };
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(type,
          style: TextStyle(
              color: color, fontSize: 9, fontWeight: FontWeight.w800)),
    );
  }
}
