import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen4 extends StatefulWidget {
  @override
  _SplashScreen4State createState() => _SplashScreen4State();
}

class _SplashScreen4State extends State<SplashScreen4>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _pulseAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  final List<CircuitLine> _circuitLines = [];

  @override
  void initState() {
    super.initState();

    // Generate random circuit lines
    for (int i = 0; i < 15; i++) {
      _circuitLines.add(CircuitLine(
        start: Offset(
          math.Random().nextDouble() * 400 - 200,
          math.Random().nextDouble() * 400 - 200,
        ),
        angle: math.Random().nextDouble() * 2 * math.pi,
        length: 50 + math.Random().nextDouble() * 100,
      ));
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.4, 1.0, curve: Curves.easeIn),
    ));

    _scaleAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    ));

    _controller.repeat(reverse: true);

    Timer(
      Duration(seconds: 3),
      () => Navigator.pop(context),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF0A0E21),
      body: Stack(
        children: [
          // Circuit pattern background
          ...List.generate(
            _circuitLines.length,
            (index) => Positioned(
              left: MediaQuery.of(context).size.width / 2 +
                  _circuitLines[index].start.dx,
              top: MediaQuery.of(context).size.height / 2 +
                  _circuitLines[index].start.dy,
              child: Transform.rotate(
                angle: _circuitLines[index].angle,
                child: AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: _circuitLines[index].length,
                      height: 2,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Colors.blue.withOpacity(0),
                            Colors.blue
                                .withOpacity(0.5 * _pulseAnimation.value),
                            Colors.blue.withOpacity(0),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated logo
                AnimatedBuilder(
                  animation: _controller,
                  builder: (context, child) {
                    return Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.blue
                                .withOpacity(0.3 * _pulseAnimation.value),
                            blurRadius: 30,
                            spreadRadius: 10,
                          ),
                        ],
                      ),
                      child: ScaleTransition(
                        scale: _scaleAnimation,
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.blue[400]!,
                                Colors.purple[500]!,
                              ],
                            ),
                          ),
                          child: Icon(
                            Icons.computer,
                            size: 80,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                SizedBox(height: 40),
                // Animated text
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Column(
                    children: [
                      Text(
                        'TECHNO',
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Orbitron',
                          letterSpacing: 8,
                          shadows: [
                            Shadow(
                              color: Colors.blue.withOpacity(0.5),
                              blurRadius: 10,
                              offset: Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 10),
                      Text(
                        'FUTURE IS NOW',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.blue[200],
                          letterSpacing: 4,
                          fontWeight: FontWeight.w300,
                        ),
                      ),
                    ],
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

class CircuitLine {
  final Offset start;
  final double angle;
  final double length;

  CircuitLine({
    required this.start,
    required this.angle,
    required this.length,
  });
}
