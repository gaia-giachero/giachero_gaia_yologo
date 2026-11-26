import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:giachero_gaia_yologo/theme/app_text_styles.dart';
import 'package:giachero_gaia_yologo/utils/app_strings.dart';
import 'package:giachero_gaia_yologo/widgets/animated_globe.dart';

class SplashScreen extends StatefulWidget {
  final List<Future<void> Function()> steps;

  final Widget next;

  const SplashScreen({required this.steps, required this.next, super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  static const Color _background = Color(0xFF0C182C);
  static const Color _backgroundGlow = Color(0xFF17315C);
  static const Color _textColor = Colors.white;

  static const Duration _cycle = Duration(seconds: 12);
  static const Duration _minimum = Duration(milliseconds: 2800);
  static const Duration _growDuration = Duration(milliseconds: 900);
  static const Duration _fadeDuration = Duration(milliseconds: 500);

  static const int _planeLaps = 4;
  static const double _minScale = 0.5;
  static const double _maxGlobeWidth = 420;
  static const double _gapTitle = 8;
  static const double _gapError = 16;
  static const double _glowRadius = 0.9;

  late final AnimationController _controller;
  double _progress = 0;
  bool _hasError = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: _cycle)..repeat();
    _run();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _run() async {
    final minimum = Future<void>.delayed(_minimum);
    try {
      final total = widget.steps.length;
      for (var i = 0; i < total; i++) {
        await widget.steps[i]();
        if (!mounted) return;
        setState(() => _progress = (i + 1) / total);
      }
      if (!mounted) return;
      setState(() => _progress = 1);
      await minimum;
    } catch (e) {
      debugPrint('Errore all\'avvio: $e');
      if (!mounted) return;
      setState(() => _hasError = true);
      return;
    }
    if (!mounted) return;
    _goNext();
  }

  void _retry() {
    setState(() {
      _hasError = false;
      _progress = 0;
    });
    _run();
  }

  void _goNext() {
    Navigator.of(context).pushReplacement(
      PageRouteBuilder<void>(
        transitionDuration: _fadeDuration,
        pageBuilder: (context, animation, secondaryAnimation) => widget.next,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildLogo(double globeWidth) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: _progress),
      duration: _growDuration,
      curve: Curves.easeOutCubic,
      builder: (context, progress, child) {
        final scale = _minScale + (1 - _minScale) * progress;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Transform.scale(
              scale: scale,
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, child) {
                  return AnimatedGlobe(
                    width: globeWidth,
                    spin: _controller.value,
                    orbit: (_controller.value * _planeLaps) % 1,
                  );
                },
              ),
            ),
            const SizedBox(height: _gapTitle),
            Opacity(
              opacity: progress,
              child: Text(
                AppStrings.title,
                style: AppTextStyles.brandTitle.copyWith(color: _textColor),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildError() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          AppStrings.splashError,
          textAlign: TextAlign.center,
          style: AppTextStyles.body.copyWith(color: _textColor),
        ),
        const SizedBox(height: _gapError),
        TextButton(
          onPressed: _retry,
          style: TextButton.styleFrom(foregroundColor: _textColor),
          child: Text(AppStrings.errorButton),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final globeWidth = math.min(
      MediaQuery.sizeOf(context).width,
      _maxGlobeWidth,
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: _background,
        body: DecoratedBox(
          decoration: const BoxDecoration(
            gradient: RadialGradient(
              radius: _glowRadius,
              colors: [_backgroundGlow, _background],
            ),
          ),
          child: SizedBox.expand(
            child: Center(
              child: _hasError ? _buildError() : _buildLogo(globeWidth),
            ),
          ),
        ),
      ),
    );
  }
}
