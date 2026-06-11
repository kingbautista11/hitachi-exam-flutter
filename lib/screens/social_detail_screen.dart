import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import 'web_view_screen.dart';

class SocialDetailScreen extends StatelessWidget {
  final String name;
  final String asset;
  final Color color;
  final Map<String, dynamic>? socialData;

  const SocialDetailScreen({
    super.key,
    required this.name,
    required this.asset,
    required this.color,
    this.socialData,
  });

  @override
  Widget build(BuildContext context) {
    final url = socialData?['webUrl'] ?? _defaultUrl();
    final imgUrl = socialData?['imgUrl']?.toString();
    // Show only the first paragraph of the history text.
    final fullHistory = (socialData?['history'] ?? 'No description available.').toString();
    final description = fullHistory.trim().split(RegExp(r'\n\s*\n')).first.trim();

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: color,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(name),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Full-width banner image from the API.
          _banner(imgUrl),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Text(
                description.toString(),
                style: const TextStyle(fontSize: 14, height: 1.5, color: Colors.black87),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 8, 24, 24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: softShadow(y: 8, blur: 20, opacity: 0.32, color: color),
              ),
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => WebViewScreen(
                      url: url.toString(),
                      title: name,
                      color: color,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Visit $name',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _banner(String? imgUrl) {
    const height = 200.0;
    if (imgUrl != null && imgUrl.isNotEmpty) {
      return CachedNetworkImage(
        imageUrl: imgUrl,
        width: double.infinity,
        height: height,
        fit: BoxFit.cover,
        placeholder: (_, _) => Container(
          width: double.infinity,
          height: height,
          color: color.withValues(alpha: 0.2),
          child: const Center(child: CircularProgressIndicator()),
        ),
        errorWidget: (_, _, _) => _fallbackBanner(height),
      );
    }
    return _fallbackBanner(height);
  }

  Widget _fallbackBanner(double height) {
    return Container(
      width: double.infinity,
      height: height,
      color: color,
      child: Center(
        child: Image.asset(asset, width: 90, height: 90, fit: BoxFit.contain),
      ),
    );
  }

  String _defaultUrl() {
    switch (name.toLowerCase()) {
      case 'youtube':
        return 'https://www.youtube.com';
      case 'spotify':
        return 'https://www.spotify.com';
      case 'facebook':
        return 'https://www.facebook.com';
      default:
        return 'https://www.google.com';
    }
  }

}
