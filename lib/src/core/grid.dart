part of path_finding;

enum DiagonalMovement {
  Always,
  Never,
  WithNoObstructions,
  WithOneObstruction
}

class Grid extends Graph {
  final List<List<Node>> _grid = new List<List<Node>>();

  int get rows => this._grid.length;
  int get cols => this._grid.first.length;

  /* These variable effect how the Grid.getNeighbors method 
   * decides which nodes to return.
   */
  DiagonalMovement diagonalMovement = DiagonalMovement.Always;

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

  List<Node> getNeighbors(Node node, {bool onlyWalkable: true}) {
    List<Node> neighbors = new List<Node>();

    neighbors.addAll(this._getSides(node, onlyWalkable));
    if (this.diagonalMovement != DiagonalMovement.Never) {
      neighbors.addAll(this._getCorners(node, onlyWalkable));
    }

    return neighbors;
  }

  double distance(Node n1, Node n2) {
    return n1.location.distanceTo(n2.location);
  }

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

  /**
   * Return whether or not the 2-dimensional List<List> is rectangular.
   */
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