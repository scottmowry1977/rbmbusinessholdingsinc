import 'package:flutter/material.dart';

class RbmLoadingIndicator extends StatefulWidget {
  final double size;
  const RbmLoadingIndicator({super.key, this.size = 50.0});

  @override
  State<RbmLoadingIndicator> createState() => _RbmLoadingIndicatorState();
}

class _RbmLoadingIndicatorState extends State<RbmLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: FadeTransition(
        opacity: _animation,
        child: ScaleTransition(
          scale: _animation,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFFC99700), // Notre Dame Gold
                    width: 3,
                  ),
                ),
                child: const Center(
                  child: Text(
                    'RBM',
                    style: TextStyle(
                      color: Color(0xFFC99700),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Loading Insights...',
                style: TextStyle(
                  color: Color(0xFFC99700),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 1.1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
