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

  static Offset rotateAround(Offset pointA, Offset pivotB, double angle) {
    double angleRadian = -angle * (pi / 180);
    // Translate A relative to B
    final double translatedX = pointA.dx - pivotB.dx;
    final double translatedY = pointA.dy - pivotB.dy;

    // Perform rotation
    final double rotatedX =
        translatedX * cos(angleRadian) - translatedY * sin(angleRadian);

    final double rotatedY =
        translatedX * sin(angleRadian) + translatedY * cos(angleRadian);

    // Translate back to the original position relative to B
    final double finalX = rotatedX + pivotB.dx;
    final double finalY = rotatedY + pivotB.dy;

    var finalResult = Offset(finalX, finalY);
    return finalResult;
  }

  static Offset? findConicInflectionPoint(Offset p0, Offset p1, Offset p2, double w) {
    // Compute weighted control point
    double wx1 = w * p1.dx;
    double wy1 = w * p1.dy;

    // Inflection condition
    double dx = p2.dx - 2 * wx1 + p0.dx;
    double dy = p2.dy - 2 * wy1 + p0.dy;

    // If dx == 0 and dy == 0, no inflection exists
    if (dx.abs() < 1e-10 && dy.abs() < 1e-10) {
      return null; // No inflection point
    }

    // Parameter t for inflection
    double t = 0.5; // Inflection for quadratic conics typically occurs at t = 0.5

    // Compute coordinates at t = 0.5
    double denominator = (1 - t) * (1 - t) + 2 * w * (1 - t) * t + t * t;
    double x = ((1 - t) * (1 - t) * p0.dx + 2 * w * (1 - t) * t * p1.dx + t * t * p2.dx) / denominator;
    double y = ((1 - t) * (1 - t) * p0.dy + 2 * w * (1 - t) * t * p1.dy + t * t * p2.dy) / denominator;

    return Offset(x, y);
  }

  // /// p0 start, p2 end, Q is the reflection point
  // static Offset calculateControlPoint(Offset p0, Offset p2, Offset q) {
  //   double x1 = 2 * q.dx - 0.5 * p0.dx - 0.5 * p2.dx;
  //   double y1 = 2 * q.dy - 0.5 * p0.dy - 0.5 * p2.dy;
  //   // double x1 = q.dx - 0.5625 * p0.dx - 0.0625 * p2.dx;
  //   // double y1 = q.dy - 0.5625 * p0.dy - 0.0625 * p2.dy;
  //   return Offset(x1, y1);
  // }


  static Offset findPointRelativeToSegment(Offset a, Offset b, double ratio, double m) {
    // Tính tọa độ điểm C (nằm trên đoạn AB với tỷ lệ cho trước)
    var A = convert2OxyCoordinates(a);
    var B = convert2OxyCoordinates(b);
    double cx = A.dx + ratio * (B.dx - A.dx);
    double cy = A.dy + ratio * (B.dy - A.dy);
    Offset cPoint = Offset(cx, cy);

    // Vector pháp tuyến của đoạn AB
    double abx = B.dx - A.dx;
    double aby = B.dy - A.dy;
    double normalX = -aby;
    double normalY = abx;

    // Chuẩn hóa vector pháp tuyến
    double normalLength = sqrt(normalX * normalX + normalY * normalY);
    double unitNormalX = normalX / normalLength;
    double unitNormalY = normalY / normalLength;

    // Tính tọa độ điểm cách C một đoạn m theo vector pháp tuyến
    double offsetX = m * unitNormalX;
    double offsetY = m * unitNormalY;

    Offset pointAbove = Offset(cPoint.dx + offsetX, cPoint.dy + offsetY);
    Offset pointBelow = Offset(cPoint.dx - offsetX, cPoint.dy - offsetY);

    // Xác định điểm phía trên đoạn thẳng bằng điều kiện vector pháp tuyến hướng lên
    if (unitNormalY > 0) {
      return revert2DartCoordinates(pointAbove);
    } else {
      return revert2DartCoordinates(pointBelow);
    }
  }


  static Offset calculateConicPoint(double t, Offset p0, Offset p1, Offset p2, double weight) {
    double denominator = pow(1 - t, 2) + 2 * (1 - t) * t * weight + pow(t, 2);
    double x = ((pow(1 - t, 2) * p0.dx) +
        (2 * (1 - t) * t * weight * p1.dx) +
        (pow(t, 2) * p2.dx)) /
        denominator;
    double y = ((pow(1 - t, 2) * p0.dy) +
        (2 * (1 - t) * t * weight * p1.dy) +
        (pow(t, 2) * p2.dy)) /
        denominator;
    return Offset(x, y);
  }

  // Function to calculate the point on the conic curve for parameter t
  static Offset getPointOnConicCurve(double t, Offset start, Offset control, Offset end, double weight) {
    double numeratorX = (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * control.dx * weight +
        t * t * end.dx;

    double numeratorY = (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * control.dy * weight +
        t * t * end.dy;

    double denominator = (1 - t) * (1 - t) + 2 * (1 - t) * t * weight + t * t;

    double x = numeratorX / denominator;
    double y = numeratorY / denominator;

    return Offset(x, y);
  }

  static Offset getPointOnQuadraticCurve(double t, Offset start, Offset control, Offset end) {
    double x = (1 - t) * (1 - t) * start.dx +
        2 * (1 - t) * t * control.dx +
        t * t * end.dx;

    double y = (1 - t) * (1 - t) * start.dy +
        2 * (1 - t) * t * control.dy +
        t * t * end.dy;

    return Offset(x, y);
  }

// Solve the quadratic equation for t
  static List<double> solveQuadratic(double a, double b, double c) {
    double discriminant = b * b - 4 * a * c;

    if (discriminant < 0) {
      return []; // No real solutions
    }

    double sqrtDiscriminant = sqrt(discriminant);

    double t1 = (-b + sqrtDiscriminant) / (2 * a);
    double t2 = (-b - sqrtDiscriminant) / (2 * a);

    // Return valid t values (0 <= t <= 1)
    return [t1, t2].where((t) => t >= 0 && t <= 1).toList();
  }

// Calculate t for a given point on a quadratic Bézier curve
  static List<double> calculateTForPoint(
      Offset point, Offset start, Offset control, Offset end) {
    // Coefficients for x
    double ax = start.dx - 2 * control.dx + end.dx;
    double bx = 2 * (control.dx - start.dx);
    double cx = start.dx - point.dx;

    // Coefficients for y
    double ay = start.dy - 2 * control.dy + end.dy;
    double by = 2 * (control.dy - start.dy);
    double cy = start.dy - point.dy;

    // Solve the quadratic equations for x and y
    List<double> tX = solveQuadratic(ax, bx, cx);
    List<double> tY = solveQuadratic(ay, by, cy);

    // Find the common t values between x and y solutions
    return tX.where((t) => tY.contains(t)).toList();
  }

  static Offset calculateControlPoint(Offset a, Offset b, Offset c, double t_c) {
    double x1 = (c.dx - (1 - t_c) * (1 - t_c) * a.dx - t_c * t_c * b.dx) / (2 * t_c * (1 - t_c));
    double y1 = (c.dy - (1 - t_c) * (1 - t_c) * a.dy - t_c * t_c * b.dy) / (2 * t_c * (1 - t_c));
    return Offset(x1, y1);
  }

  static double mapValue(double value, double fromLow, double fromHigh, double toLow, double toHigh) {
    return toLow + (value - fromLow) * (toHigh - toLow) / (fromHigh - fromLow);
  }

  static bool isPointLeftOrRight(Offset a, Offset b, Offset p) {
    // Calculate the cross product
    double cross = (b.dx - a.dx) * (p.dy - a.dy) - (b.dy - a.dy) * (p.dx - a.dx);

    if (cross > 0) {
      return true; // Left of the line
    } else if (cross < 0) {
      return false; // Right of the line
    } else {
      return false;
    }
  }

}

class Point {
  final double x, y;

  Point(this.x, this.y);
}