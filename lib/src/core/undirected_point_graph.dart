part of path_finding;

/// An undirected graph where each node is tied to a [Point].
///
/// A UndirectedPointGraph can be used for most general
/// purpose graph needs.
class UndirectedPointGraph extends Graph {
  Map<PointNode, Set<PointNode>> _adjacencyMap =
    new Map<PointNode, Set<PointNode>>();

  /// Default constructor. Use .addAdjacency to populate this [Graph].
  UndirectedPointGraph() {
    
  }

  /// Conveinience constructor, that calls .addAdjacency for
  /// each element of [adjacencyList].
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

  /// Returns every [PointNode] that is adjacent to [node].
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

  /// Add an edge to this graph connecting [node1] and [node2].
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

  /// Return a ListList<PointNode>> where each element is an
  /// [PointNode] pair representing an edge of this graph.
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