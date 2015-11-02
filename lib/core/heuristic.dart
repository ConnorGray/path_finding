part of path_finding;

class Heuristic {
  static double manhattan(Point p1, Point p2) {
    double deltaX = (p2.x - p1.x).toDouble().abs();
    double deltaY = (p2.y - p1.y).toDouble().abs();

    return deltaX + deltaY;
  }

  static double euclidean(Point p1, Point p2) {
    return sqrt(pow(p2.x - p1.x, 2) + pow(p2.y - p1.y, 2));
  }
}