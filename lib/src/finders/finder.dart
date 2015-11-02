part of path_finding;

abstract class Finder {
  final Graph graph;

  Finder(this.graph);

  List<Point> pathFind(Point start, Point goal);
}