part of path_finding;

abstract class Graph {
  List<Node> getNeighbors(Node node, {bool onlyWalkable: true});

  double distance(Node n1, Node n2);

  bool containsPoint(Point point);
  bool containsNode(Node node);

  Node nodeFromPoint(Point point);

  List<Node> get allNodes;
}