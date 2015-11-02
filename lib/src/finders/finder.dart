part of path_finding;

abstract class Finder {
  final Graph graph;

  Finder(this.graph);

  List<Node> pathFind(Node start, Node goal);
}