part of path_finding;

class AStarFinder extends Finder {
  AStarFinder(Graph graph) : super(graph);

  /**
   * Based on the pseudocode example found at:
   * http://en.wikipedia.org/wiki/A*_search_algorithm#Pseudocode
   */
  List<Point> pathFind(Point startPoint, Point goalPoint) {
    Node start = this.graph.nodeFromPoint(startPoint);
    Node goal = this.graph.nodeFromPoint(goalPoint);

    Set<Node> Closed = new Set<Node>();
    Set<Node> Open = new Set<Node>()..add(start);

    Map<Node, Node> Came_From = new Map<Node, Node>();

    for (Node node in this.graph.allNodes) {
      node.g = double.INFINITY;
      node.f = double.INFINITY;
    }

    start.g = 0.0;
    start.f = start.g + Heuristic.euclidean(start.location, goal.location);

    while (Open.isNotEmpty) {
      Node current = Open.first;
      for (Node node in Open) {
        if (node.f < current.f) {
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

        double tentative_g_score = current.g + this.graph.distance(current, neighbor);

        if (!Open.contains(neighbor)) {
          Open.add(neighbor);
        } else if (tentative_g_score >= neighbor.g) {
          continue;
        }

        Came_From[neighbor] = current;
        neighbor.g = tentative_g_score;
        neighbor.f = neighbor.g + Heuristic.euclidean(neighbor.location, goal.location);
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