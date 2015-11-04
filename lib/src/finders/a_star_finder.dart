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

    Map<Node, Node> Came_From = new Map<Node, Node>();

    for (Node node in this.graph.allNodes) {
      node._g = double.INFINITY;
      node._f = double.INFINITY;
      node._isInClosedSet = false;
      node._isInOpenSet = false;
    }

    start._isInOpenSet = true;
    int numInOpenSet = 1;

    start._g = 0.0;
    start._f = start._g + Heuristic.euclidean(start.location, goal.location);

    while (numInOpenSet > 0) {
      List<Node> openNodes = this.graph.allNodes
        .where((Node node) => node._isInOpenSet).toList();

      Node current = openNodes.first;
      for (Node node in openNodes) {
        if (node._f < current._f) {
          current = node;
        }
      }

      if (current == goal) {
        return _reconstruct_path(Came_From, goal);
      }

      current._isInOpenSet = false;
      numInOpenSet--;

      current._isInClosedSet = true;

      for (Node neighbor in this.graph
             .getNeighbors(current, onlyWalkable: true)) {
        if (neighbor._isInClosedSet) {
          continue;
        } 

        double tentative_g_score = current._g +
          this.graph.distance(current, neighbor);

        if (!neighbor._isInOpenSet) {
          neighbor._isInOpenSet = true;
          numInOpenSet++;
        } else if (tentative_g_score >= neighbor._g) {
          continue;
        }

        Came_From[neighbor] = current;
        neighbor._g = tentative_g_score;
        neighbor._f = neighbor._g +
          Heuristic.euclidean(neighbor.location, goal.location);
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