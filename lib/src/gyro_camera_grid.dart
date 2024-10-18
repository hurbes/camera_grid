import 'dart:async';
import 'dart:math' show pi;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';
import 'camera_grid_painter.dart';
import 'utils/gyro_math.dart';

class CameraGrid extends StatefulWidget {
  final Widget child;
  final Color gridColor;
  final Color accentColor;
  final double gridLineWidth;
  final double movingBorderRadius;
  final Duration morphDuration;
  final Curve morphCurve;
  final double snapThreshold;

  const CameraGrid({
    super.key,
    required this.child,
    this.gridColor = Colors.white,
    this.accentColor = Colors.blue,
    this.gridLineWidth = 1.0,
    this.movingBorderRadius = 4.0,
    this.morphDuration = const Duration(milliseconds: 150),
    this.morphCurve = Curves.easeOutQuad,
    this.snapThreshold = 1.5 * pi / 180, // 1.5 degrees in radians
  });

  @override
  _GyroCameraGridState createState() => _GyroCameraGridState();
}

class _GyroCameraGridState extends State<CameraGrid>
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
      children: [
        RepaintBoundary(
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
        widget.child,
      ],
    );
  }
}
