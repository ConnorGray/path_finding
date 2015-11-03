part of path_finding;

/// A collection of heuristic functions used by a Finder.
class Heuristic {
  /// Returns the manhattan (taxicab) distance between [p1] and [p2].
  static double manhattan(Point p1, Point p2) {
    double deltaX = (p2.x - p1.x).toDouble().abs();
    double deltaY = (p2.y - p1.y).toDouble().abs();

    return deltaX + deltaY;
  }

  /// Returns the euclidean distance between [p1] and [p2].
  static double euclidean(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }
}