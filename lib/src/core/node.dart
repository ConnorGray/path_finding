part of path_finding;

class Node {
  final Point location;

  bool walkable;

  // Used by:
  //   - A*
  //   - Dijkstra
  double f;

  // Used by:
  //   - A*
  double g;

  String toString() => '[$walkable $location]';

  Node(this.location);

  bool operator ==(Node other) => this.location == other.location;
}