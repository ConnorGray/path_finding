/// Benchmark time by version #:
/// * 0.2.0: 72.9  73.1  71.4  71.5  70.6  71.0  71.4  72.1  70.3  71.9
import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:path_finding/path_finding.dart';
import 'dart:math' show Point;

Grid grid = new Grid([
  [true,  true,  false, false, true],
  [true,  true,  false, true,  true],
  [false, true,  true,  false, true],
  [true,  false, true,  true,  true],
  [true,  true,  true,  true,  true]
]);

AStarFinder aStarFinder = new AStarFinder(grid);

class TemplateBenchmark extends BenchmarkBase {
  const TemplateBenchmark() : super("Template");

  static void main() {
    new TemplateBenchmark().report();
  }

  void run() {
    aStarFinder.pathFind(new Point(0, 0), new Point(4, 0));
  }
}

void main() {
  TemplateBenchmark.main();
}