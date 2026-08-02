import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../../app/theme.dart';
import '../../shared/open_street_map.dart';
import '../../shared/widgets.dart';
import 'export_map_dialog.dart';
import 'export_spatial_data_dialog.dart';

class SpatialAnalysisPage extends StatefulWidget {
  const SpatialAnalysisPage({super.key});

  @override
  State<SpatialAnalysisPage> createState() => _SpatialAnalysisPageState();
}

class _SpatialAnalysisPageState extends State<SpatialAnalysisPage> {
  static const _mapCenter = LatLng(40.7128, -74.0060);
  final MapController _mapController = MapController();
  bool _mapReady = false;
  bool _toolboxCollapsed = false;
  String _densityMethod = 'Kernel Density Estimation';
  bool _optimizedHotspot = true;
  bool _clusterOutliers = false;
  bool _networkAnalysis = false;
  double _searchRadius = 1800;

  int _resultTab = 0;
  double _maxDensity = 42.8;
  double _meanDensity = 14.2;
  int _features = 1240;
  int _runCount = 0;

  bool _wasteBins = true;
  bool _routes = true;
  bool _incidents = true;
  bool _heatmap = true;
  double _zoom = 12;

  int _timelineIndex = 3;
  String _timelineMode = 'Daily';
  bool _playing = false;
  Timer? _timelineTimer;

  static const _days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void dispose() {
    _timelineTimer?.cancel();
    _mapController.dispose();
    super.dispose();
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), behavior: SnackBarBehavior.floating),
    );
  }

  void _runAnalysis() {
    setState(() {
      _runCount++;
      _maxDensity = 38 + (_searchRadius / 500) + (_optimizedHotspot ? 2.6 : 0);
      _meanDensity = 10 + (_searchRadius / 600) + (_clusterOutliers ? 1.8 : 0);
      _features = 980 + (_searchRadius / 8).round();
      _resultTab = 0;
      _heatmap = true;
    });
    _showMessage('Spatial analysis completed with $_features features.');
  }

  void _togglePlayback() {
    setState(() => _playing = !_playing);
    _timelineTimer?.cancel();
    if (!_playing) return;
    _timelineTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() => _timelineIndex = (_timelineIndex + 1) % _days.length);
    });
  }

  void _showExportMap() {
    showDialog<void>(
      context: context,
      builder: (context) => const ExportMapDialog(),
    );
  }

  void _showExportData() {
    showDialog<void>(
      context: context,
      builder: (context) => const ExportSpatialDataDialog(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PageScaffold(
      title: 'Spatial Analysis Map',
      breadcrumb: 'Reports & Analytics › Spatial Analysis Map',
      scroll: false,
      actions: [
        OutlinedButton.icon(
          onPressed: _showExportMap,
          icon: const Icon(Icons.download_rounded),
          label: const Text('Export Map'),
        ),
        OutlinedButton.icon(
          onPressed: _showExportData,
          icon: const Icon(Icons.table_chart_rounded),
          label: const Text('Export Data'),
        ),
        FilledButton.icon(
          onPressed: _runAnalysis,
          icon: const Icon(Icons.play_arrow_rounded),
          label: const Text('Run Analysis'),
          style: FilledButton.styleFrom(backgroundColor: primary),
        ),
      ],
      children: [
        Expanded(
          child: Container(
            decoration: BoxDecoration(border: Border.all(color: border)),
            child: Column(
              children: [
                Expanded(
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      AnimatedContainer(
                        duration: const Duration(milliseconds: 220),
                        width: _toolboxCollapsed ? 54 : 300,
                        clipBehavior: Clip.hardEdge,
                        decoration: const BoxDecoration(
                          color: surface,
                          border: Border(right: BorderSide(color: border)),
                        ),
                        child: _toolboxCollapsed
                            ? _CollapsedToolbox(
                                onExpand: () => setState(
                                  () => _toolboxCollapsed = false,
                                ),
                                onRun: _runAnalysis,
                              )
                            : _buildToolbox(),
                      ),
                      Expanded(child: _buildMap()),
                      SizedBox(width: 350, child: _buildResultsPanel()),
                    ],
                  ),
                ),
                _buildTimeline(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbox() {
    return Column(
      children: [
        Container(
          height: 52,
          padding: const EdgeInsets.only(left: 14, right: 4),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: border)),
          ),
          child: Row(
            children: [
              const Icon(Icons.build_rounded, size: 19, color: primary),
              const SizedBox(width: 8),
              const Expanded(
                child: Text('Analysis Toolbox',
                    style: TextStyle(fontWeight: FontWeight.w800)),
              ),
              IconButton(
                tooltip: 'Collapse toolbox',
                onPressed: () => setState(() => _toolboxCollapsed = true),
                icon: const Icon(Icons.chevron_left_rounded),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              ExpansionTile(
                initiallyExpanded: true,
                leading: const Icon(Icons.blur_on_rounded, color: primary),
                title: const Text('Density Analysis',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                children: [
                  RadioListTile<String>(
                    dense: true,
                    value: 'Kernel Density Estimation',
                    groupValue: _densityMethod,
                    onChanged: (value) =>
                        setState(() => _densityMethod = value!),
                    title: const Text('Kernel Density Estimation'),
                  ),
                  RadioListTile<String>(
                    dense: true,
                    value: 'Point Density',
                    groupValue: _densityMethod,
                    onChanged: (value) =>
                        setState(() => _densityMethod = value!),
                    title: const Text('Point Density'),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: [
                        const Text('Search Radius'),
                        const Spacer(),
                        Text('${_searchRadius.round()}m',
                            style: const TextStyle(
                                color: primary, fontWeight: FontWeight.w800)),
                      ],
                    ),
                  ),
                  Slider(
                    value: _searchRadius,
                    min: 100,
                    max: 5000,
                    divisions: 49,
                    onChanged: (value) => setState(() => _searchRadius = value),
                  ),
                ],
              ),
              ExpansionTile(
                initiallyExpanded: true,
                leading: const Icon(Icons.scatter_plot_rounded, color: primary),
                title: const Text('Hotspot Analysis',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                children: [
                  CheckboxListTile(
                    dense: true,
                    value: _optimizedHotspot,
                    onChanged: (value) =>
                        setState(() => _optimizedHotspot = value!),
                    title: const Text('Optimized Hot Spot Analysis'),
                  ),
                  CheckboxListTile(
                    dense: true,
                    value: _clusterOutliers,
                    onChanged: (value) =>
                        setState(() => _clusterOutliers = value!),
                    title: const Text('Cluster & Outlier Analysis'),
                  ),
                ],
              ),
              ExpansionTile(
                leading: const Icon(Icons.route_outlined, color: primary),
                title: const Text('Network Analysis',
                    style: TextStyle(fontWeight: FontWeight.w800)),
                children: [
                  SwitchListTile(
                    dense: true,
                    value: _networkAnalysis,
                    onChanged: (value) =>
                        setState(() => _networkAnalysis = value),
                    title: const Text('Include route impedance'),
                  ),
                ],
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: _runAnalysis,
              icon: const Icon(Icons.play_arrow_rounded),
              label: const Text('Run Analysis'),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Stack(
      children: [
        Positioned.fill(
          child: OpenStreetMapView(
            height: double.infinity,
            center: _mapCenter,
            initialZoom: _zoom,
            controller: _mapController,
            showControls: false,
            heat: _heatmap,
            showPoints: _wasteBins,
            showRoutes: _routes,
            showIncidents: _incidents,
            onMapReady: () => _mapReady = true,
            onPositionChanged: (zoom) => _zoom = zoom,
          ),
        ),
        Positioned(
          left: 14,
          top: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            color: Colors.white.withOpacity(.9),
            child: Text(
              '$_densityMethod · ${_days[_timelineIndex]}',
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ),
        ),
        Positioned(
          top: 14,
          right: 14,
          child: Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _MapButton(
                  tooltip: 'Zoom in',
                  icon: Icons.add_rounded,
                  onPressed: () {
                    if (!_mapReady) return;
                    setState(() => _zoom = (_zoom + 1).clamp(2, 19));
                    _mapController.move(_mapController.camera.center, _zoom);
                  },
                ),
                _MapButton(
                  tooltip: 'Zoom out',
                  icon: Icons.remove_rounded,
                  onPressed: () {
                    if (!_mapReady) return;
                    setState(() => _zoom = (_zoom - 1).clamp(2, 19));
                    _mapController.move(_mapController.camera.center, _zoom);
                  },
                ),
                _MapButton(
                  tooltip: 'Toggle heatmap',
                  icon: Icons.layers_rounded,
                  onPressed: () => setState(() => _heatmap = !_heatmap),
                ),
                _MapButton(
                  tooltip: 'Center current location',
                  icon: Icons.my_location_rounded,
                  onPressed: () {
                    if (_mapReady) _mapController.move(_mapCenter, 12);
                    setState(() => _zoom = 12);
                    _showMessage('Map centered on current location.');
                  },
                ),
              ],
            ),
          ),
        ),
        Positioned(
          left: 14,
          bottom: 14,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(.92),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
                'Zoom ${_zoom.round()} · Radius ${_searchRadius.round()}m'),
          ),
        ),
      ],
    );
  }

  Widget _buildResultsPanel() {
    return Container(
      decoration: const BoxDecoration(
        color: surface,
        border: Border(left: BorderSide(color: border)),
      ),
      child: Column(
        children: [
          SizedBox(
            height: 52,
            child: Row(
              children: [
                _ResultTab('Results', 0, _resultTab, (value) {
                  setState(() => _resultTab = value);
                }),
                _ResultTab('Layers', 1, _resultTab, (value) {
                  setState(() => _resultTab = value);
                }),
                _ResultTab('Legend', 2, _resultTab, (value) {
                  setState(() => _resultTab = value);
                }),
              ],
            ),
          ),
          const Divider(height: 1),
          Expanded(
            child: switch (_resultTab) {
              1 => _buildLayersTab(),
              2 => _buildLegendTab(),
              _ => _buildResultDetails(),
            },
          ),
        ],
      ),
    );
  }

  Widget _buildResultDetails() {
    return ListView(
      padding: const EdgeInsets.all(14),
      children: [
        const Text('Kernel Density Output',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ResultMetric(
                  label: 'Max Density', value: _maxDensity.toStringAsFixed(1)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ResultMetric(
                  label: 'Mean Density',
                  value: _meanDensity.toStringAsFixed(1)),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: alertSoft,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Row(
            children: [
              Expanded(
                child: Text('Peak: Downtown Core (Sector 7G)',
                    style:
                        TextStyle(color: alert, fontWeight: FontWeight.w800)),
              ),
              Icon(Icons.warning_amber_rounded, color: alert),
            ],
          ),
        ),
        const SizedBox(height: 18),
        const Text('Distribution Curve',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        const SizedBox(height: 110, child: MiniBars()),
        const Divider(height: 28),
        MetricLine('Features analyzed', '$_features'),
        const MetricLine('Coverage area', '86.4 km²'),
        MetricLine('Search radius', '${_searchRadius.round()} m'),
        const MetricLine('Confidence level', '96.8%'),
        MetricLine('Analysis runs', '${_runCount + 1}'),
        const SizedBox(height: 18),
        const Text('Top Concentration Clusters',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 8),
        const _ClusterRow('Sector 7G · Downtown Core', '42.8', alert),
        const _ClusterRow('Sector 4C · Market District', '35.1', primary),
        const _ClusterRow('Sector 2A · Riverside', '28.6', purple),
      ],
    );
  }

  Widget _buildLayersTab() {
    return ListView(
      padding: const EdgeInsets.all(12),
      children: [
        const Text('Visible Map Layers',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
        SwitchListTile(
          value: _wasteBins,
          onChanged: (value) => setState(() => _wasteBins = value),
          title: const Text('Waste Bins'),
          secondary: const Icon(Icons.delete_outline_rounded),
        ),
        SwitchListTile(
          value: _routes,
          onChanged: (value) => setState(() => _routes = value),
          title: const Text('Collection Routes'),
          secondary: const Icon(Icons.route_outlined),
        ),
        SwitchListTile(
          value: _incidents,
          onChanged: (value) => setState(() => _incidents = value),
          title: const Text('Incident Reports'),
          secondary: const Icon(Icons.warning_amber_rounded),
        ),
        SwitchListTile(
          value: _heatmap,
          onChanged: (value) => setState(() => _heatmap = value),
          title: const Text('Density Heatmap'),
          secondary: const Icon(Icons.blur_on_rounded),
        ),
      ],
    );
  }

  Widget _buildLegendTab() {
    return const Padding(
      padding: EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Density Scale',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          SizedBox(height: 18),
          _LegendRow('Critical concentration', alert),
          _LegendRow('High concentration', Color(0xFFF59E0B)),
          _LegendRow('Moderate concentration', Color(0xFF22C55E)),
          _LegendRow('Low concentration', Color(0xFF38BDF8)),
          Divider(height: 32),
          _LegendRow('Active route', primary),
          _LegendRow('Reported incident', purple),
        ],
      ),
    );
  }

  Widget _buildTimeline() {
    return Container(
      height: 82,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: const BoxDecoration(
        color: surface,
        border: Border(top: BorderSide(color: border)),
      ),
      child: Row(
        children: [
          IconButton.filled(
            tooltip: _playing ? 'Pause timeline' : 'Play timeline',
            onPressed: _togglePlayback,
            icon:
                Icon(_playing ? Icons.pause_rounded : Icons.play_arrow_rounded),
            style: IconButton.styleFrom(
              backgroundColor: primary,
              foregroundColor: Colors.white,
              minimumSize: const Size(52, 52),
            ),
          ),
          const SizedBox(width: 14),
          SizedBox(
            width: 170,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('TIME SERIES',
                    style: TextStyle(color: textMuted, fontSize: 12)),
                Text(
                  'Oct ${14 + _timelineIndex} - Oct ${20 + _timelineIndex}',
                  style: const TextStyle(
                      fontSize: 17, fontWeight: FontWeight.w800),
                ),
              ],
            ),
          ),
          const VerticalDivider(indent: 14, endIndent: 14),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Slider(
                  value: _timelineIndex.toDouble(),
                  min: 0,
                  max: 6,
                  divisions: 6,
                  onChanged: (value) =>
                      setState(() => _timelineIndex = value.round()),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(
                    _days.length,
                    (index) => Text(
                      _days[index],
                      style: TextStyle(
                        fontSize: 10,
                        color: index == _timelineIndex ? primary : textMuted,
                        fontWeight: index == _timelineIndex
                            ? FontWeight.w800
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 20),
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Hourly', label: Text('Hourly')),
              ButtonSegment(value: 'Daily', label: Text('Daily')),
              ButtonSegment(value: 'Weekly', label: Text('Weekly')),
            ],
            selected: {_timelineMode},
            showSelectedIcon: false,
            onSelectionChanged: (values) =>
                setState(() => _timelineMode = values.first),
          ),
        ],
      ),
    );
  }
}

class _CollapsedToolbox extends StatelessWidget {
  const _CollapsedToolbox({required this.onExpand, required this.onRun});

  final VoidCallback onExpand;
  final VoidCallback onRun;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          IconButton(
            tooltip: 'Expand analysis toolbox',
            onPressed: onExpand,
            icon: const Icon(Icons.chevron_right_rounded),
          ),
          const Divider(),
          const Icon(Icons.build_rounded, color: primary),
          const Spacer(),
          IconButton(
            tooltip: 'Run analysis',
            onPressed: onRun,
            icon: const Icon(Icons.play_circle_outline_rounded, color: primary),
          ),
          const SizedBox(height: 8),
        ],
      );
}

class _MapButton extends StatelessWidget {
  const _MapButton({
    required this.tooltip,
    required this.icon,
    required this.onPressed,
  });

  final String tooltip;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        tooltip: tooltip,
        onPressed: onPressed,
        icon: Icon(icon),
        constraints: const BoxConstraints.tightFor(width: 40, height: 40),
      );
}

class _ResultTab extends StatelessWidget {
  const _ResultTab(this.label, this.index, this.selected, this.onSelected);

  final String label;
  final int index;
  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) => Expanded(
        child: InkWell(
          onTap: () => onSelected(index),
          child: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(
              border: Border(
                bottom: BorderSide(
                  color: selected == index ? primary : Colors.transparent,
                  width: 2,
                ),
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: selected == index ? primary : textMuted,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
        ),
      );
}

class _ResultMetric extends StatelessWidget {
  const _ResultMetric({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F6F2),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: const TextStyle(fontSize: 11, color: textMuted)),
            const SizedBox(height: 4),
            Text(value,
                style:
                    const TextStyle(fontSize: 26, fontWeight: FontWeight.w800)),
            const Text('units/sq km',
                style: TextStyle(fontSize: 10, color: textMuted)),
          ],
        ),
      );
}

class _ClusterRow extends StatelessWidget {
  const _ClusterRow(this.label, this.value, this.color);

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 7),
        child: Row(
          children: [
            Icon(Icons.circle, size: 9, color: color),
            const SizedBox(width: 8),
            Expanded(child: Text(label, style: const TextStyle(fontSize: 12))),
            Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
          ],
        ),
      );
}

class _LegendRow extends StatelessWidget {
  const _LegendRow(this.label, this.color);

  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Row(
          children: [
            Container(width: 20, height: 12, color: color),
            const SizedBox(width: 10),
            Text(label),
          ],
        ),
      );
}
