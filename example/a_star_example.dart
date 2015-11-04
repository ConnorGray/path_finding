import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  false, true],
    [true,  true,  true ],
    [true,  false, true ]
  ];

  Grid grid = new Grid(boolGrid);
  grid.diagonalMovement = DiagonalMovement.Never;

  PointNode start = grid.nodeFromPoint(new Point(0, 0));
  PointNode goal = grid.nodeFromPoint(new Point(2, 2));

  AStarFinder aStarFinder = new AStarFinder(grid);

  List<PointNode> path = aStarFinder.pathFind(start, goal);

  for (PointNode node in path) {
    print(node.location);
  }
}