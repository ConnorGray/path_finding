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