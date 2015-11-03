part of path_finding;

/// Root class that all path finding algorithm implementations must subclass.
abstract class Finder {
  /// The [Graph] that this Finder is path finding through.
  final Graph graph;

  Finder(this.graph);

  /// Returns a list of points that make up a continuous path
  /// between the [start] and [goal] nodes in [this.graph].
  ///
  /// Every point on the returned path was a walkable [Node] of [this.graph].
  List<Point> pathFind(Point start, Point goal);
}