part of path_finding;

class PointNode extends Node {
  /// The location of this node on the 2 dimentional cartesian plane.
  final Point location;

  String toString() => '[$walkable $location]';

  PointNode(this.location, {bool walkable: true}) : super(walkable);

  bool operator ==(PointNode other) => this.location == other.location;
  int get hashCode => this.location.hashCode;
}