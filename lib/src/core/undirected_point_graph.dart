part of path_finding;

class UndirectedPointGraph extends Graph {
  Map<PointNode, Set<PointNode>> _adjacencyMap = new Map<PointNode, Set<PointNode>>();

  UndirectedPointGraph() {
    
  }

  //-------------------------//
  // Graph Interface Methods //
  //-------------------------//

  List<PointNode> getNeighbors(PointNode node, {bool onlyWalkable: true}) {
    Set<PointNode> neighbors = this._adjacencyMap[node];
    return neighbors.toList();
  }

  double distance(PointNode n1, PointNode n2) {
    return this.heuristic(n1, n2);
  }

  double heuristic(PointNode n1, PointNode n2) {
    return n1.location.distanceTo(n2.location);
  }

  bool containsNode(PointNode node) {
    return this._adjacencyMap.containsKey(node);
  }

  List<PointNode> get allNodes {
    return this._adjacencyMap.keys.toList();
  }

  //------------------------//
  // Implementation Methods // 
  //------------------------//

  void addAdjacency(PointNode node1, PointNode node2) {
    if (this._adjacencyMap.containsKey(node1)) {
      this._adjacencyMap[node1].add(node2);
    } else {
      this._adjacencyMap[node1] = new Set<PointNode>()..add(node2);
    }

    if (this._adjacencyMap.containsKey(node2)) {
      this._adjacencyMap[node2].add(node1);
    } else {
      this._adjacencyMap[node2] = new Set<PointNode>()..add(node1);
    }
  }
}