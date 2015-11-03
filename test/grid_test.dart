import 'package:test/test.dart';
import 'package:path_finding/path_finding.dart';

import 'dart:math' show Point;

void main() {
  final List<List<bool>> rectangularBoolGrid = new List<List<bool>>()
    ..add([true, true, false, false, true])
    ..add([true, true, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, true, true]);

  final List<List<bool>> nonRectangularBoolGrid = new List<List<bool>>()
    ..add([true, true, false, false, true])
    ..add([true, true, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, true]);

  final List<List<bool>> diagonalMovementTestCasesBoolGrid = [
    [true,  true,  true], // Top Left: 1 obstructions Top Right: 1 obstruction
    [false, true,  true], 
    [true,  false, false] // Bottom Left: 2 obstructions
  ];

  final String rectangularStringGrid = """
ooxoo
xoxoo
xooox
xxxoo
""";

  final String nonRectangularStringGrid = """
ooxo
xoxoo
xooox
xxxoo
""";

  test("Grid default constructor errors on non-rectangular grid.", () {
    throwsError() {
      Grid grid = new Grid(nonRectangularBoolGrid);
    }
    
  });

  test("Grid.fromString constructor errors on non-rectangular grid.", () {
    throwsError() {
      Grid grid = new Grid.fromString(nonRectangularStringGrid);
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });

  test("Grid default constructor errors on null grid.", () {
    throwsError() {
      Grid grid = new Grid(null);
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });

  test("Grid.fromString constructor errors on null grid.", () {
    throwsError() {
      Grid grid = new Grid.fromString(null);
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });

  test("Grid.fromString constructor errors on "" grid", () {
    throwsError() {
      Grid grid = new Grid.fromString("");
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });

  test("Grid rows and cols properties are accurate.", () {
    Grid grid = new Grid.fromString(rectangularStringGrid);

    expect(grid.rows, equals(4));
    expect(grid.cols, equals(5));
  });

  test("Grid.getNeighbors with DiagonalMovement.Always works.", () {
    Grid grid = new Grid(diagonalMovementTestCasesBoolGrid);
    grid.diagonalMovement = DiagonalMovement.Always;

    Set<Node> expectedNeighbors = [
      new Node(new Point(0, 0)),
      new Node(new Point(1, 0)),
      new Node(new Point(2, 0)),
      new Node(new Point(2, 1)),
      new Node(new Point(0, 2))
    ].toSet();

    Set<Node> actualNeighbors = grid.getNeighbors(new Node(new Point(1, 1))).toSet();

    expect(actualNeighbors, equals(expectedNeighbors));
  });

  test("Grid.getNeighbors with DiagonalMovement.Never works.", () {
    Grid grid = new Grid(diagonalMovementTestCasesBoolGrid);
    grid.diagonalMovement = DiagonalMovement.Never;

    Set<Node> expectedNeighbors = [
      new Node(new Point(1, 0)),
      new Node(new Point(2, 1))
    ].toSet();

    Set<Node> actualNeighbors = grid.getNeighbors(new Node(new Point(1, 1))).toSet();

    expect(actualNeighbors, equals(expectedNeighbors));
  });

  test("Grid.getNeighbors with DiagonalMovement.WithNoObstructions works.", () {
    Grid grid = new Grid(diagonalMovementTestCasesBoolGrid);
    grid.diagonalMovement = DiagonalMovement.WithNoObstructions;

    Set<Node> expectedNeighbors = [
      new Node(new Point(2, 0)),
      new Node(new Point(1, 0)),
      new Node(new Point(2, 1))
    ].toSet();

    Set<Node> actualNeighbors = grid.getNeighbors(new Node(new Point(1, 1))).toSet();

    expect(actualNeighbors, equals(expectedNeighbors));
  });

  test("Grid.getNeighbors with DiagonalMovement.WithOneObstruction works.", () {
    Grid grid = new Grid(diagonalMovementTestCasesBoolGrid);
    grid.diagonalMovement = DiagonalMovement.WithOneObstruction;

    Set<Node> expectedNeighbors = [
      new Node(new Point(0, 0)),
      new Node(new Point(2, 0)),
      new Node(new Point(1, 0)),
      new Node(new Point(2, 1))
    ].toSet();

    Set<Node> actualNeighbors = grid.getNeighbors(new Node(new Point(1, 1))).toSet();

    expect(actualNeighbors, equals(expectedNeighbors));
  });

  // test("Grid.exteriorCorners method works.", () {

  // });
}