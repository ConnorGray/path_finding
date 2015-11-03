import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  true,  false],
    [false, true,  false],
    [false, true,  true],
  ];

  Grid grid = new Grid(boolGrid);
  grid.diagonalMovement = DiagonalMovement.Never;

  AStarFinder aStarFinder = new AStarFinder(grid);

  List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

  for (Point point in path) {
    print(point);
  }
}