import 'package:flutter/material.dart';

/// Brand colors used across the app, matching the PDF mockups.
class Brand {
  static const youtube = Color(0xFFFF0000);
  static const spotify = Color(0xFF1DB954);
  static const facebook = Color(0xFF1877F2);
  static const orange = Color(0xFFFFA000);

  // Action colors.
  static const enterGreen = Color(0xFF5CB85C);

  // Refined neutral palette.
  static const ink = Color(0xFF1B1D22);
  static const subtle = Color(0xFF8A9099);
  static const hairline = Color(0xFFE8EAED);
  static const surface = Color(0xFFF6F7F9);
}

/// Soft, layered elevation used for cards and tiles.
/// Pass [color] to tint the shadow into a colored glow (e.g. under a button).
List<BoxShadow> softShadow({
  double y = 10,
  double blur = 26,
  double opacity = 0.10,
  Color color = Colors.black,
}) {
  return [
    BoxShadow(
      color: color.withValues(alpha: opacity),
      blurRadius: blur,
      offset: Offset(0, y),
    ),
    BoxShadow(
      color: color.withValues(alpha: opacity * 0.4),
      blurRadius: blur * 0.3,
      offset: Offset(0, y * 0.3),
    ),
  ];
}

/// A child that scales down slightly while pressed — tactile feedback.
class Pressable extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;
  final double scale;

  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.scale = 0.94,
  });

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _down = true),
      onTapUp: (_) => setState(() => _down = false),
      onTapCancel: () => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? widget.scale : 1.0,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}
