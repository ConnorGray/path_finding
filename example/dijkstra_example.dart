import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  false, false, true],
    [true,  true,  false, true],
    [false, true,  true,  true]
  ];

  Grid grid = new Grid(boolGrid);
  grid.diagonalMovement = DiagonalMovement.Never;

  PointNode start = grid.nodeFromPoint(new Point(0, 0));
  PointNode goal = grid.nodeFromPoint(new Point(3, 0));

  DijkstraFinder dijkstraFinder = new DijkstraFinder(grid);

  List<PointNode> path = dijkstraFinder.pathFind(start, goal);

  for (PointNode point in path) {
    print(point.location);
  }
}