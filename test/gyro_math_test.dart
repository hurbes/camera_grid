import 'dart:math' show pi;

import 'package:camera_grid/src/utils/gyro_math.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('GyroMath', () {
    group('calculateRotationAngle', () {
      test('should apply smoothing factor correctly', () {
        double currentAngle = 0;
        double newAngle = GyroMath.calculateRotationAngle(currentAngle, 1, 0);
        expect(newAngle, closeTo(-pi / 2 * 0.1, 1e-6));
      });

      test('should handle different quadrants correctly', () {
        expect(GyroMath.calculateRotationAngle(0, 1, 1),
            closeTo(-pi / 4 * 0.1, 1e-6));
        expect(GyroMath.calculateRotationAngle(0, -1, 1),
            closeTo(pi / 4 * 0.1, 1e-6));
        expect(GyroMath.calculateRotationAngle(0, -1, -1),
            closeTo(3 * pi / 4 * 0.1, 1e-6));
        expect(GyroMath.calculateRotationAngle(0, 1, -1),
            closeTo(-3 * pi / 4 * 0.1, 1e-6));
      });

      test('should handle zero input correctly', () {
        expect(GyroMath.calculateRotationAngle(0, 0, 0), 0);
      });
    });

    group('isLandscape', () {
      test('should return true when |x| > |y|', () {
        expect(GyroMath.isLandscape(2, 1), true);
        expect(GyroMath.isLandscape(-2, 1), true);
        expect(GyroMath.isLandscape(1.1, 1), true);
      });

      test('should return false when |x| <= |y|', () {
        expect(GyroMath.isLandscape(1, 2), false);
        expect(GyroMath.isLandscape(1, -2), false);
        expect(GyroMath.isLandscape(1, 1), false);
      });

      test('should handle zero input correctly', () {
        expect(GyroMath.isLandscape(0, 0), false);
      });
    });

    group('isSnapped', () {
      test('should return true when angle is within threshold', () {
        expect(GyroMath.isSnapped(0, 0.1), true);
        expect(GyroMath.isSnapped(pi / 2, 0.1), true);
        expect(GyroMath.isSnapped(pi, 0.1), true);
        expect(GyroMath.isSnapped(3 * pi / 2, 0.1), true);
        expect(GyroMath.isSnapped(2 * pi - 0.05, 0.1),
            true); // Close to 0/360 degrees
      });

      test('should return false when angle is outside threshold', () {
        expect(GyroMath.isSnapped(0.2, 0.1), false);
        expect(GyroMath.isSnapped(pi / 4, 0.1), false);
        expect(GyroMath.isSnapped(2 * pi / 3, 0.1), false);
      });

      test('should handle edge cases', () {
        expect(GyroMath.isSnapped(0, 0), true);
        expect(GyroMath.isSnapped(pi / 2, pi / 2), true);
        expect(GyroMath.isSnapped(pi, pi), true);
        expect(GyroMath.isSnapped(2 * pi, pi), true);
      });

      test('should handle angles close to 2π', () {
        expect(GyroMath.isSnapped(2 * pi - 0.01, 0.1), true);
        expect(GyroMath.isSnapped(2 * pi + 0.01, 0.1), true);
      });
    });

    group('normalizeAngle', () {
      test('should keep angle between 0 and 2π', () {
        expect(GyroMath.normalizeAngle(0), 0);
        expect(GyroMath.normalizeAngle(pi), closeTo(pi, 1e-10));
        expect(GyroMath.normalizeAngle(2 * pi), closeTo(0, 1e-10));
        expect(GyroMath.normalizeAngle(3 * pi), closeTo(pi, 1e-10));
      });

      test('should handle negative angles', () {
        expect(GyroMath.normalizeAngle(-pi / 2), closeTo(3 * pi / 2, 1e-10));
        expect(GyroMath.normalizeAngle(-pi), closeTo(pi, 1e-10));
        expect(GyroMath.normalizeAngle(-2 * pi), closeTo(0, 1e-10));
      });

      test('should handle large angles', () {
        expect(GyroMath.normalizeAngle(10 * pi), closeTo(0, 1e-10));
        expect(GyroMath.normalizeAngle(101 * pi), closeTo(pi, 1e-10));
      });
    });
  });
}
