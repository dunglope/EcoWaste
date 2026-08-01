import 'package:flutter/material.dart';

import '../../app/theme.dart';
import '../../shared/widgets.dart';
import 'export_report_dialog.dart';
import 'generate_report_dialog.dart';

class KpiPage extends StatefulWidget {
  const KpiPage({super.key});

  @override
  State<KpiPage> createState() => _KpiPageState();
}

class _KpiPageState extends State<KpiPage> {
  String _dateRange = 'Last 7 Days';
  String _district = 'All Districts';
  String _category = 'All Categories';

  static const _districtMetrics = [
    _DistrictMetric('North District', 3200, 3150, '38m', '98/100'),
    _DistrictMetric('South District', 2800, 2700, '42m', '95/100'),
    _DistrictMetric('East District', 4100, 3900, '51m', '88/100'),
  ];

  double get _periodFactor => switch (_dateRange) {
        'Last 30 Days' => 4.1,
        'Last 90 Days' => 12.0,
        _ => 1.0,
      };

  double get _districtFactor => switch (_district) {
        'North District' => .31,
        'South District' => .27,
        'East District' => .39,
        _ => 1.0,
      };

  double get _categoryFactor => switch (_category) {
        'Organic Waste' => .38,
        'Recyclables' => .34,
        'Bulk Waste' => .18,
        _ => 1.0,
      };

  int get _totalRequests =>
      (12450 * _periodFactor * _districtFactor * _categoryFactor).round();

  String get _responseTime => switch (_district) {
        'North District' => '38m',
        'South District' => '42m',
        'East District' => '51m',
        _ => '45m',
      };

  String get _fleetUtilization => switch (_category) {
        'Organic Waste' => '91%',
        'Recyclables' => '89%',
        'Bulk Waste' => '82%',
        _ => '87%',
      };

  String get _successRate => switch (_district) {
        'North District' => '99.4%',
        'South District' => '98.8%',
        'East District' => '96.1%',
        _ => '99.2%',
      };

  List<_DistrictMetric> get _visibleDistricts {
    if (_district == 'All Districts') return _districtMetrics;
    return _districtMetrics
        .where((metric) => metric.name == _district)
        .toList();
  }

  String _formatNumber(int value) => value.toString().replaceAllMapped(
        RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
        (match) => '${match[1]},',
      );

  void _showExportDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const ExportReportDialog(),
    );
  }

  void _showGenerateDialog() {
    showDialog<void>(
      context: context,
      builder: (context) => const GenerateReportDialog(),
    );
  }

  void _clearFilters() {
    setState(() {
      _dateRange = 'Last 7 Days';
      _district = 'All Districts';
      _category = 'All Categories';
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoryLabel = _category == 'All Categories'
        ? 'all waste categories'
        : _category.toLowerCase();
    final districtLabel =
        _district == 'All Districts' ? 'North District' : _district;

    return PageScaffold(
      title: 'KPI Reports',
      breadcrumb: 'Reports & Analytics › KPI Reports',
      actions: [
        OutlinedButton.icon(
          onPressed: _showExportDialog,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export'),
        ),
        FilledButton.icon(
          onPressed: _showGenerateDialog,
          icon: const Icon(Icons.sync_rounded),
          label: const Text('Generate Report'),
          style: FilledButton.styleFrom(backgroundColor: primary),
        ),
      ],
      children: [
        AppCard(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Wrap(
            spacing: 10,
            runSpacing: 10,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              const Icon(Icons.filter_list_rounded, color: textMuted),
              _KpiFilter(
                value: _dateRange,
                values: const ['Last 7 Days', 'Last 30 Days', 'Last 90 Days'],
                icon: Icons.calendar_today_outlined,
                onSelected: (value) => setState(() => _dateRange = value),
              ),
              _KpiFilter(
                value: _district,
                values: const [
                  'All Districts',
                  'North District',
                  'South District',
                  'East District',
                ],
                icon: Icons.location_city_outlined,
                onSelected: (value) => setState(() => _district = value),
              ),
              _KpiFilter(
                value: _category,
                values: const [
                  'All Categories',
                  'Organic Waste',
                  'Recyclables',
                  'Bulk Waste',
                ],
                icon: Icons.category_outlined,
                onSelected: (value) => setState(() => _category = value),
              ),
              if (_dateRange != 'Last 7 Days' ||
                  _district != 'All Districts' ||
                  _category != 'All Categories')
                TextButton.icon(
                  onPressed: _clearFilters,
                  icon: const Icon(Icons.clear_all_rounded),
                  label: const Text('Clear Filters'),
                ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        AppCard(
          child: Row(
            children: [
              const CircleAvatar(
                backgroundColor: purple,
                child: Icon(Icons.auto_awesome_rounded, color: Colors.white),
              ),
              const SizedBox(width: 18),
              Expanded(
                child: Text(
                  'AI Insights\nHighest performing district: $districtLabel '
                  '(+12% efficiency)\nCurrent view covers $categoryLabel for '
                  '$_dateRange.',
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          height: 132,
          child: Row(
            children: [
              KpiCard(
                title: 'Total Requests',
                value: _formatNumber(_totalRequests),
                trend: '+5.2% vs last period',
                icon: Icons.assignment_rounded,
              ),
              const SizedBox(width: 16),
              KpiCard(
                title: 'Avg Response Time',
                value: _responseTime,
                trend: '-12% vs last period',
                icon: Icons.timer_rounded,
              ),
              const SizedBox(width: 16),
              KpiCard(
                title: 'Fleet Utilization',
                value: _fleetUtilization,
                trend: '-2.1% vs last period',
                icon: Icons.local_shipping_rounded,
              ),
              const SizedBox(width: 16),
              KpiCard(
                title: 'Success Rate',
                value: _successRate,
                trend: '+0.5% vs last period',
                icon: Icons.check_circle_outline_rounded,
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              flex: 2,
              child: AppCard(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle('Collection Trend · $_dateRange'),
                    const Expanded(
                      child: Center(
                        child:
                            Text('[Line Chart Placeholder - Collection Trend]'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 24),
            Expanded(
              child: AppCard(
                height: 300,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SectionTitle(
                      _category == 'All Categories'
                          ? 'Waste Category Distribution'
                          : _category,
                    ),
                    const Expanded(
                      child: Center(child: Text('[Donut Chart Placeholder]')),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        DataTableCard(
          title: 'District Performance',
          columns: const [
            'District',
            'Requests',
            'Completed',
            'Response Time',
            'Score',
          ],
          rows: _visibleDistricts.map((metric) {
            final factor = _periodFactor * _categoryFactor;
            return tableRow([
              metric.name,
              _formatNumber((metric.requests * factor).round()),
              _formatNumber((metric.completed * factor).round()),
              metric.responseTime,
              metric.score,
            ]);
          }).toList(),
        ),
      ],
    );
  }
}

class _KpiFilter extends StatelessWidget {
  const _KpiFilter({
    required this.value,
    required this.values,
    required this.icon,
    required this.onSelected,
  });

  final String value;
  final List<String> values;
  final IconData icon;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'Change $value filter',
      onSelected: onSelected,
      itemBuilder: (context) => values
          .map((option) => PopupMenuItem(
                value: option,
                child: Row(
                  children: [
                    SizedBox(
                      width: 24,
                      child: option == value
                          ? const Icon(Icons.check_rounded,
                              size: 17, color: primary)
                          : null,
                    ),
                    Text(option),
                  ],
                ),
              ))
          .toList(),
      child: Container(
        height: 38,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        decoration: BoxDecoration(
          border: Border.all(color: border),
          borderRadius: BorderRadius.circular(8),
          color: const Color(0xFFF8F9F5),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: textMuted),
            const SizedBox(width: 8),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

class _DistrictMetric {
  const _DistrictMetric(
    this.name,
    this.requests,
    this.completed,
    this.responseTime,
    this.score,
  );

  final String name;
  final int requests;
  final int completed;
  final String responseTime;
  final String score;
}
