import 'dart:math' show pi, atan2;

class GyroMath {
  static const double _smoothingFactor = 0.1;

  static double calculateRotationAngle(
      double currentAngle, double x, double y) {
    double newRotationAngle = atan2(-x, y);
    return currentAngle * (1 - _smoothingFactor) +
        newRotationAngle * _smoothingFactor;
  }

  static bool isLandscape(double x, double y) {
    return x.abs() > y.abs();
  }

  static bool isSnapped(double rotationAngle, double snapThreshold) {
    if (snapThreshold == 0) return true; // Always snapped if threshold is 0
    double normalizedAngle = normalizeAngle(rotationAngle);
    return [0, pi / 2, pi, 3 * pi / 2].any((snapAngle) =>
        (normalizedAngle - snapAngle).abs() < snapThreshold ||
        (2 * pi - (normalizedAngle - snapAngle).abs()) < snapThreshold);
  }

  static double normalizeAngle(double angle) {
    return (angle % (2 * pi) + 2 * pi) % (2 * pi);
  }
}
