import 'package:flutter/material.dart';
import 'dart:math';

class ModernOrbitLoader extends StatefulWidget {
  final double size;
  final Color color;
  final Duration duration;

  const ModernOrbitLoader({
    Key? key,
    this.size = 80.0,
    this.color = Colors.blueAccent,
    this.duration = const Duration(seconds: 2),
  }) : super(key: key);

  @override
  _ModernOrbitLoaderState createState() => _ModernOrbitLoaderState();
}

class _ModernOrbitLoaderState extends State<ModernOrbitLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: widget.duration)..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(double angle, double radius, double size) {
    final offset = Offset(
      radius * cos(angle),
      radius * sin(angle),
    );

    return Transform.translate(
      offset: offset,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: widget.color,
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double radius = widget.size / 2.5;
    final double dotSize = widget.size / 8;

    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          final double angle = _controller.value * 2 * pi;
          return Stack(
            alignment: Alignment.center,
            children: [
              _buildDot(angle, radius, dotSize),
              _buildDot(angle + pi / 2, radius, dotSize * 0.8),
              _buildDot(angle + pi, radius, dotSize * 0.6),
              _buildDot(angle + 3 * pi / 2, radius, dotSize * 0.4),
            ],
          );
        },
      ),
    );
  }
}
