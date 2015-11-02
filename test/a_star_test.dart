import 'package:test/test.dart';
import 'package:path_finding/path_finding.dart';

import 'dart:math' show Point;

void main() {
  final List<List<bool>> boolGrid = new List<List<bool>>()
    ..add([true,  true,  false])
    ..add([false, true,  false])
    ..add([false, true,  true]);

  final List<List<bool>> noSolutionBoolGrid = new List<List<bool>>()
    ..add([true,  true,  false])
    ..add([false, false,  false])
    ..add([false, true,  true]);

  final List<List<bool>> noSolutionWithoutDiagonalsBoolGrid = new List<List<bool>>()
    ..add([true,  true,  false])
    ..add([false, true,  false])
    ..add([false, false,  true]);


  test("AStarFinder finds correct diagonal path.", () {
    Grid grid = new Grid.fromBools(boolGrid);

    AStarFinder aStarFinder = new AStarFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([new Point(0, 0), new Point(1, 1), new Point(2, 2)]));
  });

  test("AStarFinder finds correct non-diagonal path.", () {
    Grid grid = new Grid.fromBools(boolGrid);
    grid.allowDiagonals = false;

    AStarFinder aStarFinder = new AStarFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path,
        equals([
          new Point(0, 0), new Point(1, 0), new Point(1, 1), new Point(1, 2),
          new Point(2, 2)]));
  });

  test("AStarFinder returns empty list when no path exists.", () {
    Grid grid = new Grid.fromBools(noSolutionBoolGrid);

    AStarFinder aStarFinder = new AStarFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([]));
  });

  test("AStarFinder on noSolutionWithoutDiagonalsBoolGrid works with diagonals.", () {
    Grid grid = new Grid.fromBools(noSolutionWithoutDiagonalsBoolGrid);
    grid.allowDiagonals = true;

    AStarFinder aStarFinder = new AStarFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([new Point(0, 0), new Point(1, 1), new Point(2, 2)]));
  });

  test("AStarFinder on noSolutionWithoutDiagonalsBoolGrid does not work without diagonals.", () {
    Grid grid = new Grid.fromBools(noSolutionWithoutDiagonalsBoolGrid);
    grid.allowDiagonals = false;

    AStarFinder aStarFinder = new AStarFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([]));
  });
}