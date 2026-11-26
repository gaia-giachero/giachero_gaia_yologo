import 'dart:math' as math;

import 'package:flutter/material.dart';

/// Mappamondo neon che ruota, con un aereo che gli orbita attorno.
/// [spin] e [orbit] vanno da 0 a 1 e li decide chi lo usa (animazione).
class AnimatedGlobe extends StatelessWidget {
  static const double aspectRatio = 0.72;

  final double width;
  final double spin;
  final double orbit;

  const AnimatedGlobe({
    required this.width,
    required this.spin,
    required this.orbit,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, width * aspectRatio),
      painter: _GlobePainter(spin: spin, orbit: orbit),
    );
  }
}

typedef _Projection = ({Offset point, double depth});

class _GlobePainter extends CustomPainter {
  // Colori neon
  static const Color _cyan = Color(0xFF3DF0E6);
  static const Color _blue = Color(0xFF3C8CFF);
  static const Color _orange = Color(0xFFFFA23A);
  static const Color _planeColor = Color(0xFFEAF6FF);
  static const Color _globeLight = Color(0xFF17356A);
  static const Color _globeDark = Color(0xFF081226);

  // Proporzioni (il riferimento è il raggio del mappamondo)
  static const double _radiusFactor = 0.30;
  static const double _orbitA = 1.55;
  static const double _orbitB = 0.5;
  static const double _orbitTilt = -0.49;
  static const double _axisTilt = 0.32;
  static const double _outlineWidth = 0.022;
  static const double _gridWidth = 0.010;
  static const double _landWidth = 0.013;
  static const double _orbitWidth = 0.020;
  static const double _trailWidth = 0.05;
  static const double _planeLength = 0.55;
  static const double _planeDepthScale = 0.18;
  static const double _planeUnits = 194;
  static const double _planeGlowBlur = 5;
  static const double _planeGlowAlpha = 0.8;
  static const double _gridAlpha = 0.5;
  static const double _landAlpha = 0.9;
  static const double _frontAlpha = 0.9;
  static const double _backAlpha = 0.35;
  static const double _backTrailAlpha = 0.45;

  // Alone luminoso dei tratti
  static const double _glowWidth = 3;
  static const double _glowAlpha = 0.45;
  static const double _glowBlur = 1.6;

  // Campionamento e scia
  static const double _gridStep = 30;
  static const double _sampleStep = 6;
  static const double _orbitStep = 0.06;
  static const double _trailSpan = 1.2;
  static const int _trailSegments = 28;
  static const double _planeAhead = 0.02;
  static const double _trailMinWidth = 0.4;

  // Continenti semplificati: (longitudine, latitudine)
  static const List<List<(num, num)>> _continents = [
    // Nord America
    [
      (-168, 65),
      (-156, 71),
      (-141, 70),
      (-128, 70),
      (-115, 68),
      (-95, 68),
      (-82, 68),
      (-75, 62),
      (-65, 60),
      (-60, 55),
      (-56, 52),
      (-66, 45),
      (-70, 42),
      (-76, 37),
      (-81, 31),
      (-80, 26),
      (-83, 29),
      (-90, 30),
      (-97, 27),
      (-97, 22),
      (-91, 19),
      (-87, 21),
      (-88, 16),
      (-83, 10),
      (-79, 9),
      (-83, 8),
      (-86, 12),
      (-92, 15),
      (-105, 20),
      (-110, 24),
      (-113, 31),
      (-117, 32),
      (-121, 35),
      (-124, 40),
      (-124, 48),
      (-130, 54),
      (-140, 60),
      (-150, 60),
      (-158, 57),
      (-165, 60),
      (-168, 65),
    ],
    // Groenlandia
    [
      (-73, 78),
      (-60, 82),
      (-30, 83),
      (-20, 78),
      (-22, 70),
      (-40, 65),
      (-48, 61),
      (-54, 66),
      (-58, 75),
      (-73, 78),
    ],
    // Sud America
    [
      (-80, 9),
      (-75, 11),
      (-67, 11),
      (-60, 8),
      (-52, 5),
      (-50, 0),
      (-44, -2),
      (-35, -5),
      (-35, -9),
      (-39, -15),
      (-41, -22),
      (-48, -26),
      (-53, -34),
      (-58, -38),
      (-65, -41),
      (-66, -47),
      (-69, -52),
      (-72, -54),
      (-74, -50),
      (-74, -40),
      (-72, -30),
      (-70, -18),
      (-76, -14),
      (-81, -6),
      (-80, -1),
      (-78, 3),
      (-80, 9),
    ],
    // Europa e Asia
    [
      (-9, 37),
      (-9, 43),
      (-1, 44),
      (-4, 48),
      (2, 51),
      (8, 54),
      (10, 57),
      (14, 55),
      (22, 55),
      (24, 60),
      (30, 60),
      (23, 65),
      (18, 69),
      (28, 71),
      (40, 67),
      (60, 69),
      (80, 73),
      (100, 77),
      (130, 71),
      (160, 70),
      (180, 67),
      (172, 61),
      (163, 58),
      (156, 51),
      (143, 52),
      (140, 48),
      (135, 43),
      (129, 40),
      (126, 37),
      (126, 34),
      (122, 40),
      (118, 38),
      (122, 31),
      (120, 26),
      (110, 21),
      (106, 19),
      (109, 12),
      (105, 9),
      (100, 13),
      (100, 7),
      (103, 2),
      (98, 8),
      (98, 16),
      (92, 22),
      (88, 22),
      (80, 15),
      (77, 8),
      (73, 18),
      (68, 23),
      (62, 25),
      (57, 26),
      (56, 24),
      (52, 24),
      (48, 28),
      (50, 30),
      (57, 23),
      (59, 22),
      (52, 16),
      (43, 13),
      (35, 28),
      (34, 31),
      (36, 36),
      (27, 37),
      (26, 40),
      (23, 37),
      (20, 40),
      (19, 42),
      (13, 45),
      (18, 40),
      (16, 38),
      (12, 42),
      (8, 44),
      (3, 43),
      (0, 39),
      (-5, 36),
      (-9, 37),
    ],
    // Africa
    [
      (-17, 21),
      (-13, 28),
      (-6, 36),
      (10, 37),
      (11, 33),
      (20, 31),
      (32, 31),
      (34, 28),
      (43, 12),
      (51, 12),
      (40, -3),
      (40, -15),
      (35, -25),
      (32, -29),
      (26, -34),
      (18, -34),
      (12, -18),
      (14, -8),
      (9, -1),
      (9, 4),
      (-8, 4),
      (-13, 8),
      (-17, 14),
      (-17, 21),
    ],
    // Australia
    [
      (114, -22),
      (122, -18),
      (130, -12),
      (136, -12),
      (142, -11),
      (146, -19),
      (153, -26),
      (150, -37),
      (141, -38),
      (135, -35),
      (129, -32),
      (116, -35),
      (114, -22),
    ],
  ];

  // Sagoma dell'aereo, rivolta verso destra
  static final Path _plane = _buildPlane();

  static Path _buildPlane() {
    return Path()
      ..moveTo(92, 0)
      ..cubicTo(62, -15, -50, -15, -82, -6)
      ..lineTo(-82, 6)
      ..cubicTo(-50, 15, 62, 15, 92, 0)
      ..close()
      ..moveTo(28, -6)
      ..lineTo(-30, -84)
      ..lineTo(-54, -84)
      ..lineTo(-24, -6)
      ..close()
      ..moveTo(28, 6)
      ..lineTo(-30, 84)
      ..lineTo(-54, 84)
      ..lineTo(-24, 6)
      ..close()
      ..moveTo(-64, -5)
      ..lineTo(-88, -36)
      ..lineTo(-102, -36)
      ..lineTo(-86, -3)
      ..close()
      ..moveTo(-64, 5)
      ..lineTo(-88, 36)
      ..lineTo(-102, 36)
      ..lineTo(-86, 3)
      ..close();
  }

  final double spin;
  final double orbit;

  const _GlobePainter({required this.spin, required this.orbit});

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.width * _radiusFactor;

    _drawOrbit(canvas, center, radius, front: false);
    _drawGlobe(canvas, center, radius);
    _drawOrbit(canvas, center, radius, front: true);
  }

  // ---------- Globo ----------

  void _drawGlobe(Canvas canvas, Offset c, double r) {
    final rect = Rect.fromCircle(center: c, radius: r);

    canvas.drawCircle(
      c,
      r,
      Paint()
        ..shader = const RadialGradient(
          center: Alignment(-0.35, -0.4),
          radius: 1.0,
          colors: [_globeLight, _globeDark],
        ).createShader(rect),
    );

    final grid = Path();
    for (var lon = 0.0; lon < 360; lon += _gridStep) {
      _addVisible(grid, [
        for (var lat = -90.0; lat <= 90; lat += _sampleStep)
          _project(c, r, lat, lon),
      ]);
    }
    for (var lat = -60.0; lat <= 60; lat += _gridStep) {
      _addVisible(grid, [
        for (var lon = 0.0; lon <= 360; lon += _sampleStep)
          _project(c, r, lat, lon),
      ]);
    }
    _strokeGlow(
      canvas,
      grid,
      _cyan.withValues(alpha: _gridAlpha),
      r * _gridWidth,
    );

    final land = Path();
    for (final shape in _continents) {
      _addVisible(land, [for (final p in shape) _project(c, r, p.$2, p.$1)]);
    }
    _strokeGlow(
      canvas,
      land,
      _orange.withValues(alpha: _landAlpha),
      r * _landWidth,
    );

    _strokeGlow(canvas, Path()..addOval(rect), _cyan, r * _outlineWidth);
  }

  /// Proietta un punto (latitudine, longitudine) sul disco visibile.
  /// depth > 0 significa che il punto è sul lato rivolto verso chi guarda.
  _Projection _project(Offset c, double r, num latDeg, num lonDeg) {
    final lat = latDeg * math.pi / 180;
    final lon = lonDeg * math.pi / 180 + spin * 2 * math.pi;
    final x0 = math.cos(lat) * math.sin(lon);
    final y0 = math.sin(lat);
    final z = math.cos(lat) * math.cos(lon);
    final x1 = x0 * math.cos(_axisTilt) - y0 * math.sin(_axisTilt);
    final y1 = x0 * math.sin(_axisTilt) + y0 * math.cos(_axisTilt);
    return (point: Offset(c.dx + r * x1, c.dy - r * y1), depth: z);
  }

  /// Aggiunge al percorso solo i tratti sul lato visibile.
  void _addVisible(Path path, List<_Projection> points) {
    var drawing = false;
    for (final p in points) {
      if (p.depth <= 0) {
        drawing = false;
        continue;
      }
      if (drawing) {
        path.lineTo(p.point.dx, p.point.dy);
      } else {
        path.moveTo(p.point.dx, p.point.dy);
        drawing = true;
      }
    }
  }

  // ---------- Orbita, scia e aereo ----------

  Offset _orbitPoint(Offset c, double r, double theta) {
    final x = _orbitA * r * math.cos(theta);
    final y = _orbitB * r * math.sin(theta);
    final cosT = math.cos(_orbitTilt);
    final sinT = math.sin(_orbitTilt);
    return Offset(c.dx + x * cosT - y * sinT, c.dy + x * sinT + y * cosT);
  }

  Path _orbitArc(Offset c, double r, double from, double to) {
    final path = Path()
      ..moveTo(_orbitPoint(c, r, from).dx, _orbitPoint(c, r, from).dy);
    for (var t = from + _orbitStep; t < to; t += _orbitStep) {
      final p = _orbitPoint(c, r, t);
      path.lineTo(p.dx, p.dy);
    }
    final end = _orbitPoint(c, r, to);
    path.lineTo(end.dx, end.dy);
    return path;
  }

  /// Disegna la metà dell'orbita davanti (front) o dietro al globo,
  /// con la scia e l'aereo se si trovano su quella metà.
  void _drawOrbit(Canvas canvas, Offset c, double r, {required bool front}) {
    final start = front ? 0.0 : math.pi;
    _strokeGlow(
      canvas,
      _orbitArc(c, r, start, start + math.pi),
      _blue.withValues(alpha: front ? _frontAlpha : _backAlpha),
      r * _orbitWidth,
    );

    final planeTheta = -orbit * 2 * math.pi;

    for (var i = 0; i < _trailSegments; i++) {
      final t0 = planeTheta + _trailSpan * i / _trailSegments;
      final t1 = planeTheta + _trailSpan * (i + 1) / _trailSegments;
      final isFront = math.sin((t0 + t1) / 2) > 0;
      if (isFront != front) continue;

      final fade = 1 - i / _trailSegments;
      final p0 = _orbitPoint(c, r, t0);
      final p1 = _orbitPoint(c, r, t1);
      _strokeGlow(
        canvas,
        Path()
          ..moveTo(p0.dx, p0.dy)
          ..lineTo(p1.dx, p1.dy),
        _cyan.withValues(alpha: fade * (front ? 1 : _backTrailAlpha)),
        r * _trailWidth * (_trailMinWidth + (1 - _trailMinWidth) * fade),
      );
    }

    if ((math.sin(planeTheta) > 0) == front) {
      _drawPlane(canvas, c, r, planeTheta);
    }
  }

  void _drawPlane(Canvas canvas, Offset c, double r, double theta) {
    final position = _orbitPoint(c, r, theta);
    final ahead = _orbitPoint(c, r, theta - _planeAhead);
    final heading = math.atan2(ahead.dy - position.dy, ahead.dx - position.dx);
    final depth = math.sin(theta);
    final scale =
        r * _planeLength / _planeUnits * (1 + _planeDepthScale * depth);

    canvas.save();
    canvas.translate(position.dx, position.dy);
    canvas.rotate(heading);
    canvas.scale(scale);
    canvas.drawPath(
      _plane,
      Paint()
        ..color = _cyan.withValues(alpha: _planeGlowAlpha)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, _planeGlowBlur),
    );
    canvas.drawPath(_plane, Paint()..color = _planeColor);
    canvas.restore();
  }

  // ---------- Utilità ----------

  void _strokeGlow(Canvas canvas, Path path, Color color, double width) {
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width * _glowWidth
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color.withValues(alpha: color.a * _glowAlpha)
        ..maskFilter = MaskFilter.blur(BlurStyle.normal, width * _glowBlur),
    );
    canvas.drawPath(
      path,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = width
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round
        ..color = color,
    );
  }

  @override
  bool shouldRepaint(_GlobePainter oldDelegate) {
    return oldDelegate.spin != spin || oldDelegate.orbit != orbit;
  }
}
