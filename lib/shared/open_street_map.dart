import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../app/theme.dart';

class OpenStreetMapView extends StatefulWidget {
  const OpenStreetMapView({
    super.key,
    this.height = 420,
    this.label,
    this.center = const LatLng(40.7128, -74.0060),
    this.initialZoom = 12,
    this.heat = false,
    this.showPoints = true,
    this.showRoutes = true,
    this.showIncidents = true,
    this.showControls = true,
    this.interactive = true,
    this.controller,
    this.onMapReady,
    this.onPositionChanged,
  });

  final double height;
  final String? label;
  final LatLng center;
  final double initialZoom;
  final bool heat;
  final bool showPoints;
  final bool showRoutes;
  final bool showIncidents;
  final bool showControls;
  final bool interactive;
  final MapController? controller;
  final VoidCallback? onMapReady;
  final ValueChanged<double>? onPositionChanged;

  @override
  State<OpenStreetMapView> createState() => _OpenStreetMapViewState();
}

class _OpenStreetMapViewState extends State<OpenStreetMapView> {
  late final MapController _internalController;
  late double _zoom;

  MapController get _controller => widget.controller ?? _internalController;

  @override
  void initState() {
    super.initState();
    _internalController = MapController();
    _zoom = widget.initialZoom;
  }

  @override
  void dispose() {
    if (widget.controller == null) _internalController.dispose();
    super.dispose();
  }

  void _changeZoom(double delta) {
    final next = (_zoom + delta).clamp(2.0, 19.0);
    _controller.move(_controller.camera.center, next);
    setState(() => _zoom = next);
    widget.onPositionChanged?.call(next);
  }

  void _recenter() {
    _controller.move(widget.center, widget.initialZoom);
    setState(() => _zoom = widget.initialZoom);
    widget.onPositionChanged?.call(_zoom);
  }

  @override
  Widget build(BuildContext context) {
    final map = FlutterMap(
      mapController: _controller,
      options: MapOptions(
        initialCenter: widget.center,
        initialZoom: widget.initialZoom,
        minZoom: 2,
        maxZoom: 19,
        interactionOptions: InteractionOptions(
          flags:
              widget.interactive ? InteractiveFlag.all : InteractiveFlag.none,
        ),
        onMapReady: widget.onMapReady,
        onPositionChanged: (camera, hasGesture) {
          _zoom = camera.zoom;
          if (hasGesture) widget.onPositionChanged?.call(camera.zoom);
        },
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.ecowaste.admin',
          maxNativeZoom: 19,
        ),
        if (widget.showRoutes)
          PolylineLayer(
            polylines: [
              Polyline(
                points: _routePoints(widget.center),
                color: primary.withOpacity(.78),
                strokeWidth: 5,
              ),
            ],
          ),
        MarkerLayer(markers: _markers()),
        const RichAttributionWidget(
          attributions: [TextSourceAttribution('OpenStreetMap contributors')],
        ),
      ],
    );

    return SizedBox(
      height: widget.height,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Stack(
          children: [
            Positioned.fill(child: map),
            if (widget.label != null && widget.label!.isNotEmpty)
              Positioned(
                left: 12,
                top: 12,
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
                  color: Colors.white.withOpacity(.92),
                  child: Text(widget.label!,
                      style: const TextStyle(
                          color: primary, fontWeight: FontWeight.w800)),
                ),
              ),
            if (widget.showControls)
              Positioned(
                right: 12,
                top: 12,
                child: _OsmControls(
                  onZoomIn: () => _changeZoom(1),
                  onZoomOut: () => _changeZoom(-1),
                  onRecenter: _recenter,
                ),
              ),
          ],
        ),
      ),
    );
  }

  List<Marker> _markers() {
    final offsets = <(double, double, bool)>[
      (.010, -.020, false),
      (.016, -.006, false),
      (.005, .012, true),
      (-.009, .018, false),
      (-.017, .004, false),
      (-.005, -.014, true),
      (.020, .020, false),
      (-.020, -.024, false),
    ];
    return offsets.where((point) {
      if (point.$3) return widget.showIncidents;
      return widget.showPoints;
    }).map((point) {
      final danger = point.$3;
      final color = danger ? alert : const Color(0xFF159447);
      return Marker(
        point: LatLng(widget.center.latitude + point.$1,
            widget.center.longitude + point.$2),
        width: widget.heat ? 54 : 30,
        height: widget.heat ? 54 : 30,
        child: Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: color.withOpacity(widget.heat ? .34 : 1),
            border: Border.all(color: Colors.white, width: widget.heat ? 1 : 2),
            boxShadow: widget.heat
                ? [BoxShadow(color: color.withOpacity(.48), blurRadius: 18)]
                : const [BoxShadow(color: Color(0x33000000), blurRadius: 4)],
          ),
          child: danger
              ? const Icon(Icons.warning_rounded, color: Colors.white, size: 15)
              : const Icon(Icons.circle, color: Colors.white, size: 8),
        ),
      );
    }).toList();
  }

  List<LatLng> _routePoints(LatLng center) => [
        LatLng(center.latitude - .026, center.longitude - .028),
        LatLng(center.latitude - .016, center.longitude - .010),
        LatLng(center.latitude - .005, center.longitude - .014),
        LatLng(center.latitude + .004, center.longitude + .008),
        LatLng(center.latitude + .016, center.longitude + .004),
        LatLng(center.latitude + .025, center.longitude + .027),
      ];
}

class _OsmControls extends StatelessWidget {
  const _OsmControls({
    required this.onZoomIn,
    required this.onZoomOut,
    required this.onRecenter,
  });

  final VoidCallback onZoomIn;
  final VoidCallback onZoomOut;
  final VoidCallback onRecenter;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.white,
        elevation: 2,
        borderRadius: BorderRadius.circular(6),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
                tooltip: 'Zoom in',
                onPressed: onZoomIn,
                icon: const Icon(Icons.add_rounded)),
            IconButton(
                tooltip: 'Zoom out',
                onPressed: onZoomOut,
                icon: const Icon(Icons.remove_rounded)),
            IconButton(
                tooltip: 'Recenter map',
                onPressed: onRecenter,
                icon: const Icon(Icons.my_location_rounded)),
          ],
        ),
      );
}
