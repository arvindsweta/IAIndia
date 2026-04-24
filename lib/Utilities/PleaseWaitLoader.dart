import 'dart:async';
import 'package:flutter/material.dart';

class PleaseWaitLoader extends StatefulWidget {
  const PleaseWaitLoader({super.key});

  @override
  State<PleaseWaitLoader> createState() => _PleaseWaitLoaderState();
}

class _PleaseWaitLoaderState extends State<PleaseWaitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _dotCount = 1;
  Timer? _timer;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 1),
    )..repeat();

    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      setState(() {
        _dotCount = _dotCount == 3 ? 1 : _dotCount + 1;
      });
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.blueGrey.withOpacity(0.85), // background overlay
      color: Colors.transparent, // background overlay
      child: Center(
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: 60,
              width: 60,
              child: Stack(children: [
                Container(width: 55,height: 55,child: CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white70),
                  value: 1.0, // Static full gray circle
                ),),
                // Animated circular progress indicator
          Container(width: 55,height: 55,child:CircularProgressIndicator(
                  strokeWidth: 5,
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                ))
              ],)

              ,
            ),
            const SizedBox(height: 16),
            const Text(
              'Please wait...',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '•' * _dotCount,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 22,
                letterSpacing: 4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
