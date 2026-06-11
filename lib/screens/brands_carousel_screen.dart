import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../theme.dart';

class BrandsCarouselScreen extends StatefulWidget {
  const BrandsCarouselScreen({super.key});

  @override
  State<BrandsCarouselScreen> createState() => _BrandsCarouselScreenState();
}

class _BrandsCarouselScreenState extends State<BrandsCarouselScreen> {
  static const _brands = [
    {'name': 'Samsung', 'asset': 'assets/samsung.png', 'url': 'https://www.samsung.com'},
    {'name': 'Apple', 'asset': 'assets/apple.png', 'url': 'https://www.apple.com'},
    {'name': 'Windows', 'asset': 'assets/windows.png', 'url': 'https://www.microsoft.com'},
  ];

  int _current = 0;

  String get _name => _brands[_current]['name']!;
  String get _url => _brands[_current]['url']!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Brand.orange,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: const Text('Others'),
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          const Text('You might also like',
              style: TextStyle(color: Colors.black54, fontSize: 13)),
          const SizedBox(height: 16),
          CarouselSlider(
            options: CarouselOptions(
              height: 260,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              enlargeCenterPage: true,
              viewportFraction: 0.6,
              clipBehavior: Clip.none,
              padEnds: true,
              onPageChanged: (index, _) => setState(() => _current = index),
            ),
            items: _brands.map((brand) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 14),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(32),
                child: Center(child: Image.asset(brand['asset']!, fit: BoxFit.contain)),
              );
            }).toList(),
          ),
          const SizedBox(height: 24),
          Text(_name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_brands.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: _current == i ? 18 : 7,
                height: 7,
                margin: const EdgeInsets.symmetric(horizontal: 3),
                decoration: BoxDecoration(
                  color: _current == i ? Brand.orange : Colors.black26,
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }),
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Container(
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                boxShadow: softShadow(y: 8, blur: 20, opacity: 0.36, color: Brand.orange),
              ),
              child: ElevatedButton(
                onPressed: () => _launch(_url),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Brand.orange,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                ),
                child: Text('Visit $_name Website',
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    try {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } catch (_) {
      await launchUrl(uri, mode: LaunchMode.platformDefault);
    }
  }
}
