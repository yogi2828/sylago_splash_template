import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen5 extends StatefulWidget {
  @override
  _SplashScreen5State createState() => _SplashScreen5State();
}

class _SplashScreen5State extends State<SplashScreen5>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final List<Bird> _birds = [];
  final List<Cloud> _clouds = [];

  @override
  void initState() {
    super.initState();

    // Generate random birds
    for (int i = 0; i < 5; i++) {
      _birds.add(Bird(
        position: Offset(
          -50.0 - (i * 30),
          100 + math.Random().nextDouble() * 100,
        ),
        speed: 1.0 + math.Random().nextDouble(),
      ));
    }

    // Generate clouds
    for (int i = 0; i < 3; i++) {
      _clouds.add(Cloud(
        position: Offset(
          -100.0 - (i * 200),
          50 + math.Random().nextDouble() * 100,
        ),
        speed: 0.2 + math.Random().nextDouble() * 0.3,
      ));
    }

    _controller = AnimationController(
      duration: const Duration(milliseconds: 3000),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Interval(0.2, 0.8, curve: Curves.easeIn),
    ));

    _controller.forward();

    Timer(
      Duration(seconds: 4),
      () => Navigator.pop(context),
    );

    // Start animation loop
    Timer.periodic(Duration(milliseconds: 16), (timer) {
      if (mounted) {
        setState(() {
          // Update birds position
          for (var bird in _birds) {
            bird.position = Offset(
              bird.position.dx + bird.speed,
              bird.position.dy + math.sin(bird.position.dx * 0.05) * 0.5,
            );

            // Reset bird position when it goes off screen
            if (bird.position.dx > MediaQuery.of(context).size.width + 50) {
              bird.position =
                  Offset(-50, 100 + math.Random().nextDouble() * 100);
            }
          }

          // Update clouds position
          for (var cloud in _clouds) {
            cloud.position = Offset(
              cloud.position.dx + cloud.speed,
              cloud.position.dy,
            );

            // Reset cloud position when it goes off screen
            if (cloud.position.dx > MediaQuery.of(context).size.width + 200) {
              cloud.position =
                  Offset(-200, 50 + math.Random().nextDouble() * 100);
            }
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Mountain background
          Image.asset(
            'assets/images/mountains.jpg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Animated clouds
          ...List.generate(
            _clouds.length,
            (index) => Positioned(
              left: _clouds[index].position.dx,
              top: _clouds[index].position.dy,
              child: Opacity(
                opacity: 0.8,
                child: Icon(
                  Icons.cloud,
                  size: 100,
                  color: Colors.white,
                ),
              ),
            ),
          ),

          // Animated birds
          ...List.generate(
            _birds.length,
            (index) => Positioned(
              left: _birds[index].position.dx,
              top: _birds[index].position.dy,
              child: Transform.scale(
                scale: 0.8,
                child: Icon(
                  Icons.flight,
                  color: Colors.black54,
                ),
              ),
            ),
          ),

          // Gradient overlay
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.3),
                  Colors.transparent,
                  Colors.black.withOpacity(0.5),
                ],
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Logo
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 0.5),
                      end: Offset.zero,
                    ).animate(_controller),
                    child: Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 20,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.landscape,
                        size: 60,
                        color: Colors.green[700],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                // App name
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: Tween<Offset>(
                      begin: Offset(0, 1),
                      end: Offset.zero,
                    ).animate(_controller),
                    child: Text(
                      'NATURIFY',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 8,
                        shadows: [
                          Shadow(
                            color: Colors.black54,
                            blurRadius: 10,
                            offset: Offset(2, 2),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                // Tagline
                FadeTransition(
                  opacity: _fadeAnimation,
                  child: Text(
                    'Connect with Nature',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      letterSpacing: 2,
                      shadows: [
                        Shadow(
                          color: Colors.black54,
                          blurRadius: 5,
                          offset: Offset(1, 1),
                        ),
                      ],
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

class Bird {
  Offset position;
  final double speed;

  Bird({
    required this.position,
    required this.speed,
  });
}

class Cloud {
  Offset position;
  final double speed;

  Cloud({
    required this.position,
    required this.speed,
  });
}
