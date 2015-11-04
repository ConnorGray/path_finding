part of path_finding;

class Node {
  /// The location of this node on the 2 dimentional cartesian plane.
  final Point location;

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

  bool _isInOpenSet = false;
  bool _isInClosedSet = false;

  String toString() => '[$walkable $location]';

  Node(this.location);

  bool operator ==(Node other) => this.location == other.location;
}