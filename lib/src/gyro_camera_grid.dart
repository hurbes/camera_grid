import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'camera_grid_painter.dart';
import 'utils/gyro_math.dart';

class CameraGrid extends StatelessWidget {
  final Widget? child;
  final Color gridColor;
  final Color accentColor;
  final double gridLineWidth;
  final double movingBorderRadius;
  final Duration morphDuration;
  final Curve morphCurve;
  final double snapThreshold;
  final bool isGridEnabled;

  const CameraGrid({
    super.key,
    this.child,
    this.gridColor = Colors.white,
    this.accentColor = Colors.blue,
    this.gridLineWidth = 1.0,
    this.movingBorderRadius = 4.0,
    this.morphDuration = const Duration(milliseconds: 150),
    this.morphCurve = Curves.easeOutQuad,
    this.snapThreshold = 1.5 * pi / 180, // 1.5 degrees in radians
    this.isGridEnabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final childParam = child ?? const SizedBox.shrink();
    return switch (isGridEnabled) {
      true => _ActiveGyroCameraGrid(
          gridColor: gridColor,
          accentColor: accentColor,
          gridLineWidth: gridLineWidth,
          movingBorderRadius: movingBorderRadius,
          morphDuration: morphDuration,
          morphCurve: morphCurve,
          snapThreshold: snapThreshold,
          child: childParam,
        ),
      false => childParam
    };
  }
}

class _ActiveGyroCameraGrid extends StatefulWidget {
  final Widget child;
  final Color gridColor;
  final Color accentColor;
  final double gridLineWidth;
  final double movingBorderRadius;
  final Duration morphDuration;
  final Curve morphCurve;
  final double snapThreshold;

  const _ActiveGyroCameraGrid({
    required this.child,
    required this.gridColor,
    required this.accentColor,
    required this.gridLineWidth,
    required this.movingBorderRadius,
    required this.morphDuration,
    required this.morphCurve,
    required this.snapThreshold,
  });

  @override
  _ActiveGyroCameraGridState createState() => _ActiveGyroCameraGridState();
}

class _ActiveGyroCameraGridState extends State<_ActiveGyroCameraGrid>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _morphAnimation;
  StreamSubscription<AccelerometerEvent>? _accelSubscription;

  double _rotationAngle = 0.0;
  bool _isLandscape = false;
  bool _isSnapped = false;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAccelerometerListener();
  }

  void _initializeAnimations() {
    _animationController = AnimationController(
      duration: widget.morphDuration,
      vsync: this,
    );
    _morphAnimation = CurvedAnimation(
      parent: _animationController,
      curve: widget.morphCurve,
    );
  }

  void _startAccelerometerListener() {
    _accelSubscription = accelerometerEventStream(
      samplingPeriod: const Duration(milliseconds: 30),
    ).listen(_updateOrientation);
  }

  void _updateOrientation(AccelerometerEvent event) {
    double newRotationAngle =
        GyroMath.calculateRotationAngle(_rotationAngle, event.x, event.y);
    bool newIsLandscape = GyroMath.isLandscape(event.x, event.y);
    bool newIsSnapped =
        GyroMath.isSnapped(newRotationAngle, widget.snapThreshold);

    setState(() {
      _rotationAngle = newRotationAngle;
      if (newIsLandscape != _isLandscape) {
        _isLandscape = newIsLandscape;
        _isLandscape
            ? _animationController.forward()
            : _animationController.reverse();
      }
      _isSnapped = newIsSnapped;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _accelSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        RepaintBoundary(
          child: IgnorePointer(
            child: CustomPaint(
              painter: CameraGridPainter(
                rotationAngle: _rotationAngle,
                morphProgress: _morphAnimation.value,
                gridColor: widget.gridColor.withOpacity(0.5),
                accentColor: widget.accentColor,
                gridLineWidth: widget.gridLineWidth,
                movingBorderRadius: widget.movingBorderRadius,
                isSnapped: _isSnapped,
                snapThreshold: widget.snapThreshold,
              ),
              size: Size.infinite,
            ),
          ),
        ),
        widget.child,
      ],
    );
  }
}
