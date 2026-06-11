import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme.dart';
import '../validators.dart';
import '../widgets/waving_logo.dart';
import 'screen2_loading.dart';

class Screen1Login extends StatefulWidget {
  final String? errorMessage;
  const Screen1Login({super.key, this.errorMessage});

  @override
  State<Screen1Login> createState() => _Screen1LoginState();
}

class _Screen1LoginState extends State<Screen1Login> {
  final _usernameController = TextEditingController();
  String? _usernameError;

  @override
  void initState() {
    super.initState();
    if (widget.errorMessage != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        showCupertinoDialog(
          context: context,
          builder: (ctx) => CupertinoAlertDialog(
            title: const Text('Error'),
            content: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(widget.errorMessage!),
            ),
            actions: [
              CupertinoDialogAction(
                isDestructiveAction: true,
                onPressed: () => Navigator.pop(ctx),
                child: const Text('Close'),
              ),
            ],
          ),
        );
      });
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    super.dispose();
  }

  bool get _isUsernameValid =>
      _usernameController.text.isNotEmpty && _usernameError == null;

  void _validateUsername(String value) {
    setState(() => _usernameError = usernameError(value));
  }

  void _onEnterPressed() {
    if (!_isUsernameValid) return;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => _PinDialog(
        onSubmit: (pin) {
          Navigator.pop(context); // close dialog
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  Screen2Loading(userName: _usernameController.text, otp: pin),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final canEnter = _isUsernameValid;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: _Entrance(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Column(
              children: [
                const Spacer(flex: 3),
                _buildLogo(),
                const Spacer(flex: 3),
                TextField(
                  controller: _usernameController,
                  keyboardType: TextInputType.text,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  decoration: InputDecoration(
                    hintText: 'Username',
                    hintStyle: TextStyle(
                      color: Brand.subtle.withValues(alpha: 0.7),
                      fontWeight: FontWeight.w500,
                    ),
                    filled: true,
                    fillColor: Brand.surface,
                    contentPadding: const EdgeInsets.symmetric(vertical: 18),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _usernameError != null ? Colors.red : Brand.hairline,
                        width: 1.4,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: BorderSide(
                        color: _usernameError != null ? Colors.red : Brand.facebook,
                        width: 1.8,
                      ),
                    ),
                  ),
                  onChanged: _validateUsername,
                ),
                AnimatedSize(
                  duration: const Duration(milliseconds: 180),
                  child: _usernameError != null
                      ? Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            _usernameError!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        )
                      : const SizedBox.shrink(),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 220),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(14),
                      boxShadow: canEnter
                          ? softShadow(y: 8, blur: 20, opacity: 0.35, color: Brand.enterGreen)
                          : const [],
                    ),
                    child: ElevatedButton(
                      onPressed: canEnter ? _onEnterPressed : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Brand.enterGreen,
                        foregroundColor: Colors.white,
                        disabledBackgroundColor: const Color(0xFFEDEFF1),
                        disabledForegroundColor: Brand.subtle,
                        elevation: 0,
                        padding: const EdgeInsets.symmetric(vertical: 18),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: const Text(
                        'Enter',
                        style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget _buildLogo() => const WavingLogo(animate: false);
}

/// A one-shot fade + rise used to introduce the login screen on launch.
class _Entrance extends StatefulWidget {
  final Widget child;
  const _Entrance({required this.child});

  @override
  State<_Entrance> createState() => _EntranceState();
}

class _EntranceState extends State<_Entrance> {
  double _opacity = 0;
  double _offset = 24;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      setState(() {
        _opacity = 1;
        _offset = 0;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: _opacity,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOut,
      child: AnimatedSlide(
        offset: Offset(0, _offset / 100),
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOutCubic,
        child: widget.child,
      ),
    );
  }
}

/// Modal "Verify It's You" PIN dialog. Shows entered digits as "1 2 3 - - -"
/// and uses the system numeric keyboard (numbers only).
class _PinDialog extends StatefulWidget {
  final void Function(String pin) onSubmit;
  const _PinDialog({required this.onSubmit});

  @override
  State<_PinDialog> createState() => _PinDialogState();
}

class _PinDialogState extends State<_PinDialog> {
  final _controller = TextEditingController();
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => _focusNode.requestFocus(),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  String get _pin => _controller.text;

  @override
  Widget build(BuildContext context) {
    final complete = _pin.length == 6;
    return Dialog(
      backgroundColor: const Color(0xFFEDEDED),
      insetPadding: const EdgeInsets.symmetric(horizontal: 40),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 20),
          const Text(
            "Verify It's You",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Please enter your 6 digit PIN',
            style: TextStyle(color: Colors.black54, fontSize: 13),
          ),
          const SizedBox(height: 20),
          // Tapping the digit row focuses the hidden field to raise the keyboard.
          GestureDetector(
            onTap: () => _focusNode.requestFocus(),
            behavior: HitTestBehavior.opaque,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(6, (i) {
                final hasDigit = i < _pin.length;
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 8),
                  alignment: Alignment.center,
                  child: Text(
                    hasDigit ? _pin[i] : '-',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                      color: hasDigit ? Colors.black87 : Colors.black38,
                    ),
                  ),
                );
              }),
            ),
          ),
          // Off-screen field that captures numeric input.
          SizedBox(
            height: 0,
            width: 0,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              keyboardType: TextInputType.number,
              maxLength: 6,
              showCursor: false,
              autofocus: true,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: const InputDecoration(
                counterText: '',
                border: InputBorder.none,
              ),
              onChanged: (_) => setState(() {}),
            ),
          ),
          const SizedBox(height: 20),
          Divider(height: 1, color: Colors.grey.shade400),
          IntrinsicHeight(
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: complete ? () => widget.onSubmit(_pin) : null,
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: Text(
                        'Enter',
                        style: TextStyle(
                          color: complete ? Brand.spotify : Colors.grey,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                VerticalDivider(width: 1, color: Colors.grey.shade400),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      _controller.clear();
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 50,
                      alignment: Alignment.center,
                      child: const Text(
                        'Close',
                        style: TextStyle(
                          color: Colors.red,
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
