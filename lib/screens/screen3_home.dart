import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../theme.dart';
import '../widgets/loading_view.dart';
import 'screen1_login.dart';
import 'social_detail_screen.dart';
import 'brands_carousel_screen.dart';

class Screen3Home extends StatefulWidget {
  final Map<String, dynamic>? userData;
  const Screen3Home({super.key, this.userData});

  @override
  State<Screen3Home> createState() => _Screen3HomeState();
}

class _Screen3HomeState extends State<Screen3Home> {
  List<dynamic> _socials = [];
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _fetchSocials();
  }

  Future<void> _fetchSocials() async {
    try {
      final result = await ApiService.getSocials();
      setState(() {
        _socials = result;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = 'Failed to load socials.';
        _loading = false;
      });
    }
  }

  Map<String, dynamic>? _findSocial(String name) {
    try {
      return _socials.firstWhere(
        (s) => s['name'].toString().toLowerCase() == name.toLowerCase(),
      ) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  void _showLogoutDialog() {
    showCupertinoModalPopup(
      context: context,
      builder: (ctx) => CupertinoActionSheet(
        actions: [
          CupertinoActionSheetAction(
            isDestructiveAction: true,
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => const _LogoutLoadingScreen()),
              );
            },
            child: const Text('Logout'),
          ),
        ],
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(ctx),
          child: const Text('Cancel'),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final userName = widget.userData?['userName']?.toString() ?? 'User';
    final userId = widget.userData?['userId']?.toString() ?? '';
    final avatarUrl = widget.userData?['profilePicture']?.toString();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(userName, userId, avatarUrl),
              const SizedBox(height: 32),
              Expanded(
                child: _loading
                    ? const LoadingView(label: 'Fetching Data')
                    : _error != null
                        ? Center(child: Text(_error!, style: const TextStyle(color: Colors.red)))
                        : _buildGrid(),
              ),
            ],
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildHeader(String userName, String userId, String? avatarUrl) {
    return Row(
      children: [
        Pressable(
          scale: 0.9,
          onTap: _showLogoutDialog,
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              boxShadow: softShadow(y: 4, blur: 14, opacity: 0.18),
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: CircleAvatar(
              radius: 24,
              backgroundColor: Brand.hairline,
              backgroundImage: (avatarUrl != null && avatarUrl.isNotEmpty)
                  ? CachedNetworkImageProvider(avatarUrl)
                  : null,
              child: (avatarUrl == null || avatarUrl.isEmpty)
                  ? const Icon(Icons.person, color: Colors.white)
                  : null,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(userName,
                style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w700)),
            if (userId.isNotEmpty)
              Text(userId,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Brand.subtle,
                      fontWeight: FontWeight.w500,
                      letterSpacing: 0.3)),
          ],
        ),
      ],
    );
  }

  Widget _buildGrid() {
    const gap = 44.0;
    return Align(
      alignment: Alignment.topCenter,
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _gridTile(
                color: Brand.youtube,
                asset: 'assets/youtube.png',
                onTap: () => _openSocial('YouTube', 'assets/youtube.png', Brand.youtube),
              ),
              const SizedBox(width: gap),
              _gridTile(
                color: Brand.spotify,
                asset: 'assets/spotify.png',
                onTap: () => _openSocial('Spotify', 'assets/spotify.png', Brand.spotify),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _gridTile(
                color: Brand.facebook,
                asset: 'assets/facebook.png',
                onTap: () => _openSocial('Facebook', 'assets/facebook.png', Brand.facebook),
              ),
              const SizedBox(width: gap),
              _gridTile(
                color: Brand.orange,
                icon: Icons.login,
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const BrandsCarouselScreen()),
                  );
                },
              ),
            ],
          ),
        ],
        ),
      ),
    );
  }

  void _openSocial(String name, String asset, Color color) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => SocialDetailScreen(
          name: name,
          asset: asset,
          color: color,
          socialData: _findSocial(name),
        ),
      ),
    );
  }

  Widget _gridTile({
    required Color color,
    String? asset,
    IconData? icon,
    required VoidCallback onTap,
  }) {
    return Pressable(
      onTap: onTap,
      child: Container(
        width: 110,
        height: 110,
        decoration: BoxDecoration(
          color: asset != null ? Colors.white : color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: softShadow(y: 10, blur: 22, opacity: 0.22, color: color),
        ),
        clipBehavior: Clip.antiAlias,
        child: asset != null
            ? Image.asset(asset, fit: BoxFit.cover)
            : Center(child: Icon(icon, color: Colors.white, size: 40)),
      ),
    );
  }
}

class _LogoutLoadingScreen extends StatefulWidget {
  const _LogoutLoadingScreen();

  @override
  State<_LogoutLoadingScreen> createState() => _LogoutLoadingScreenState();
}

class _LogoutLoadingScreenState extends State<_LogoutLoadingScreen> {
  @override
  void initState() {
    super.initState();
    _doLogout();
  }

  Future<void> _doLogout() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Screen1Login()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return const AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingView(label: 'Logging Out'),
      ),
    );
  }
}
