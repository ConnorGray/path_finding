part of path_finding;

class UndirectedPointGraph extends Graph {
  Map<PointNode, Set<PointNode>> _adjacencyMap =
    new Map<PointNode, Set<PointNode>>();

  UndirectedPointGraph() {
    
  }

  UndirectedPointGraph.fromAdjacencyList(List<List<PointNode>> adjacencyList) {
    if (adjacencyList is! List) {
      throw new ArgumentError('Argument `adjacencyList` must be of type List!');
    }

    for (List<PointNode> adjacencyPair in adjacencyList) {
      if (adjacencyPair is! List) {
        throw new ArgumentError('Every element of argument `adjacencyList` must be a list!');
      }

      if (adjacencyPair.length != 2) {
        throw new ArgumentError('Every list element of `adjacencyList` must be length 2!');
      }

      this.addAdjacency(adjacencyPair[0], adjacencyPair[1]);
    }
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

  List<List<PointNode>> get adjacencyList {
    List<Set<PointNode>> adjacencySet = new List<Set<PointNode>>();

    for (PointNode node in this._adjacencyMap.keys) {
      for (PointNode adjacentNode in this._adjacencyMap[node]) {
        if (adjacentNode == node) continue;
        Set<PointNode> adjacency = new Set()
          ..add(node)
          ..add(adjacentNode);

        bool alreadyContainsAdjacency = false;
        for (Set<PointNode> existingAdjacency in adjacencySet) {
          if (existingAdjacency.containsAll(adjacency)) {
            alreadyContainsAdjacency = true;
            break;
          }
        }

        if (!alreadyContainsAdjacency) {
          adjacencySet.add(adjacency);
        }
      }
    }

    List<List<PointNode>> adjacencyList = new List<List<PointNode>>();

    for (Set<PointNode> adjacency in adjacencySet) {
      adjacencyList.add(adjacency.toList());
    }

    return adjacencyList;
  }
}