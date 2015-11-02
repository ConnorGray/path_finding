import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  true,  false, true ],
    [false, true,  false, true ],
    [false, true,  false, true ],
    [false, true,  true,  true ]
  ];

  Grid grid = new Grid.fromBools(boolGrid);

  AStarFinder aStarFinder = new AStarFinder(grid);

  List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(3, 0));

  print(path);
}