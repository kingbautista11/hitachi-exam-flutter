import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../theme.dart';

/// The three brand icons stacked diagonally. When [animate] is true they bob
/// up and down in a staggered left-to-right wave.
class WavingLogo extends StatefulWidget {
  final bool animate;
  const WavingLogo({super.key, this.animate = true});

  @override
  State<WavingLogo> createState() => _WavingLogoState();
}

class _WavingLogoState extends State<WavingLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );
    if (widget.animate) _controller.repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 210,
      height: 160,
      child: Stack(
        children: [
          Positioned(left: 0, top: 0, child: _tile('assets/youtube.png', 0)),
          Positioned(left: 55, top: 30, child: _tile('assets/spotify.png', 1)),
          Positioned(left: 110, top: 60, child: _tile('assets/facebook.png', 2)),
        ],
      ),
    );
  }

  Widget _tile(String asset, int index) {
    const amplitude = 9.0;
    const phaseStep = math.pi / 3;
    final tile = Container(
      width: 90,
      height: 90,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: softShadow(y: 8, blur: 22, opacity: 0.16),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: Image.asset(asset, fit: BoxFit.cover),
      ),
    );

    if (!widget.animate) return tile;

    return RepaintBoundary(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = _controller.value * 2 * math.pi;
          final dy = math.sin(t + index * phaseStep) * amplitude;
          return Transform.translate(offset: Offset(0, dy), child: child);
        },
        child: tile,
      ),
    );
  }
}
