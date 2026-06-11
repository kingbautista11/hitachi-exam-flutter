import 'package:flutter/material.dart';
import '../theme.dart';

/// Centered spinner with a caption, used for all loading/status screens
/// ("Logging In", "Fetching Data", "Logging Out", "Login Failed").
class LoadingView extends StatelessWidget {
  final String label;
  final bool failed;

  const LoadingView({super.key, required this.label, this.failed = false});

  @override
  Widget build(BuildContext context) {
    final color = failed ? Colors.red : Brand.facebook;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 34,
            height: 34,
            child: CircularProgressIndicator(
              color: color,
              strokeWidth: 3,
              strokeCap: StrokeCap.round,
            ),
          ),
          const SizedBox(height: 22),
          Text(
            label,
            style: TextStyle(
              color: failed ? Colors.red : Brand.subtle,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.3,
            ),
          ),
        ],
      ),
    );
  }
}
