import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../services/api_service.dart';
import '../validators.dart';
import '../widgets/loading_view.dart';
import 'screen1_login.dart';
import 'screen3_home.dart';

class Screen2Loading extends StatefulWidget {
  final String userName;
  final String otp;

  const Screen2Loading({super.key, required this.userName, required this.otp});

  @override
  State<Screen2Loading> createState() => _Screen2LoadingState();
}

class _Screen2LoadingState extends State<Screen2Loading> {
  final String _status = 'Logging In';
  bool _failed = false;
  Map<String, dynamic>? _userData;

  @override
  void initState() {
    super.initState();
    _doLogin();
  }

  Future<void> _doLogin() async {
    try {
      final result = await ApiService.login(widget.userName, widget.otp);
      if (isLoginSuccess(result)) {
        _userData = result;
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => Screen3Home(userData: _userData)),
          );
        }
      } else {
        const msg = 'Login Failed, please try again';
        setState(() => _failed = true);
        await Future.delayed(const Duration(seconds: 1));
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const Screen1Login(errorMessage: msg)),
          );
        }
      }
    } catch (e) {
      setState(() => _failed = true);
      await Future.delayed(const Duration(seconds: 1));
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => const Screen1Login(errorMessage: 'Network error. Please try again.'),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: LoadingView(
          label: _failed ? 'Login Failed' : _status,
          failed: _failed,
        ),
      ),
    );
  }
}
