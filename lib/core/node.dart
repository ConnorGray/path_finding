part of path_finding;

class Node {
  final bool walkable;
  Point location;

  double f;
  double g;

  String toString() => '[$walkable $location]';

  Node(this.walkable, this.location);

  bool operator ==(Node other) {
    if (this.walkable != other.walkable) {
      return false;
    }
    if (this.location != other.location) {
      return false;
    }

    return true;
  }
}