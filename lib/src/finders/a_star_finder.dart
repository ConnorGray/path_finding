part of path_finding;

/// An implementation of the A* pathfinding algorithm.
///
/// Based on the pseudocode example found at:  
/// http://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode
class AStarFinder extends Finder {
  AStarFinder(Graph graph) : super(graph);

  List<Point> pathFind(Point startPoint, Point goalPoint) {
    Node start = this.graph.nodeFromPoint(startPoint);
    Node goal = this.graph.nodeFromPoint(goalPoint);

    Set<Node> Closed = new Set<Node>();
    Set<Node> Open = new Set<Node>()..add(start);

    Map<Node, Node> Came_From = new Map<Node, Node>();

    for (Node node in this.graph.allNodes) {
      node._g = double.INFINITY;
      node._f = double.INFINITY;
    }

    start._g = 0.0;
    start._f = start._g + Heuristic.euclidean(start.location, goal.location);

    while (Open.isNotEmpty) {
      Node current = Open.first;
      for (Node node in Open) {
        if (node._f < current._f) {
          current = node;
        }
      }

      if (current == goal) {
        return _reconstruct_path(Came_From, goal);
      }

      Open.remove(current);
      Closed.add(current);

      for (Node neighbor in this.graph.getNeighbors(current, onlyWalkable: true)) {
        if (Closed.contains(neighbor)) {
          continue;
        } 

        double tentative_g_score = current._g + this.graph.distance(current, neighbor);

        if (!Open.contains(neighbor)) {
          Open.add(neighbor);
        } else if (tentative_g_score >= neighbor._g) {
          continue;
        }

        Came_From[neighbor] = current;
        neighbor._g = tentative_g_score;
        neighbor._f = neighbor._g + Heuristic.euclidean(neighbor.location, goal.location);
      }
    }

    return []; 
  }

  List<Point> _reconstruct_path(Map<Node, Node> Came_From, Node current) {
    List<Point> totalPath = [current.location];

    while (Came_From.keys.contains(current)) {
      current = Came_From[current];
      totalPath.add(current.location);
    }

    return totalPath.reversed.toList();
  }
}