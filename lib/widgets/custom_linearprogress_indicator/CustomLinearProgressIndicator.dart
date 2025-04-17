import 'package:flutter/material.dart';

class CustomLinearProgressBar extends StatefulWidget {
  final ValueNotifier<Map<String,dynamic>> progress;

  const CustomLinearProgressBar({Key? key, required this.progress}) : super(key: key);

  @override
  State<CustomLinearProgressBar> createState() => _CustomLinearProgressBarState();
}

class _CustomLinearProgressBarState extends State<CustomLinearProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Color?> _colorAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _colorAnimation = TweenSequence<Color?>([
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.blue, end: Colors.green),
        weight: 1,
      ),
      TweenSequenceItem(
        tween: ColorTween(begin: Colors.green, end: Colors.blue),
        weight: 1,
      ),
    ]).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Map<String,dynamic>>(
      valueListenable: widget.progress,
      builder: (context,value,child) {
        if(value.containsKey('progress') && value['progress']==1.0){
          _controller.stop();
        }
        return  Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            AnimatedBuilder(
              animation: _colorAnimation,
              builder: (context, child) {
                return LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(20),
                  minHeight: 12,
                  value: widget.progress.value['progress'],
                  valueColor: AlwaysStoppedAnimation<Color?>(_colorAnimation.value),
                  backgroundColor: Colors.grey.shade300,
                );
              },
            ),
            if(widget.progress.value.containsKey('message') )...[
              const SizedBox(height: 8.0,),
              Text(widget.progress.value['message']),
            ]
          ],
        );
      },
    );
  }

}
