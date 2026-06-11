import 'package:flutter/cupertino.dart';
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
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CupertinoActivityIndicator(
            radius: 14,
            color: failed ? Colors.red : Brand.subtle,
          ),
          const SizedBox(height: 18),
          Text(
            label,
            style: TextStyle(
              color: failed ? Colors.red : Brand.subtle,
              fontSize: 14,
              fontWeight: FontWeight.w500,
              letterSpacing: 0.2,
            ),
          ),
        ],
      ),
    );
  }
}
