import 'dart:math';
import 'dart:ui';

class ConicBezier {
  final Offset start;
  final Offset control;
  final Offset end;
  final double weight;

  ConicBezier(this.start, this.control, this.end, this.weight);

  // Check if the curve intersects the line formed by two points
  bool intersectsLine(Offset lineStart, Offset lineEnd) {
    // Line equation coefficients: ax + by + c = 0
    double a = lineEnd.dy - lineStart.dy; // y2 - y1
    double b = lineStart.dx - lineEnd.dx; // x1 - x2
    double c = lineEnd.dx * lineStart.dy - lineStart.dx * lineEnd.dy;

    // Coefficients for the quadratic equation
    double x0 = start.dx, y0 = start.dy;
    double x1 = control.dx, y1 = control.dy;
    double x2 = end.dx, y2 = end.dy;

    double A = a * (x0 - 2 * weight * x1 + x2) + b * (y0 - 2 * weight * y1 + y2);
    double B = 2 * a * (weight * (x1 - x0) + x0 - x2) +
        2 * b * (weight * (y1 - y0) + y0 - y2) +
        2 * c * (weight - 1);
    double C = a * x0 + b * y0 + c;

    // Solve the quadratic equation At^2 + Bt + C = 0
    double discriminant = B * B - 4 * A * C;
    print("discriminant $discriminant");
    if (discriminant < 0) {
      return false; // No intersection
    }

    // Roots of the quadratic equation
    double sqrtDiscriminant = sqrt(discriminant);
    double t1 = (-B + sqrtDiscriminant) / (2 * A);
    double t2 = (-B - sqrtDiscriminant) / (2 * A);

    // Check if any root is in the range [0, 1]
    bool validT1 = t1 >= 0 && t1 <= 1;
    bool validT2 = t2 >= 0 && t2 <= 1;

    return validT1 || validT2;
  }
}
