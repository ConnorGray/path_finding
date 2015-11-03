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

  DijkstraFinder dijkstraFinder = new DijkstraFinder(grid);

  List<Point> path = dijkstraFinder.pathFind(new Point(0, 0), new Point(3, 0));

  for (Point point in path) {
    print(point);
  }
}