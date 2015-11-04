import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  true],
    [true,  true],
  ];

  Grid grid = new Grid(boolGrid);
  grid.diagonalMovement = DiagonalMovement.Never;

  AStarFinder aStarFinder = new AStarFinder(grid);

  var path = aStarFinder
    .pathFind(new PointNode(new Point(0, 0)), new PointNode(new Point(1, 1)));

  for (PointNode node in path) {
    print(node.location);
  }
}