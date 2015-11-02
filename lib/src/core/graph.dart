part of path_finding;

abstract class Graph {
  List<Node> getNeighbors(Node node);

  double distance(Node n1, Node n2);

  bool containsPoint(Point point);
  bool containsNode(Node node);

  List<Node> get allNodes;
}