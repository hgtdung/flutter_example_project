import 'dart:math';

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
}