import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';

class CollectionRequestsPage extends StatefulWidget {
  const CollectionRequestsPage({super.key});

  @override
  State<CollectionRequestsPage> createState() => _CollectionRequestsPageState();
}

class _CollectionRequestsPageState extends State<CollectionRequestsPage> {
  String statusFilter = 'Pending';
  String priorityFilter = 'All';
  String categoryFilter = 'All';
  int selectedIndex = 0;

  final requests = const [
    CollectionRequestData(
      id: 'REQ-2024-081',
      citizenName: 'Maria Gonzalez',
      phone: '+1 (555) 018-4201',
      category: 'Bulk Organic',
      priority: 'High',
      address: '142 Oak Street',
      district: 'Westside District',
      status: 'Pending',
      volume: '2.4 m3',
      submitted: '2 hours ago',
      assignedDriver: 'Unassigned',
      assignedVehicle: 'Pending',
      notes:
          'Large bundled yard waste near curb. Photo confirms access from west lane.',
    ),
    CollectionRequestData(
      id: 'REQ-2024-082',
      citizenName: 'John Smith',
      phone: '+1 (555) 014-7719',
      category: 'Recyclable',
      priority: 'Low',
      address: '88 Pine Ave',
      district: 'Downtown',
      status: 'Assigned',
      volume: '1.1 m3',
      submitted: '4 hours ago',
      assignedDriver: 'Robert K.',
      assignedVehicle: 'TRK-842',
      notes: 'Cardboard and plastics from residential pickup zone.',
    ),
    CollectionRequestData(
      id: 'REQ-2024-083',
      citizenName: 'City Parks Dept',
      phone: '+1 (555) 017-4400',
      category: 'Green Waste',
      priority: 'Medium',
      address: 'Central Park North Gate',
      district: 'North District',
      status: 'Approved',
      volume: '4.8 m3',
      submitted: '6 hours ago',
      assignedDriver: 'Sarah Jenkins',
      assignedVehicle: 'TRK-845',
      notes: 'Tree trimming waste staged at maintenance entrance.',
    ),
    CollectionRequestData(
      id: 'REQ-2024-084',
      citizenName: 'Silicon Valley Tech Hub',
      phone: '+1 (555) 019-2200',
      category: 'Electronic',
      priority: 'Emergency',
      address: 'Building D Loading Dock',
      district: 'South District',
      status: 'In Progress',
      volume: '6 bins',
      submitted: '23 minutes ago',
      assignedDriver: 'Chen Wei',
      assignedVehicle: 'TRK-850',
      notes: 'Overflowing e-waste bins blocking service corridor.',
    ),
    CollectionRequestData(
      id: 'REQ-2024-085',
      citizenName: 'Northside Market',
      phone: '+1 (555) 010-3318',
      category: 'Organic',
      priority: 'High',
      address: '19 Cedar Plaza',
      district: 'North District',
      status: 'Completed',
      volume: '3.0 m3',
      submitted: 'Yesterday',
      assignedDriver: 'Maria Garcia',
      assignedVehicle: 'TRK-843',
      notes: 'Commercial organic waste collection completed before 08:30.',
    ),
  ];

  List<CollectionRequestData> get filteredRequests {
    return requests.where((request) {
      final statusOk = statusFilter == 'All' || request.status == statusFilter;
      final priorityOk =
          priorityFilter == 'All' || request.priority == priorityFilter;
      final categoryOk =
          categoryFilter == 'All' || request.category == categoryFilter;
      return statusOk && priorityOk && categoryOk;
    }).toList();
  }

  CollectionRequestData get selectedRequest {
    final list = filteredRequests;
    if (list.isEmpty) return requests.first;
    return list[selectedIndex.clamp(0, list.length - 1)];
  }

  void setStatus(String value) => setState(() {
        statusFilter = value;
        selectedIndex = 0;
      });

  void setPriority(String value) => setState(() {
        priorityFilter = value;
        selectedIndex = 0;
      });

  void setCategory(String value) => setState(() {
        categoryFilter = value;
        selectedIndex = 0;
      });

  void clearFilters() => setState(() {
        statusFilter = 'All';
        priorityFilter = 'All';
        categoryFilter = 'All';
        selectedIndex = 0;
      });

  void showNewRequestDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const NewCollectionRequestDialog(),
    );
  }

  void showAssignDriverDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const AssignDriverDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final visibleRequests = filteredRequests;
    return PageScaffold(
      title: 'Collection Requests',
      breadcrumb: 'Collection Management › Collection Requests',
      actions: [
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('Refresh')),
        OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.file_download_outlined),
            label: const Text('Export Excel')),
        FilledButton.icon(
            onPressed: showNewRequestDialog,
            icon: const Icon(Icons.add_circle_outline_rounded),
            label: const Text('New Collection Request'),
            style: FilledButton.styleFrom(backgroundColor: primary)),
      ],
      children: [
        const SizedBox(
          height: 132,
          child: Row(children: [
            KpiCard(
                title: 'Pending Requests',
                value: '124',
                trend: '+5% this week',
                icon: Icons.pending_actions_rounded),
            SizedBox(width: 18),
            KpiCard(
                title: 'Approved Today',
                value: '42',
                trend: 'vs 38 yesterday',
                icon: Icons.check_circle_outline_rounded),
            SizedBox(width: 18),
            KpiCard(
                title: 'In Progress',
                value: '18',
                trend: 'Active routes',
                icon: Icons.local_shipping_rounded),
            SizedBox(width: 18),
            KpiCard(
                title: 'Emergency Requests',
                value: '3',
                trend: 'Action required',
                icon: Icons.warning_rounded,
                warning: true),
          ]),
        ),
        const SizedBox(height: 24),
        AppCard(
          padding: const EdgeInsets.all(12),
          child: Wrap(
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                const Icon(Icons.filter_list_rounded),
                FilterButton(
                    label: 'All',
                    selected: statusFilter == 'All',
                    onTap: () => setStatus('All')),
                FilterButton(
                    label: 'Pending',
                    selected: statusFilter == 'Pending',
                    onTap: () => setStatus('Pending')),
                FilterButton(
                    label: 'Approved',
                    selected: statusFilter == 'Approved',
                    onTap: () => setStatus('Approved')),
                FilterButton(
                    label: 'Assigned',
                    selected: statusFilter == 'Assigned',
                    onTap: () => setStatus('Assigned')),
                FilterButton(
                    label: 'In Progress',
                    selected: statusFilter == 'In Progress',
                    onTap: () => setStatus('In Progress')),
                FilterButton(
                    label: 'Completed',
                    selected: statusFilter == 'Completed',
                    onTap: () => setStatus('Completed')),
                const SizedBox(width: 12),
                FilterButton(
                    label: 'Emergency',
                    selected: priorityFilter == 'Emergency',
                    danger: true,
                    onTap: () => setPriority(
                        priorityFilter == 'Emergency' ? 'All' : 'Emergency')),
                FilterMenuButton(
                    label: 'Priority',
                    value: priorityFilter,
                    values: const ['All', 'Low', 'Medium', 'High', 'Emergency'],
                    onChanged: setPriority),
                FilterMenuButton(
                    label: 'Category',
                    value: categoryFilter,
                    values: const [
                      'All',
                      'Organic',
                      'Recyclable',
                      'Electronic',
                      'Bulk Organic',
                      'Green Waste'
                    ],
                    onChanged: setCategory),
                TextButton(
                    onPressed: clearFilters,
                    child: const Text('Clear All',
                        style: TextStyle(
                            color: primary, fontWeight: FontWeight.w800))),
              ]),
        ),
        const SizedBox(height: 24),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 7,
              child: CollectionRequestTable(
                requests: visibleRequests,
                selectedIndex: selectedIndex,
                onSelect: (index) => setState(() => selectedIndex = index),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
                flex: 3,
                child: RequestDetailCard(
                  request: selectedRequest,
                  onAssignDriver: showAssignDriverDialog,
                )),
          ],
        ),
      ],
    );
  }
}

class CollectionRequestData {
  const CollectionRequestData({
    required this.id,
    required this.citizenName,
    required this.phone,
    required this.category,
    required this.priority,
    required this.address,
    required this.district,
    required this.status,
    required this.volume,
    required this.submitted,
    required this.assignedDriver,
    required this.assignedVehicle,
    required this.notes,
  });

  final String id;
  final String citizenName;
  final String phone;
  final String category;
  final String priority;
  final String address;
  final String district;
  final String status;
  final String volume;
  final String submitted;
  final String assignedDriver;
  final String assignedVehicle;
  final String notes;
}

class CollectionRequestTable extends StatelessWidget {
  const CollectionRequestTable({
    super.key,
    required this.requests,
    required this.selectedIndex,
    required this.onSelect,
  });

  final List<CollectionRequestData> requests;
  final int selectedIndex;
  final ValueChanged<int> onSelect;

  @override
  Widget build(BuildContext context) => AppCard(
        padding: EdgeInsets.zero,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Table(
              columnWidths: const {
                0: FlexColumnWidth(.8),
                1: FlexColumnWidth(1.3),
                2: FlexColumnWidth(1.5),
                3: FlexColumnWidth(1.2),
                4: FlexColumnWidth(1.1),
                5: FlexColumnWidth(1.8),
                6: FlexColumnWidth(1.2),
                7: FlexColumnWidth(1.2),
              },
              children: [
                const TableRow(
                  decoration: BoxDecoration(
                    color: Color(0xFFF2F3ED),
                    border: Border(bottom: BorderSide(color: border)),
                  ),
                  children: [
                    RequestHeader(''),
                    RequestHeader('ID'),
                    RequestHeader('Citizen Name'),
                    RequestHeader('Category'),
                    RequestHeader('Priority'),
                    RequestHeader('Address / District'),
                    RequestHeader('Driver'),
                    RequestHeader('Status'),
                  ],
                ),
                for (var i = 0; i < requests.length; i++)
                  _row(context, requests[i], i, i == selectedIndex),
              ],
            ),
            if (requests.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Center(child: Text('No collection requests found.')),
              ),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(color: Color(0xFFF2F3ED)),
              child: Text('Showing ${requests.length} filtered requests'),
            ),
          ],
        ),
      );

  TableRow _row(BuildContext context, CollectionRequestData request, int index,
      bool selected) {
    final selectedColor = selected ? const Color(0xFFEFFAF0) : Colors.white;
    return TableRow(
      decoration: BoxDecoration(
        color: selectedColor,
        border: const Border(bottom: BorderSide(color: Color(0xFFE8EBE3))),
      ),
      children: [
        RequestCell(InkWell(
          onTap: () => onSelect(index),
          child: Icon(
            selected
                ? Icons.check_box_rounded
                : Icons.check_box_outline_blank_rounded,
            color: selected ? primary : textMuted,
          ),
        )),
        RequestCell(_rowTap(request.id, index, selected,
            color: selected ? primary : const Color(0xFF1B211A))),
        RequestCell(_rowTap(request.citizenName, index, selected)),
        RequestCell(_rowTap(request.category, index, selected)),
        RequestCell(Align(
          alignment: Alignment.centerLeft,
          child: GestureDetector(
            onTap: () => onSelect(index),
            child: ChipPill(request.priority,
                danger: request.priority == 'Emergency' ||
                    request.priority == 'High'),
          ),
        )),
        RequestCell(_rowTap(
            '${request.address}\n${request.district}', index, selected)),
        RequestCell(_rowTap(request.assignedDriver, index, selected)),
        RequestCell(_rowTap(request.status, index, selected)),
      ],
    );
  }

  Widget _rowTap(String text, int index, bool selected, {Color? color}) {
    return InkWell(
      onTap: () => onSelect(index),
      child: Text(
        text,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
          color: color ?? const Color(0xFF1B211A),
        ),
      ),
    );
  }
}

class RequestHeader extends StatelessWidget {
  const RequestHeader(this.label, {super.key});
  final String label;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(14),
        child: Text(label.toUpperCase(),
            style: const TextStyle(
                fontSize: 11, fontWeight: FontWeight.w900, color: textMuted)),
      );
}

class RequestCell extends StatelessWidget {
  const RequestCell(this.child, {super.key});
  final Widget child;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.all(14),
        child: DefaultTextStyle(
          style: const TextStyle(fontSize: 13, color: Color(0xFF1B211A)),
          child: child,
        ),
      );
}

class RequestDetailCard extends StatelessWidget {
  const RequestDetailCard(
      {super.key, required this.request, required this.onAssignDriver});

  final CollectionRequestData request;
  final VoidCallback onAssignDriver;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(children: [
              Expanded(
                  child: Text('${request.id}\nSubmitted ${request.submitted}',
                      style: TextStyle(
                          fontSize: 20, fontWeight: FontWeight.w800))),
              const Icon(Icons.more_vert_rounded),
              const Icon(Icons.close_rounded)
            ]),
          ),
          Container(
              height: 180,
              color: const Color(0xFFD9E3D2),
              child: const Center(
                  child:
                      Icon(Icons.image_rounded, size: 56, color: textMuted))),
          Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              ChipPill('${request.priority.toUpperCase()} PRIORITY',
                  danger: request.priority == 'High' ||
                      request.priority == 'Emergency'),
              const SizedBox(height: 16),
              const SectionTitle('Location Data',
                  icon: Icons.location_on_outlined),
              const SizedBox(height: 8),
              const FakeMap(height: 120, label: ''),
              const SizedBox(height: 16),
              Text(
                  '${request.citizenName} • ${request.phone}\n${request.category}, estimated ${request.volume}\n${request.address}, ${request.district}'),
              const SizedBox(height: 12),
              MetricLine('Assigned Driver', request.assignedDriver),
              MetricLine('Vehicle', request.assignedVehicle),
              MetricLine('Current Status', request.status),
              const SizedBox(height: 12),
              Text(request.notes, style: const TextStyle(color: textMuted)),
            ]),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                FilledButton.icon(
                    onPressed: onAssignDriver,
                    icon: const Icon(Icons.group_add_rounded),
                    label: const Text('Assign Driver'),
                    style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size.fromHeight(42))),
                const SizedBox(height: 8),
                Row(children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Approve'))),
                  const SizedBox(width: 8),
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () {}, child: const Text('Reject')))
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({
    super.key,
    required this.label,
    required this.selected,
    required this.onTap,
    this.danger = false,
  });

  final String label;
  final bool selected;
  final bool danger;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: ChipPill(label, active: selected, danger: danger && selected),
      );
}

class FilterMenuButton extends StatelessWidget {
  const FilterMenuButton({
    super.key,
    required this.label,
    required this.value,
    required this.values,
    required this.onChanged,
  });

  final String label;
  final String value;
  final List<String> values;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) => PopupMenuButton<String>(
        tooltip: label,
        onSelected: onChanged,
        itemBuilder: (context) => values
            .map((item) => PopupMenuItem(value: item, child: Text(item)))
            .toList(),
        child: ChipPill('$label: $value', active: value != 'All'),
      );
}

class NewCollectionRequestDialog extends StatelessWidget {
  const NewCollectionRequestDialog({super.key});

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 560,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 14, 12, 12),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('New Collection Request',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    formLabel('Customer / Pickup Location'),
                    const _DialogField(
                        icon: Icons.location_on_outlined,
                        text: 'Silicon Valley Tech Hub - Building D',
                        trailing: Icons.search_rounded),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _DialogLabel('Waste Classification'),
                            _DialogField(
                                text: 'Recyclable',
                                trailing: Icons.expand_more_rounded),
                          ],
                        )),
                        const SizedBox(width: 18),
                        Expanded(
                            child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            _DialogLabel('Bin Quantity (Standard 1100L)'),
                            _StepperField(),
                          ],
                        )),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _DialogLabel('Requested Service Window'),
                    const Row(
                      children: [
                        Expanded(
                            child: _DialogField(
                                icon: Icons.calendar_today_outlined,
                                text: '11/24/2023')),
                        SizedBox(width: 18),
                        Expanded(
                            child: _DialogField(
                                icon: Icons.schedule_rounded,
                                text: '09:00 AM')),
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _DialogLabel('Priority Level'),
                    const Wrap(
                      spacing: 8,
                      children: [
                        ChipPill('✓ Routine'),
                        ChipPill('! Urgent', active: true),
                        ChipPill('↯ Express'),
                      ],
                    ),
                    formLabel('Special Instructions / Logistics Notes'),
                    Container(
                      height: 84,
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F3ED),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: border),
                      ),
                      child: const Text(
                        'e.g., Gate code 4412, park near loading dock 3...',
                        style: TextStyle(color: textMuted, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: Color(0xFFF2F3ED)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel')),
                    const SizedBox(width: 18),
                    FilledButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        minimumSize: const Size(140, 42),
                      ),
                      child: const Text('Create Request'),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      );
}

class AssignDriverDialog extends StatefulWidget {
  const AssignDriverDialog({super.key});

  @override
  State<AssignDriverDialog> createState() => _AssignDriverDialogState();
}

class _AssignDriverDialogState extends State<AssignDriverDialog> {
  int? selectedDriver;

  final drivers = const [
    DriverOption(
        'Robert Wilson', 'RCV Class A • Hookloader', '2/5 tasks', 'RW'),
    DriverOption(
        'Maria Garcia', 'Heavy Goods Cert • Skip Lift', '1/5 task', 'MG'),
    DriverOption('Chen Wei', 'RCV Class A • Side Loader', '4/5 tasks', 'CW'),
    DriverOption(
        'Sarah Jenkins', 'Hazardous Waste Certified', '0/5 tasks', 'SJ'),
  ];

  @override
  Widget build(BuildContext context) => Dialog(
        insetPadding: const EdgeInsets.all(32),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: 420,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 10, 10, 8),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text('Assign Driver',
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w900)),
                    ),
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(Icons.close_rounded)),
                  ],
                ),
              ),
              const Divider(height: 1),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: SizedBox(
                    width: 220,
                    child: SearchBar(
                      elevation: const WidgetStatePropertyAll(0),
                      leading: const Icon(Icons.search_rounded),
                      hintText: 'Search available drivers...',
                      backgroundColor:
                          const WidgetStatePropertyAll(Color(0xFFF9F9F8)),
                      shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                        side: const BorderSide(color: border),
                      )),
                    ),
                  ),
                ),
              ),
              for (var i = 0; i < drivers.length; i++)
                DriverOptionTile(
                  driver: drivers[i],
                  selected: selectedDriver == i,
                  onTap: () => setState(() => selectedDriver = i),
                ),
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(color: Color(0xFFF2F3ED)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                        onPressed: () => Navigator.of(context).pop(),
                        child: const Text('Cancel')),
                    const SizedBox(width: 18),
                    FilledButton(
                      onPressed: selectedDriver == null
                          ? null
                          : () => Navigator.of(context).pop(),
                      style: FilledButton.styleFrom(
                        backgroundColor: primary,
                        disabledBackgroundColor: const Color(0xFFC9D2C6),
                        minimumSize: const Size(164, 42),
                      ),
                      child: const Text('Confirm Assignment'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
}

class DriverOption {
  const DriverOption(this.name, this.detail, this.workload, this.initials);
  final String name;
  final String detail;
  final String workload;
  final String initials;
}

class DriverOptionTile extends StatelessWidget {
  const DriverOptionTile({
    super.key,
    required this.driver,
    required this.selected,
    required this.onTap,
  });

  final DriverOption driver;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => InkWell(
        onTap: onTap,
        child: Container(
          color: selected ? const Color(0xFFEFFAF0) : Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: const Color(0xFFDDE6DD),
                child: Text(driver.initials,
                    style: const TextStyle(
                        color: primary, fontWeight: FontWeight.w900)),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Flexible(
                          child: Text(driver.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w900)),
                        ),
                        const SizedBox(width: 8),
                        const ChipPill('AVAILABLE', active: true),
                      ],
                    ),
                    Text(driver.detail,
                        style: const TextStyle(fontSize: 12, color: textMuted)),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(driver.workload,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const Text('WORKLOAD',
                      style: TextStyle(fontSize: 9, color: textMuted)),
                ],
              ),
            ],
          ),
        ),
      );
}

class _DialogLabel extends StatelessWidget {
  const _DialogLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: 10, bottom: 8),
        child: Text(text,
            style: const TextStyle(
                fontSize: 12, color: textMuted, fontWeight: FontWeight.w700)),
      );
}

class _DialogField extends StatelessWidget {
  const _DialogField({required this.text, this.icon, this.trailing});
  final String text;
  final IconData? icon;
  final IconData? trailing;

  @override
  Widget build(BuildContext context) => Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3ED),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: border),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(icon, size: 18, color: textMuted),
              const SizedBox(width: 10),
            ],
            Expanded(child: Text(text)),
            if (trailing != null) Icon(trailing, size: 18, color: textMuted),
          ],
        ),
      );
}

class _StepperField extends StatelessWidget {
  const _StepperField();

  @override
  Widget build(BuildContext context) => Container(
        height: 42,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F3ED),
          borderRadius: BorderRadius.circular(7),
          border: Border.all(color: border),
        ),
        child: const Row(
          children: [
            Icon(Icons.remove_rounded, size: 18),
            Spacer(),
            Text('4', style: TextStyle(fontWeight: FontWeight.w800)),
            Spacer(),
            Icon(Icons.add_rounded, size: 18),
          ],
        ),
      );
}
