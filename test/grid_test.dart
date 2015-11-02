import 'package:test/test.dart';
import 'package:path_finding/path_finding.dart';

import 'dart:math' show Point;

void main() {
  final List<List<bool>> boolGrid = new List<List<bool>>()
    ..add([true, true, false, false, true])
    ..add([true, true, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, true, true]);

  final List<List<bool>> invalidBoolGrid = new List<List<bool>>()
    ..add([true, true, false, false, true])
    ..add([true, true, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, false, true])
    ..add([false, false, true, true]);

  final String stringGrid = """
ooxoo
xoxoo
xooox
xxxoo
""";

  final String invalidStringGrid = """
ooxo
xoxoo
xooox
xxxoo
""";

  test("Grid default constructor errors on null grid", () {
    throwsError() {
      Grid grid = new Grid(null);
    }

    expect(throwsError, throwsA(new isInstanceOf<TypeError>()));
  });

  test("Grid default constructor errors on invalid argument types.", () {
    throwsError() {
      Grid grid = new Grid(boolGrid);
    }

    expect(throwsError, throwsA(new isInstanceOf<TypeError>()));
  });

  test("Grid.fromBools constructor accepts valid arguments.", () {
    Grid grid = new Grid.fromBools(boolGrid);
  });

  test("Grid.fromBools constructor errors on invalid arguments.", () {
    throwsError() {
      Grid grid = new Grid.fromBools(invalidBoolGrid);
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });

  test("Grid.fromString constructor accepts valid arguments.", () {
    Grid grid = new Grid.fromString(stringGrid);
  });

  test("Grid.fromString constructor errors on non-rectangular grid.", () {
    throwsError() {
      Grid grid = new Grid.fromString(invalidStringGrid);
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
    Grid grid = new Grid.fromString(stringGrid);

    expect(grid.rows, equals(4));
    expect(grid.cols, equals(5));
  });

  test("Grid.getNeighbors method works.", () {
    Grid grid = new Grid.fromBools(boolGrid);

    Set<Node> expectedNeighbors = new Set<Node>()
      ..add(new Node(new Point(0, 1)))
      ..add(new Node(new Point(1, 0)))
      ..add(new Node(new Point(1, 1)));

    Set<Node> actualNeighbors = grid.getNeighbors(new Node(new Point(0, 0))).toSet();

    expect(expectedNeighbors, equals(actualNeighbors));
  });

  test("Grid.exteriorCorners method works.", () {

  });
}