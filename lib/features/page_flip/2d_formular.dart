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
    // Check if the line is vertical
    if (p1.dx == p2.dx) {
      // The vertical line intersects the x-axis at (p1.dx, 0)
      return Offset(p1.dx, 0);
    }

    // Calculate slope and y-intercept
    final double m = (p2.dy - p1.dy) / (p2.dx - p1.dx);
    final double c = p1.dy - m * p1.dx;

    // Calculate the intersection with the x-axis
    final double x = -c / m;

    return Offset(x, 0);
  }

  static Offset? findIntersectionWithHorizontalLine(Offset p1, Offset p2, double M) {
    // Check if the line is vertical (parallel to the y-axis)
    if (p1.dx == p2.dx) {
      return Offset(p1.dx, M);
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

  /// Hàm tìm điểm đối xứng của [point] qua đường thẳng xác định bởi [linePoint1] và [linePoint2].
  static Offset findSymmetricPoint(
      Offset point, Offset linePoint1, Offset linePoint2) {
    // Tọa độ của đường thẳng
    double x1 = linePoint1.dx, y1 = linePoint1.dy;
    double x2 = linePoint2.dx, y2 = linePoint2.dy;
    double px = point.dx, py = point.dy;

    // Tính hệ số A, B, C của đường thẳng Ax + By + C = 0
    double A = y2 - y1;
    double B = x1 - x2;
    double C = x2 * y1 - x1 * y2;

    // Tính điểm đối xứng
    double denominator = A * A + B * B;
    double xSymmetric = px - 2 * A * (A * px + B * py + C) / denominator;
    double ySymmetric = py - 2 * B * (A * px + B * py + C) / denominator;

    return Offset(xSymmetric, ySymmetric);
  }

  static Offset? twoLineIntersection(Offset p1, Offset p2, Offset p3, Offset p4) {
    double denominator = (p1.dx - p2.dx) * (p3.dy - p4.dy) - (p1.dy - p2.dy) * (p3.dx - p4.dx);

    // If denominator is zero, the lines are parallel or coincident
    if (denominator == 0) {
      return null; // No intersection
    }

    double t = ((p1.dx - p3.dx) * (p3.dy - p4.dy) - (p1.dy - p3.dy) * (p3.dx - p4.dx)) / denominator;
    double u = ((p1.dx - p3.dx) * (p1.dy - p2.dy) - (p1.dy - p3.dy) * (p1.dx - p2.dx)) / denominator;

    // If 0 <= t <= 1 and 0 <= u <= 1, the intersection point is on both line segments
    if (t >= 0 && t <= 1 && u >= 0 && u <= 1) {
      double dx = p1.dx + t * (p2.dx - p1.dx);
      double dy = p1.dy + t * (p2.dy - p1.dy);
      return Offset(dx, dy);
    }

    return null; // The intersection is outside the line segments
  }
  static Offset convert2OxyCoordinates(Offset offset) {
      return Offset(offset.dx, -offset.dy);
  }

  static Offset revert2DartCoordinates(Offset offset) {
    return Offset(offset.dx, -offset.dy);
  }



  static Offset? findPointOnPerpendicularBisector(Offset a, Offset b, double distance, bool below) {
    // Tính trung điểm M của AB
    double midX = (a.dx + b.dx) / 2;
    double midY = (a.dy + b.dy) / 2;
    Offset midPoint = Offset(midX, midY);

    // Tính vector vuông góc với AB (AB vuông góc với -dy, dx)
    double dx = b.dx - a.dx;
    double dy = b.dy - a.dy;

    // Vector vuông góc (dx, dy) -> (-dy, dx)
    double perpX = -dy;
    double perpY = dx;

    // Độ dài vector vuông góc
    double perpLength = sqrt(perpX * perpX + perpY * perpY);

    // Đơn vị hóa vector vuông góc
    double unitPerpX = perpX / perpLength;
    double unitPerpY = perpY / perpLength;

    // Tính hai điểm trên đường trung trực cách M một đoạn distance
    Offset p1 = Offset(midPoint.dx + unitPerpX * distance, midPoint.dy + unitPerpY * distance);
    Offset p2 = Offset(midPoint.dx - unitPerpX * distance, midPoint.dy - unitPerpY * distance);

    // Chỉ lấy điểm nằm dưới đường thẳng AB (y < midY)
    if (below) {
      return p1;
    } else {
      return p2;
    }
  }
}

class Point {
  final double x, y;

  Point(this.x, this.y);
}