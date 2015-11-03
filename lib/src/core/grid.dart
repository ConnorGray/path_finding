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
  final List<List<Node>> _grid = new List<List<Node>>();

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
      List<Node> nodeRow = new List<Node>();

      for (int x = 0; x < boolGrid[y].length; x++) {
        if (boolGrid[y][x] is! bool) {
          throw new ArgumentError('Every element of `boolGrid` must be of type boolean!');
        }
        Node node = new Node(new Point(x, y))..walkable = boolGrid[y][x];
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

  /// Return a list of nodes that are the neighbors of [node].
  ///
  /// By default, will only return only the neighbor nodes that are walkable.
  ///
  /// Uses the Grid.diagonalMovement property to decide which corner neighbors
  /// of [node] should be included in the results.
  List<Node> getNeighbors(Node node, {bool onlyWalkable: true}) {
    List<Node> neighbors = new List<Node>();

    neighbors.addAll(this._getSides(node, onlyWalkable));
    if (this.diagonalMovement != DiagonalMovement.Never) {
      neighbors.addAll(this._getCorners(node, onlyWalkable));
    }

    return neighbors;
  }

  /// Returns the euclidean distance between [n1] and [n2].
  double distance(Node n1, Node n2) {
    return n1.location.distanceTo(n2.location);
  }

  /// Returns a list of all the nodes that are part of this graph.
  List<Node> get allNodes {
    List<Node> nodes = new List<Node>();

    for (List<Node> nodeRow in this._grid) {
      for (Node node in nodeRow) {
        nodes.add(node);
      }
    }

    return nodes;
  }

  bool containsPoint(Point point) {
    return point.x >= 0 && point.y >= 0 && point.x < this.cols && point.y < this.rows;
  }

  bool containsNode(Node node) {
    return this.containsPoint(node.location);
  }

  Node nodeFromPoint(Point point) {
    if (!this.containsPoint(point)) {
      throw new ArgumentError('This Grid does not contain the point: $point');
    }
    return this._grid[point.y][point.x];
  }

  List<Node> _nodesFromOffsets(Node node, List<Point> offsets, bool onlyWalkable) {
    List<Node> offsetNodes = new List<Node>();

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

  List<Node> _getCorners(Node node, bool onlyWalkable) {
    List<Point> offsets = const [
      const Point(-1, -1), const Point(1, -1),
      const Point(-1, 1), const Point(1, 1)];

    List<Node> allCorners = this._nodesFromOffsets(node, offsets, onlyWalkable);
    List<Node> allowedCorners = new List<Node>();

    for (Node corner in allCorners) {
      int xOffset = corner.location.x - node.location.x;
      int yOffset = corner.location.y - node.location.y; 

      Point xDiffSidePoint = new Point(corner.location.x - xOffset, corner.location.y); 
      Point yDiffSidePoint = new Point(corner.location.x, corner.location.y - yOffset);

      int numObstructions = 0;

      if (this.containsPoint(xDiffSidePoint)) {
        Node xDiffSideNode = this.nodeFromPoint(xDiffSidePoint);
        if (!xDiffSideNode.walkable) {
          numObstructions++;
        }
      }

      if (this.containsPoint(yDiffSidePoint)) {
        Node yDiffSideNode = this.nodeFromPoint(yDiffSidePoint);
        if (!yDiffSideNode.walkable) {
          numObstructions++;
        }
      }

      switch (this.diagonalMovement) {
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

  List<Node> _getSides(Node node, bool onlyWalkable) {
    List<Point> offsets = const [
      const Point(-1, 0), const Point(1, 0),
      const Point(0, -1), const Point(0, 1)];

    return this._nodesFromOffsets(node, offsets, onlyWalkable);
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