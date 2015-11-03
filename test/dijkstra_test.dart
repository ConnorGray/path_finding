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


  test("DijkstraFinder finds correct diagonal path.", () {
    Grid grid = new Grid(boolGrid);

    DijkstraFinder aStarFinder = new DijkstraFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([new Point(0, 0), new Point(1, 1), new Point(2, 2)]));
  });

  test("DijkstraFinder finds correct non-diagonal path.", () {
    Grid grid = new Grid(boolGrid);
    grid.diagonalMovement = DiagonalMovement.Never;

    DijkstraFinder aStarFinder = new DijkstraFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path,
        equals([
          new Point(0, 0), new Point(1, 0), new Point(1, 1), new Point(1, 2),
          new Point(2, 2)]));
  });

  test("DijkstraFinder returns empty list when no path exists.", () {
    Grid grid = new Grid(noSolutionBoolGrid);

    DijkstraFinder aStarFinder = new DijkstraFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([]));
  });

  test("DijkstraFinder on noSolutionWithoutDiagonalsBoolGrid works with diagonals.", () {
    Grid grid = new Grid(noSolutionWithoutDiagonalsBoolGrid);
    grid.diagonalMovement = DiagonalMovement.Always;

    DijkstraFinder aStarFinder = new DijkstraFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([new Point(0, 0), new Point(1, 1), new Point(2, 2)]));
  });

  test("DijkstraFinder on noSolutionWithoutDiagonalsBoolGrid does not work without diagonals.", () {
    Grid grid = new Grid(noSolutionWithoutDiagonalsBoolGrid);
    grid.diagonalMovement = DiagonalMovement.Never;

    DijkstraFinder aStarFinder = new DijkstraFinder(grid);

    List<Point> path = aStarFinder.pathFind(new Point(0, 0), new Point(2, 2));

    expect(path, equals([]));
  });
}