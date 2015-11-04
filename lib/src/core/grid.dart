part of path_finding;

/// A rule value that changes how the Grid.getNeighbors method decides which nodes are neighbors.
///
/// For example:
///
/// Given a boolean grid and a [centerNode] at (1, 1):
///
///```
///       0       1       2
///   -------------------------
/// 0 | true  | true  | true  |
///   |-------|-------|-------|
/// 1 | false | true  | true  |
///   |-------|-------|-------|
/// 2 | true  | false | false |
///   -------------------------
///```
///
/// An obstruction is any [Node node] where [node.walkable == false], and that node
/// is inbetween the [centerNode] and one of its corner neighbors.
///
/// So, of of the walkable corner neighbors of [centerNode], each has these obstructions:
///```
/// Top Right (2, 0): 0 obstructions -> 
/// Top Left  (0, 0): 1 obstructions -> (0, 1)
/// Bot Left  (0, 2): 2 obstructions -> (0, 1) (1, 2)
///```
///
/// For the different values of DiagonalMovement, the results of
/// Grid.getNeighbors(centerNode) are:
///
///```
/// case DiagonalMovement.Always:  
///   [(0, 0), (1, 0), (2, 0), (2, 1), (0, 2)]  
/// case DiagonalMovement.Never:  
///   [(1, 0), (2, 1)]  
/// case DiagonalMovement.WithNoObstructions:  
///   [(2, 0), (1, 0), (2, 1)]  
/// case DiagonalMovement.WithOneObstruction:  
///   [(0, 0), (2, 0), (1, 0), (2, 1)]  
///```
enum DiagonalMovement {
  Always,
  Never,
  WithNoObstructions,
  WithOneObstruction
}

/// A convinience implementation of a square lattice graph.
class Grid extends Graph {
  final List<List<PointNode>> _grid = new List<List<PointNode>>();

  ///  Number of rows in this Grid.
  int get rows => this._grid.length;
  /// Number of cols in this Grid.
  int get cols => this._grid.first.length;

  /// Changes how the Grid.getNeighbors method decides which nodes are valid neighbors.
  DiagonalMovement diagonalMovement = DiagonalMovement.Always;

  /// Initializes a Grid from a List<List<bool>>.
  ///
  /// Throws an [ArgumentError] if the list is not a boolean matrix,
  /// or if the list is not a rectangular matrix (all rows the same length).
  Grid(List<List<bool>> boolGrid) {
    if (boolGrid is! List<List<bool>>) {
      throw new ArgumentError('Argument `boolGrid` must be of type List<List<bool>>!');
    }

    if (!_isRectangular(boolGrid)) {
      throw new ArgumentError('Argument `boolGrid` must be a rectangular nested List!');
    }

    for (int y = 0; y < boolGrid.length; y++) {
      List<PointNode> nodeRow = new List<PointNode>();

      for (int x = 0; x < boolGrid[y].length; x++) {
        if (boolGrid[y][x] is! bool) {
          throw new ArgumentError('Every element of `boolGrid` must be of type boolean!');
        }
        PointNode node = new PointNode(new Point(x, y))..walkable = boolGrid[y][x];
        nodeRow.add(node);
      }

      this._grid.add(nodeRow); 
    }
  }

  /// Initializes a Grid from a String.
  ///
  /// Throws an [ArgumentError] if the argument [stringGrid] is not a String, 
  /// or if it's an empty string (""), or if the matrix parsed from it is not rectangular.
  factory Grid.fromString(String stringGrid) {
    if (stringGrid is! String) {
      throw new ArgumentError('Argument `stringGrid` must be of type String');
    } else if (stringGrid == "") {
      throw new ArgumentError('Argument `stringGrid` cannot be "" (empty string)!');
    }
    stringGrid = stringGrid.trim();

    List<String> stringRows = stringGrid.split('\n');
    List<List<bool>> boolGrid = new List<List<bool>>();

    for (String stringRow in stringRows) {
      List<bool> boolRow = new List<bool>();

      for (int i = 0; i < stringRow.length; i++) {
        switch (stringRow[i]) {
          case "o": // passable / walkable
            boolRow.add(true);
            break;
          case "x": // impassable / unwalkable
            boolRow.add(false);
            break;
          default: // Default to impassable / unwalkable
            boolRow.add(false);
            break;
        }
      }

      boolGrid.add(boolRow);
    }

    return new Grid(boolGrid);
  }

  //-------------------------//
  // Graph Interface Methods //
  //-------------------------//

  /// Return a list of nodes that are the neighbors of [node].
  ///
  /// By default, will only return only the neighbor nodes that are walkable.
  ///
  /// Uses the Grid.diagonalMovement property to decide which corner neighbors
  /// of [node] should be included in the results.
  List<PointNode> getNeighbors(PointNode node, {bool onlyWalkable: true}) {
    List<PointNode> neighbors = new List<PointNode>();

    neighbors.addAll(this._getSides(node, onlyWalkable));
    if (this.diagonalMovement != DiagonalMovement.Never) {
      neighbors.addAll(this._getCorners(node, onlyWalkable, diagonalMovement));
    }

    return neighbors;
  }

  /// Returns the euclidean distance between [n1] and [n2].
  double distance(PointNode n1, PointNode n2) {
    return n1.location.distanceTo(n2.location);
  }

  double heuristic(PointNode n1, PointNode n2) {
    return n1.location.distanceTo(n2.location);
  }

  bool containsNode(PointNode node) {
    return this.containsPoint(node.location);
  }

  /// Returns a list of all the nodes that are part of this graph.
  List<PointNode> get allNodes {
    List<PointNode> nodes = new List<PointNode>();

    for (List<PointNode> nodeRow in this._grid) {
      for (Node node in nodeRow) {
        nodes.add(node);
      }
    }

    return nodes;
  }

  //------------------------//
  // Implementation Methods // 
  //------------------------//

  /// Returns whether or not this [Grid] contains a [PointNode] at [point].
  bool containsPoint(Point point) {
    return point.x >= 0 && point.y >= 0 && point.x < this.cols && point.y < this.rows;
  }

  /// Returns the [PointNode] of this [Grid] found at [point].
  ///
  /// Throws [ArgumentError] if there is no Node located at [point].
  PointNode nodeFromPoint(Point point) {
    if (!this.containsPoint(point)) {
      throw new ArgumentError('This Grid does not contain the point: $point');
    }
    return this._grid[point.y][point.x];
  }

  /// Return a list of all the "exterior corners" of this [Grid].
  ///
  /// An "exterior corner" is defined as any walkable [Node]
  /// diagonally adjacent to a non-walkable [Node] that has
  /// 0 obstructions. An obstruction in defined in the doc
  /// string for the DiagonalMovement enum.
  List<PointNode> getExteriorCorners() {
    Set<PointNode> exteriorCorners = new Set<PointNode>();

    for (int x = 0; x < this.cols; x++) {
      for (int y = 0; y < this.rows; y++) {
        PointNode center = this.nodeFromPoint(new Point(x, y));
        if (!center.walkable) {
          exteriorCorners.addAll(
              this._getCorners(center, true, DiagonalMovement.WithNoObstructions));
        }
      }
    }

    return exteriorCorners.toList();
  }

  /// Construct an [UndirectedPointGraph] from this [Grid]s exterior corners.
  ///
  /// The Graph is optimized to only hold adjacencies between
  /// exterior corners who are "line of sight" with each other,
  /// meaning there are no non-walkable nodes on the straight
  /// line between them.
  UndirectedPointGraph getExteriorCornersGraph() {
    List<PointNode> exteriorCorners = this.getExteriorCorners();

    UndirectedPointGraph exteriorCornersGraph = new UndirectedPointGraph();

    for (PointNode outerNode in exteriorCorners) {
      for (PointNode innerNode in exteriorCorners) {
        if (_isWalkableLine(outerNode, innerNode)) {
          exteriorCornersGraph.addAdjacency(outerNode, innerNode);
        }
      }
    }

    return exteriorCornersGraph;
  }

  List<PointNode> _getCorners(PointNode node, bool onlyWalkable,
      DiagonalMovement diagonal) {
    if (diagonal == DiagonalMovement.Never) return [];

    List<Point> offsets = const [
      const Point(-1, -1), const Point(1, -1),
      const Point(-1, 1), const Point(1, 1)];

    List<PointNode> allCorners = this._nodesFromOffsets(node, offsets, onlyWalkable);
    List<PointNode> allowedCorners = new List<PointNode>();

    for (PointNode corner in allCorners) {
      int xOffset = corner.location.x - node.location.x;
      int yOffset = corner.location.y - node.location.y; 

      Point xDiffSidePoint = new Point(corner.location.x - xOffset, corner.location.y); 
      Point yDiffSidePoint = new Point(corner.location.x, corner.location.y - yOffset);

      int numObstructions = 0;

      if (this.containsPoint(xDiffSidePoint)) {
        PointNode xDiffSideNode = this.nodeFromPoint(xDiffSidePoint);
        if (!xDiffSideNode.walkable) {
          numObstructions++;
        }
      }

      if (this.containsPoint(yDiffSidePoint)) {
        PointNode yDiffSideNode = this.nodeFromPoint(yDiffSidePoint);
        if (!yDiffSideNode.walkable) {
          numObstructions++;
        }
      }

      switch (diagonal) {
        case DiagonalMovement.Always:
          allowedCorners.add(corner);
          break;
        case DiagonalMovement.Never:
          break;
        case DiagonalMovement.WithNoObstructions:
          if (numObstructions == 0) {
            allowedCorners.add(corner);
          }
          break;
        case DiagonalMovement.WithOneObstruction:
          if (numObstructions <= 1) {
            allowedCorners.add(corner);
          }
          break;
      }
    }

    return allowedCorners;
  }

  List<PointNode> _getSides(PointNode node, bool onlyWalkable) {
    List<Point> offsets = const [
      const Point(-1, 0), const Point(1, 0),
      const Point(0, -1), const Point(0, 1)];

    return this._nodesFromOffsets(node, offsets, onlyWalkable);
  }

  /// Take a node and a list of offsets and return a list made
  /// of the result of each offset being applied to node.
  List<PointNode> _nodesFromOffsets(PointNode node, List<Point> offsets, bool onlyWalkable) {
    List<PointNode> offsetNodes = new List<PointNode>();

    for (Point offset in offsets) {
      Point offsetPoint = node.location + offset;
      if (this.containsPoint(offsetPoint)) {
        Node offsetNode = this.nodeFromPoint(offsetPoint);
        if (onlyWalkable) {
          if (offsetNode.walkable) {
            offsetNodes.add(offsetNode);
          }
        } else {
          offsetNodes.add(offsetNode);
        }
      }
    }

    return offsetNodes;
  }

  /// Return whether or not every point on the Bresenham line
  /// between [n1] and [n2] is walkable.
  bool _isWalkableLine(PointNode n1, PointNode n2) {
    List<Point> linePoints = _bresenhamLine(n1.location, n2.location);
    for (Point point in linePoints) {
      if (!this.nodeFromPoint(point).walkable) {
        return false;
      }
    }
    return true;
  }

  /// Implementation based on Python implementation found at:
  /// www.roguebasin.com/index.php?title=Bresenham%27s_Line_Algorithm#Python
  static List<Point> _bresenhamLine(Point n1, Point n2) {
    Point delta = n2 - n1;

    bool isSteep = delta.y.abs() > delta.x.abs();

    if (isSteep) {
      n1 = new Point(n1.y, n1.y);
      n2 = new Point(n2.y, n2.x);
    }

    bool swapped = false;
    if (n1.x > n2.x) {
      Point temp = n1;
      n1 = new Point(n2.x, n2.y);
      n2 = new Point(temp.x, temp.y);
      swapped = true;
    }

    delta = n2 - n1;

    int error = (delta.x / 2.0).toInt();
    int yStep = n1.y < n2.y ? 1 : -1;

    List<Point> linePoints = new List<Point>();

    int y = n1.y;
    for (int x = n1.x; x <= n2.x; x++) {
      Point coord = isSteep ? new Point(y, x) : new Point(x, y);
      linePoints.add(coord);
      error -= delta.y.abs();
      if (error < 0) {
        y += yStep;
        error += delta.x;
      }
    }

    if (swapped) {
      return linePoints.reversed.toList();
    } else {
      return linePoints.toList();
    }
  }

  /// Return whether or not the 2-dimensional List<List> is rectangular.
  static bool _isRectangular(List<List> list) {
    if (list.length == 0) {
      return false;
    } else if (list.first.length == 0) {
      return false;
    }

    final int firstRowLength = list.first.length;

    for (int i = 0; i < list.length; i++) {
      if (list[i].length != firstRowLength) {
        return false;
      }
    }

    return true;
  }
}