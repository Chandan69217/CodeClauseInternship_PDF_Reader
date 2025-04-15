import 'package:flutter/material.dart';
import 'package:pdf_reader/external_storage/read_storage.dart';
import 'package:pdf_reader/utilities/color_theme.dart';

class AnimatedFAB extends StatefulWidget {
  const AnimatedFAB({super.key});

  @override
  State<AnimatedFAB> createState() => _AnimatedFABState();
}

class _AnimatedFABState extends State<AnimatedFAB> {
  bool _isLoading = false;

  void _onPressed() async {
    setState(() => _isLoading = true);
    await Read.instance.scanForAllFiles();
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: _isLoading ? null : _onPressed,
      backgroundColor: Colors.deepPurpleAccent,
      shape: const CircleBorder(),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        transitionBuilder: (child, animation) =>
            ScaleTransition(scale: animation, child: child),
        child: _isLoading
            ? const SizedBox(
          key: ValueKey('loader'),
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            strokeWidth: 3,
          ),
        )
            : Icon(Icons.sync, key: ValueKey('icon'),color: ColorTheme.WHITE,),
      ),
    );
  }
}
