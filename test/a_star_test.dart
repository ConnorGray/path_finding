import 'package:test/test.dart';
import 'package:path_finding/path_finding.dart';

import 'dart:math' show Point;

void main() {
  test("AStarFinder finds path", () {
    String stringGrid =
      """
oooo
ooxo
oooo
oooo
""";

    Grid grid = new Grid.fromString(stringGrid);

    AStarFinder aStarFinder = new AStarFinder(grid);

    // List<Node> path =
    //   aStarFinder.pathFind(new Point(0, 0), new Point(3, 3));
  });
}