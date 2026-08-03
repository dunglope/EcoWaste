import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class IncidentsPage extends StatelessWidget {
  const IncidentsPage({super.key});

  void _showReportDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) => const ReportIncidentDialog(),
    );
  }

  @override
  Widget build(BuildContext context) => PageScaffold(
        title: 'Field Incident Reports',
        subtitle:
            'Real-time monitoring and management of infrastructure anomalies.',
        actions: [
          FilledButton.icon(
            onPressed: () => _showReportDialog(context),
            icon: const Icon(Icons.warning_amber_rounded),
            label: const Text('Report New Incident'),
            style: FilledButton.styleFrom(
              backgroundColor: primary,
              minimumSize: const Size(190, 46),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24)),
            ),
          )
        ],
        children: [
          AppCard(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: const [
                Text('Status:', style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 10),
                ChipPill('All', active: true),
                SizedBox(width: 8),
                ChipPill('Open'),
                SizedBox(width: 8),
                ChipPill('In Progress'),
                SizedBox(width: 8),
                ChipPill('Resolved'),
                SizedBox(width: 26),
                Text('Priority:',
                    style: TextStyle(fontWeight: FontWeight.w700)),
                SizedBox(width: 10),
                ChipPill('Emergency', danger: true),
                SizedBox(width: 8),
                ChipPill('High'),
                Spacer(),
                SizedBox(
                  width: 260,
                  child: SearchBar(
                    hintText: 'Filter by ID or reporter...',
                    leading: Icon(Icons.filter_list_rounded),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Expanded(flex: 7, child: IncidentReportTable()),
              SizedBox(width: 16),
              SizedBox(width: 250, child: IncidentClusterPreview()),
            ],
          ),
        ],
      );
}

class IncidentReportTable extends StatelessWidget {
  const IncidentReportTable({super.key});

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.9),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.2),
                3: FlexColumnWidth(1.5),
                4: FlexColumnWidth(1.1),
                5: FlexColumnWidth(1.1),
                6: FlexColumnWidth(.9),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color(0xFFEAEDE6),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  children: [
                    IncidentHeader('ID'),
                    IncidentHeader('Type'),
                    IncidentHeader('Priority'),
                    IncidentHeader('Reported By'),
                    IncidentHeader('Location'),
                    IncidentHeader('Status'),
                    IncidentHeader('Actions'),
                  ],
                ),
                _incidentRow(
                  id: '#INC-4029',
                  icon: Icons.delete_outline_rounded,
                  type: 'Overflow',
                  priority: const ChipPill('Emergency', danger: true),
                  reporter: 'John Doe\nField Agent 4',
                  location: '40.7128° N\n74.0060° W',
                  status: 'Open',
                ),
                _incidentRow(
                  id: '#INC-4028',
                  icon: Icons.handyman_rounded,
                  type: 'Damage',
                  priority: const ChipPill('High'),
                  reporter: 'Sensor #0921\nAutomated Alert',
                  location: '34.0522° N\n118.2437° W',
                  status: 'In Progress',
                ),
                _incidentRow(
                  id: '#INC-4027',
                  icon: Icons.event_busy_rounded,
                  type: 'Missed Collection',
                  priority: const ChipPill('Low'),
                  reporter: 'Citizen Portal\nExternal Report',
                  location: '51.5074° N\n0.1278° W',
                  status: 'Resolved',
                ),
              ],
            ),
            Container(
              height: 52,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: const BoxDecoration(color: Color(0xFFEAEDE6)),
              child: const Row(
                children: [
                  Text('Showing 1-12 of 248 incidents'),
                  Spacer(),
                  Icon(Icons.chevron_left_rounded),
                  SizedBox(width: 16),
                  Icon(Icons.chevron_right_rounded),
                ],
              ),
            ),
          ],
        ),
      );

  static TableRow _incidentRow({
    required String id,
    required IconData icon,
    required String type,
    required Widget priority,
    required String reporter,
    required String location,
    required String status,
  }) {
    return TableRow(
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFE8EBE3))),
      ),
      children: [
        IncidentCell(Text(id,
            style:
                const TextStyle(color: primary, fontWeight: FontWeight.w900))),
        IncidentCell(Row(children: [
          Icon(icon, size: 18, color: const Color(0xFF346B3B)),
          const SizedBox(width: 8),
          Flexible(
              child: Text(type,
                  style: const TextStyle(fontWeight: FontWeight.w700))),
        ])),
        IncidentCell(Align(alignment: Alignment.centerLeft, child: priority)),
        IncidentCell(Text(reporter)),
        IncidentCell(Text(location)),
        IncidentCell(Row(children: [
          Icon(Icons.circle,
              size: 8, color: status == 'Resolved' ? textMuted : primary),
          const SizedBox(width: 6),
          Flexible(child: Text(status)),
        ])),
        const IncidentCell(Icon(Icons.more_horiz_rounded)),
      ],
    );
  }
}

class IncidentHeader extends StatelessWidget {
  const IncidentHeader(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 18),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11, color: textMuted, fontWeight: FontWeight.w900)),
      );
}

class IncidentCell extends StatelessWidget {
  const IncidentCell(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 20),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 12, color: Color(0xFF1D241B)),
          child: child,
        ),
      );
}

class IncidentClusterPreview extends StatelessWidget {
  const IncidentClusterPreview({super.key});

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.radar_rounded, size: 18, color: primary),
                  SizedBox(width: 8),
                  Expanded(
                    child: Text('Cluster\nPreview',
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w900)),
                  ),
                  Text('Expand Full\nMap',
                      textAlign: TextAlign.right,
                      style: TextStyle(fontSize: 10, color: textMuted)),
                ],
              ),
            ),
            Stack(
              children: const [
                FakeMap(height: 440, label: ''),
                Positioned(
                  left: 100,
                  top: 210,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: alert,
                    child: Text('!', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                children: [
                  MetricLine('Emergencies in View', '4'),
                  MetricLine('Active Crews nearby', '12'),
                ],
              ),
            )
          ],
        ),
      );
}

class ReportIncidentDialog extends StatefulWidget {
  const ReportIncidentDialog({super.key});

  @override
  State<ReportIncidentDialog> createState() => _ReportIncidentDialogState();
}

class _ReportIncidentDialogState extends State<ReportIncidentDialog> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();

  String _incidentType = 'Overflow';
  String _severity = 'Medium';
  String _location = '40.7128° N, 74.0060° W';
  String? _evidenceName;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  void _chooseEvidence() {
    setState(() => _evidenceName = 'incident_evidence.jpg');
  }

  void _chooseLocation() {
    setState(() => _location = '40.7134° N, 74.0054° W');
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final messenger = ScaffoldMessenger.of(context);
    Navigator.of(context).pop();
    messenger.showSnackBar(
      SnackBar(
        content: Text('$_severity $_incidentType incident submitted.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(modalRadius)),
      clipBehavior: Clip.antiAlias,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 500,
          maxHeight: MediaQuery.sizeOf(context).height * .92,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: modalChromeHeight,
              decoration: modalHeaderDecoration,
              padding: const EdgeInsets.fromLTRB(16, 10, 8, 10),
              child: Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Report New Incident',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
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
                padding: const EdgeInsets.all(14),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      formLabel('Incident Type'),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: _incidentType,
                        decoration: const InputDecoration(
                          filled: true,
                          fillColor: Color(0xFFF1F2EE),
                        ),
                        items: const [
                          'Overflow',
                          'Damage',
                          'Missed Collection',
                          'Vehicle Breakdown',
                          'Blocked Access',
                        ]
                            .map((type) => DropdownMenuItem(
                                  value: type,
                                  child: Text(type),
                                ))
                            .toList(),
                        onChanged: (value) =>
                            setState(() => _incidentType = value!),
                      ),
                      formLabel('Severity Level'),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: ['Emergency', 'High', 'Medium', 'Low']
                            .map((level) => ChoiceChip(
                                  label: Text(level),
                                  selected: _severity == level,
                                  selectedColor: primarySoft,
                                  showCheckmark: false,
                                  onSelected: (_) =>
                                      setState(() => _severity = level),
                                ))
                            .toList(),
                      ),
                      formLabel('Description'),
                      TextFormField(
                        controller: _descriptionController,
                        minLines: 4,
                        maxLines: 4,
                        decoration: const InputDecoration(
                          hintText: 'Provide details about the incident...',
                          filled: true,
                          fillColor: Color(0xFFF1F2EE),
                        ),
                        validator: (value) =>
                            value == null || value.trim().isEmpty
                                ? 'Please describe the incident.'
                                : null,
                      ),
                      formLabel('Evidence'),
                      InkWell(
                        onTap: _chooseEvidence,
                        borderRadius: BorderRadius.circular(8),
                        child: Container(
                          height: 86,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: const Color(0xFFB8C2B3)),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  _evidenceName == null
                                      ? Icons.cloud_upload_outlined
                                      : Icons.check_circle_outline_rounded,
                                  color: primary,
                                ),
                                const SizedBox(height: 7),
                                Text(
                                  _evidenceName ?? 'Upload photos or videos',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      formLabel('Location'),
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              height: 48,
                              alignment: Alignment.centerLeft,
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 14),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F2EE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                _location,
                                style: const TextStyle(
                                  fontFamily: 'monospace',
                                  fontSize: 12,
                                  color: textMuted,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          TextButton.icon(
                            onPressed: _chooseLocation,
                            icon:
                                const Icon(Icons.my_location_rounded, size: 17),
                            label: const Text('Choose'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              height: modalChromeHeight,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              decoration: modalFooterDecoration,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 16),
                  FilledButton(
                    onPressed: _submit,
                    style: FilledButton.styleFrom(
                      backgroundColor: primary,
                      minimumSize: const Size(126, 42),
                    ),
                    child: const Text('Submit Report'),
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
