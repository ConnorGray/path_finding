part of path_finding;

class Node {
  /// Whether or not a path can go through this node.
  bool walkable;

  /// Temporary value used by the Finder's.
  ///
  /// Used by:
  ///   - A*
  ///   - Dijkstra
  double _f;

  /// Temporary value used by the Finder's.
  ///
  /// Used by:
  ///   - A*
  double _g;

  Node(this.walkable);
}