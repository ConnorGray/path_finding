part of path_finding;

class Node {
  final Point location;

  bool walkable;
  double f;
  double g;

  String toString() => '[$walkable $location]';

  Node(this.location);

  bool operator ==(Node other) => this.location == other.location;
}