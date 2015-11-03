# path_finding
A pathfinding library for Dart
Find it on pub at https://pub.dartlang.org/packages/path_finding

To use it in your project add
```
path_finding: ">=0.2.0 <0.3.0"
```
to your projects dependencies.

# Examples

## A* Finder

```dart
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
```

## Dijkstra Finder

```dart
import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  List<List<bool>> boolGrid = [
    [true,  false, false, true],
    [true,  true,  false, true],
    [false, true,  true,  true]
  ];

  Grid grid = new Grid(boolGrid);
  grid.diagonalMovement = DiagonalMovement.WithOneObstruction;

  DijkstraFinder dijkstraFinder = new DijkstraFinder(grid);

  List<Point> path = dijkstraFinder.pathFind(new Point(0, 0), new Point(3, 0));

  for (Point point in path) {
    print(point);
  }
}
```
