import 'dart:math';
import 'dart:ui';

class TwoDFormula {
  static double angleBetweenLines(
      double x1, double y1, double x2, double y2,
      double x3, double y3, double x4, double y4) {
    // Calculate direction vectors
    double ux = x2 - x1;
    double uy = y2 - y1;
    double vx = x4 - x3;
    double vy = y4 - y3;

    // Compute dot product
    double dotProduct = ux * vx + uy * vy;

    // Compute magnitudes
    double magnitudeU = sqrt(ux * ux + uy * uy);
    double magnitudeV = sqrt(vx * vx + vy * vy);

    // Handle edge case of zero-length vectors (degenerate lines)
    if (magnitudeU == 0 || magnitudeV == 0) {
      throw ArgumentError("One of the lines has zero length.");
    }

    // Calculate the angle in radians
    double cosTheta = dotProduct / (magnitudeU * magnitudeV);

    // Clamp cosTheta to the range [-1, 1] to avoid precision issues
    cosTheta = cosTheta.clamp(-1, 1);

    // Return the angle in degrees
    return acos(cosTheta) * (180 / pi);
  }

  static Offset? findIntersectionWithOX(Offset p1, Offset p2) {
    if (p1.dx == p2.dx) {
      return null;
    }

    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    final double c = p1.dy - m * p1.dx;

    final double x = -c / m;

    return Offset(x, 0);
  }

  static Offset? findIntersectionWithHorizontalLine(Offset p1, Offset p2, double M) {
    // Check if the line is vertical (parallel to the y-axis)
    if (p1.dx == p2.dx) {
      return null; // No intersection with horizontal line, because the line is vertical
    }

    // Calculate the slope (m) of the line
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);

    // Calculate the y-intercept (c) using one of the points
    final double c = p1.dy - m * p1.dx;

    // Find the x-coordinate where the line intersects the horizontal line y = M
    final double x = (M - c) / m;

    // Return the intersection point as an Offset (x, M)
    return Offset(x, M);
  }

  static Offset? findIntersectionWithVerticalLine(Offset p1, Offset p2, double V) {
    // Check if the line is vertical (parallel to the y-axis)
    if (p1.dx == p2.dx) {
      return null; // No intersection with vertical line, because the line is vertical
    }

    // Calculate the slope (m) of the line
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);

    // Calculate the y-intercept (c) using one of the points
    final double c = p1.dy - m * p1.dx;

    // Find the y-coordinate where the line intersects the vertical line x = V
    final double y = m * V + c;

    // Return the intersection point as an Offset (V, y)
    return Offset(V, y);
  }

  static Offset? findIntersectionWithOY(Offset p1, Offset p2) {
    // Check if the line is vertical
    if (p1.dx == p2.dx) {
      return null; // No intersection with OY (vertical line)
    }

    // Calculate slope (m) and intercept (c)
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    final double c = p1.dy - m * p1.dx;

    // Intersection with OY occurs at x = 0
    return Offset(0, c);
  }
}