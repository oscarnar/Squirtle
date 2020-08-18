class Point {
  double py = 0;
  double px = 0;
  Point(this.px, this.py);
}

int close(Point actual, List<Point> points) {
    int bestPoint = 0;
    double bestDistance = double.infinity;
    for (int i = 0; i < points.length; i++) {
      double x = points[i].px - actual.px;
      double y = points[i].py - actual.py;
      double distance = x.abs() + y.abs();
      if (distance < bestDistance) {
        bestDistance = distance;
        bestPoint = i;
      }
    }
    return bestPoint;
  }