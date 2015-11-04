import 'package:test/test.dart';
import 'package:path_finding/path_finding.dart';

import 'dart:math' show Point;

void main() {
  final PointNode A = new PointNode(new Point(0, 0));
  final PointNode B = new PointNode(new Point(1, 1));
  final PointNode C = new PointNode(new Point(1, 3));
  final PointNode D = new PointNode(new Point(3, 4));
  final PointNode E = new PointNode(new Point(5, 2));

  final UndirectedPointGraph undirectedPointGraph = new UndirectedPointGraph();
  undirectedPointGraph.addAdjacency(A, B);
  undirectedPointGraph.addAdjacency(B, C);
  undirectedPointGraph.addAdjacency(B, E);
  undirectedPointGraph.addAdjacency(C, D);
  undirectedPointGraph.addAdjacency(D, E);

  final PointNode startNode = A;
  final PointNode goalNode = C;
  
  final Set<PointNode> expectedNeighborsA = [B].toSet();
  final Set<PointNode> expectedNeighborsB = [A, C, E].toSet();
  final Set<PointNode> expectedNeighborsC = [B, D].toSet();
  final Set<PointNode> expectedNeighborsD = [C, E].toSet();
  final Set<PointNode> expectedNeighborsE = [B, D].toSet();

  test("UndirectedPointGraph stores edges correctly.", () {
    expect(undirectedPointGraph.getNeighbors(A), equals(expectedNeighborsA));
    expect(undirectedPointGraph.getNeighbors(B), equals(expectedNeighborsB));
    expect(undirectedPointGraph.getNeighbors(C), equals(expectedNeighborsC));
    expect(undirectedPointGraph.getNeighbors(D), equals(expectedNeighborsD));
    expect(undirectedPointGraph.getNeighbors(E), equals(expectedNeighborsE));
  });

  test("UndirectedPointGraph.fromAdjacencyList stores edges correctly.", () {
    List<List<PointNode>> adjacencyList = [
      [A, B],
      [B, C],
      [B, E],
      [C, D],
      [D, E]
    ];

    UndirectedPointGraph graph =
      new UndirectedPointGraph.fromAdjacencyList(adjacencyList);

    expect(graph.getNeighbors(A), equals(expectedNeighborsA));
    expect(graph.getNeighbors(B), equals(expectedNeighborsB));
    expect(graph.getNeighbors(C), equals(expectedNeighborsC));
    expect(graph.getNeighbors(D), equals(expectedNeighborsD));
    expect(graph.getNeighbors(E), equals(expectedNeighborsE));
  });

  test("UndirectedPointGraph.fromAdjacencyList errors on non-List argument.", () {
    throwsError() {
      UndirectedPointGraph error = new UndirectedPointGraph.fromAdjacencyList(null);
    }

    expect(throwsError, throwsA(new isInstanceOf<ArgumentError>()));
  });
}