part of path_finding;

/// Root class that all graphs must subclass in order to work with a [Finder].
abstract class Graph {
  /// Return a list of nodes that are the neighbors of `node`.
  List<Node> getNeighbors(Node node, {bool onlyWalkable: true});

  /// Returns the distance between [n1] and [n2].
  ///
  /// Distance is determined by each implementation of Graph,
  /// and is not guranteed to be the euclidean distance between [n1] and [n2].
  double distance(Node n1, Node n2);

  /// Returns whether or not there is a note in this Graph located at [point].
  bool containsPoint(Point point);
  /// Returns whether or not the [Node node] is a member of this [Graph].
  bool containsNode(Node node);

  /// Returns the node of this graph found at [point].
  ///
  /// Throws [ArgumentError] if there is no Node located at [point].
  Node nodeFromPoint(Point point);

  /// Returns a list of all the nodes that are part of this [Graph].
  List<Node> get allNodes;
}