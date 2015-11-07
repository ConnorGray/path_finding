# path_finding

A pathfinding library for Dart  

Find it on pub at https://pub.dartlang.org/packages/path_finding.  

View the online demo at https://connorgray.github.io/path_finding/demo/build/web/

To use it in your project add
```
path_finding: ">=0.3.0 <0.4.0"
```
to your pubspec.yaml depencies.

# Examples

## A* Finder

```dart
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
  grid.diagonalMovement = DiagonalMovement.Never;

  PointNode start = grid.nodeFromPoint(new Point(0, 0));
  PointNode goal = grid.nodeFromPoint(new Point(3, 0));

  DijkstraFinder dijkstraFinder = new DijkstraFinder(grid);

  List<PointNode> path = dijkstraFinder.pathFind(start, goal);

  for (PointNode point in path) {
    print(point.location);
  }
}
```

## UndirectedPointGraph 

```dart    
import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

void main() {
  UndirectedPointGraph undirectedGraph = new UndirectedPointGraph();

  PointNode A = new PointNode(new Point(0, 0));
  PointNode B = new PointNode(new Point(1, 1));
  PointNode C = new PointNode(new Point(3, 2));
  PointNode D = new PointNode(new Point(2, 7));
  PointNode E = new PointNode(new Point(4, 5));

  undirectedGraph.addAdjacency(A, B);
  undirectedGraph.addAdjacency(B, C);
  undirectedGraph.addAdjacency(B, D);
  undirectedGraph.addAdjacency(C, D);
  undirectedGraph.addAdjacency(B, E);
  undirectedGraph.addAdjacency(C, E);

  AStarFinder aStarFinder = new AStarFinder(undirectedGraph);

  List<PointNode> path = aStarFinder.pathFind(A, E);

  for (PointNode node in path) {
    print(node.location);
  }
}
```