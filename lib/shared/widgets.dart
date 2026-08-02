import 'package:flutter/material.dart';

import '../app/theme.dart';

class PageScaffold extends StatelessWidget {
  const PageScaffold({
    super.key,
    required this.title,
    this.subtitle,
    this.breadcrumb,
    required this.children,
    this.actions,
    this.scroll = true,
  });

  final String title;
  final String? subtitle;
  final String? breadcrumb;
  final List<Widget> children;
  final List<Widget>? actions;
  final bool scroll;

  @override
  Widget build(BuildContext context) {
    final body = Padding(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 28),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (breadcrumb != null)
            Text(breadcrumb!,
                style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: textMuted)),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        style: Theme.of(context).textTheme.headlineLarge),
                    if (subtitle != null) ...[
                      const SizedBox(height: 6),
                      Text(subtitle!,
                          style:
                              const TextStyle(color: textMuted, fontSize: 16)),
                    ],
                  ],
                ),
              ),
              if (actions != null)
                Wrap(spacing: 8, runSpacing: 8, children: actions!),
            ],
          ),
          const SizedBox(height: 24),
          ...children,
        ],
      ),
    );
    return scroll ? SingleChildScrollView(child: body) : body;
  }
}

class AppCard extends StatelessWidget {
  const AppCard(
      {super.key,
      required this.child,
      this.padding = const EdgeInsets.all(16),
      this.height,
      this.width,
      this.tint});
  final Widget child;
  final EdgeInsets padding;
  final double? height;
  final double? width;
  final Color? tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: tint ?? surface,
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
              color: Color(0x12000000), blurRadius: 8, offset: Offset(0, 2))
        ],
      ),
      child: child,
    );
  }
}

class KpiCard extends StatelessWidget {
  const KpiCard(
      {super.key,
      required this.title,
      required this.value,
      required this.icon,
      this.trend,
      this.warning = false});
  final String title;
  final String value;
  final String? trend;
  final IconData icon;
  final bool warning;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: AppCard(
        height: 124,
        tint: warning ? const Color(0xFFFFF5EF) : surface,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                    child: Text(title,
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, color: textMuted))),
                CircleAvatar(
                    radius: 17,
                    backgroundColor: warning ? alertSoft : primarySoft,
                    child:
                        Icon(icon, size: 19, color: warning ? alert : primary)),
              ],
            ),
            const Spacer(),
            Text(value,
                style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w700,
                    color: warning ? alert : const Color(0xFF1B211A))),
            if (trend != null)
              Text(trend!,
                  style: TextStyle(
                      fontSize: 13,
                      color: warning ? alert : const Color(0xFF2E6735),
                      fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

class ChipPill extends StatelessWidget {
  const ChipPill(this.label,
      {super.key, this.active = false, this.danger = false});
  final String label;
  final bool active;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: danger
            ? alertSoft
            : active
                ? primarySoft
                : background,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
            color: danger
                ? const Color(0xFFFFB0A8)
                : active
                    ? const Color(0xFF78C982)
                    : border),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: danger
                  ? alert
                  : active
                      ? primary
                      : const Color(0xFF343A32))),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(this.title, {super.key, this.icon});
  final String title;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        if (icon != null) ...[
          Icon(icon, color: primary),
          const SizedBox(width: 8)
        ],
        Text(title, style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class DataTableCard extends StatelessWidget {
  const DataTableCard(
      {super.key,
      required this.columns,
      required this.rows,
      this.title,
      this.footer});
  final List<String> columns;
  final List<List<Widget>> rows;
  final String? title;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    return AppCard(
      padding: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (title != null)
            Padding(
              padding: const EdgeInsets.all(16),
              child:
                  Text(title!, style: Theme.of(context).textTheme.titleMedium),
            ),
          Table(
            columnWidths: {
              for (var i = 0; i < columns.length; i++)
                i: const FlexColumnWidth()
            },
            children: [
              TableRow(
                decoration: const BoxDecoration(
                    color: Color(0xFFF2F3ED),
                    border: Border(bottom: BorderSide(color: border))),
                children: columns
                    .map((c) => Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(c.toUpperCase(),
                            style: const TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w800,
                                color: textMuted))))
                    .toList(),
              ),
              ...rows.map(
                (row) => TableRow(
                  decoration: const BoxDecoration(
                      border:
                          Border(bottom: BorderSide(color: Color(0xFFE8EBE3)))),
                  children: row
                      .map((cell) => Padding(
                          padding: const EdgeInsets.all(16), child: cell))
                      .toList(),
                ),
              ),
            ],
          ),
          if (footer != null) footer!,
        ],
      ),
    );
  }
}

class FakeMap extends StatelessWidget {
  const FakeMap(
      {super.key,
      this.heat = false,
      this.height = 420,
      this.label = 'EcoWaste GIS'});
  final bool heat;
  final double height;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFDCE5D7),
        border: Border.all(color: border),
        borderRadius: BorderRadius.circular(12),
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned.fill(child: CustomPaint(painter: MapPainter(heat: heat))),
          Positioned(
              left: 16,
              top: 14,
              child: Text(label,
                  style: const TextStyle(
                      fontWeight: FontWeight.w800, color: Color(0xAA1B211A)))),
          Positioned(right: 16, top: 16, child: MapControls(vertical: true)),
          Positioned(
              left: 18,
              bottom: 18,
              child: AppCard(
                  padding: const EdgeInsets.all(10),
                  child: const Text(
                      'BIN STATUS\n● Empty   ● Warning   ● Critical',
                      style: TextStyle(fontSize: 12)))),
        ],
      ),
    );
  }
}

class MapControls extends StatelessWidget {
  const MapControls({super.key, this.vertical = false});
  final bool vertical;
  @override
  Widget build(BuildContext context) {
    final icons = [
      Icons.add_rounded,
      Icons.remove_rounded,
      Icons.layers_rounded,
      Icons.my_location_rounded,
      Icons.straighten_rounded,
      Icons.fullscreen_rounded
    ];
    final children = icons
        .map((icon) => IconButton(
            onPressed: () {},
            icon: Icon(icon),
            constraints: const BoxConstraints.tightFor(width: 38, height: 38),
            padding: EdgeInsets.zero))
        .toList();
    return AppCard(
      padding: EdgeInsets.zero,
      child: vertical
          ? Column(mainAxisSize: MainAxisSize.min, children: children)
          : Row(mainAxisSize: MainAxisSize.min, children: children),
    );
  }
}

class MapPainter extends CustomPainter {
  MapPainter({
    required this.heat,
    this.showPoints = true,
    this.showRoutes = true,
    this.showIncidents = true,
  });
  final bool heat;
  final bool showPoints;
  final bool showRoutes;
  final bool showIncidents;

  @override
  void paint(Canvas canvas, Size size) {
    final bg = Paint()..color = const Color(0xFFE8EEE5);
    canvas.drawRect(Offset.zero & size, bg);
    final road = Paint()
      ..color = Colors.white
      ..strokeWidth = 7
      ..style = PaintingStyle.stroke;
    final minor = Paint()
      ..color = const Color(0xFFC8D3C2)
      ..strokeWidth = 2;
    for (var i = -80.0; i < size.width; i += 72) {
      canvas.drawLine(
          Offset(i, 0), Offset(i + size.height * .65, size.height), road);
      canvas.drawLine(Offset(i + 28, 0),
          Offset(i + size.height * .65 + 28, size.height), minor);
    }
    for (var y = 44.0; y < size.height; y += 68) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 18), road);
      canvas.drawLine(Offset(0, y + 28), Offset(size.width, y + 46), minor);
    }
    final route = Paint()
      ..color = primary.withOpacity(.65)
      ..strokeWidth = 5
      ..style = PaintingStyle.stroke;
    final path = Path()
      ..moveTo(size.width * .12, size.height * .74)
      ..cubicTo(size.width * .28, size.height * .52, size.width * .42,
          size.height * .62, size.width * .52, size.height * .38)
      ..cubicTo(size.width * .64, size.height * .18, size.width * .78,
          size.height * .35, size.width * .9, size.height * .2);
    if (showRoutes) canvas.drawPath(path, route);
    final points = [
      Offset(size.width * .22, size.height * .48),
      Offset(size.width * .33, size.height * .56),
      Offset(size.width * .52, size.height * .39),
      Offset(size.width * .64, size.height * .62),
      Offset(size.width * .72, size.height * .28),
      Offset(size.width * .82, size.height * .54),
      Offset(size.width * .48, size.height * .72),
      Offset(size.width * .37, size.height * .28),
    ];
    for (var i = 0; i < points.length; i++) {
      final isIncident = i % 5 == 0;
      if (isIncident && !showIncidents) continue;
      if (!isIncident && !showPoints) continue;
      final p = Paint()
        ..color = isIncident
            ? alert
            : i % 3 == 0
                ? const Color(0xFFFFC400)
                : const Color(0xFF13A44B);
      canvas.drawCircle(points[i], heat ? 18 : 7,
          p..color = p.color.withOpacity(heat ? .7 : 1));
      if (heat)
        canvas.drawCircle(points[i], 34, p..color = p.color.withOpacity(.22));
    }
  }

  @override
  bool shouldRepaint(covariant MapPainter oldDelegate) =>
      heat != oldDelegate.heat ||
      showPoints != oldDelegate.showPoints ||
      showRoutes != oldDelegate.showRoutes ||
      showIncidents != oldDelegate.showIncidents;
}

class MiniBars extends StatelessWidget {
  const MiniBars({super.key});
  @override
  Widget build(BuildContext context) {
    final values = [44, 72, 56, 98, 122, 36, 28];
    return SizedBox(
      height: 150,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final v in values)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Container(
                    height: v.toDouble(),
                    decoration: BoxDecoration(
                        color: v > 100 ? primary : const Color(0xFFA9B7A8),
                        borderRadius: BorderRadius.circular(5))),
              ),
            ),
        ],
      ),
    );
  }
}

List<Widget> tableRow(List<String> cells, {bool selected = false}) => cells
    .map((text) => Text(text,
        style: TextStyle(
            fontWeight: selected ? FontWeight.w800 : FontWeight.w500,
            color: selected ? primary : const Color(0xFF1C211B))))
    .toList();

Widget formLabel(String text) => Padding(
    padding: const EdgeInsets.only(top: 12, bottom: 6),
    child: Text(text,
        style: const TextStyle(
            fontSize: 12, color: textMuted, fontWeight: FontWeight.w800)));
Widget fakeField(String text) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(13),
    decoration: BoxDecoration(
        color: const Color(0xFFF1F3ED), borderRadius: BorderRadius.circular(6)),
    child: Text(text));

class MetricLine extends StatelessWidget {
  const MetricLine(this.label, this.value, {super.key});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(children: [
        Expanded(child: Text(label, style: const TextStyle(color: textMuted))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w800))
      ]));
}
