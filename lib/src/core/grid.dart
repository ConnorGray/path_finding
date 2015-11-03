part of path_finding;

class Grid extends Graph {
  final List<List<Node>> _grid = new List<List<Node>>();

  int get rows => this._grid.length;
  int get cols => this._grid.first.length;

  bool allowDiagonals = true;

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

  List<Node> getNeighbors(Node node, {bool onlyWalkable: false}) {
    final List<int> offsets = [-1, 0, 1];

    List<Node> neighbors = new List<Node>();

    for (int xOffset in offsets) {
      for (int yOffset in offsets) {
        if (!this.allowDiagonals) {
          if (xOffset != 0 && yOffset != 0) {
            continue;
          }
        }

        // Don't add the middle node; you can't be a neighbor of yourself
        if (xOffset == 0 && yOffset == 0) {
          continue;
        }

        Point possibleNeighborPoint = new Point(node.location.x + xOffset, node.location.y + yOffset);
        if (this.containsPoint(possibleNeighborPoint)) {
          Node neighbor = this._grid[possibleNeighborPoint.y][possibleNeighborPoint.x];
          if (onlyWalkable) {
            if (neighbor.walkable) {
              neighbors.add(neighbor);
            }
          } else {
            neighbors.add(neighbor);
          }
        }
      }
    }

    return neighbors;
  }

  double distance(Node n1, Node n2) {
    return sqrt(
        pow(n2.location.x - n1.location.x, 2) +
        pow(n2.location.y - n1.location.y, 2)
                );
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

  List<Node> getExteriorCorners(Node node) {
    Point top_left     = new Point(node.location.x - 1, node.location.y - 1);
    Point top_right    = new Point(node.location.x + 1, node.location.y + 1);
    Point bottom_left  = new Point(node.location.x - 1, node.location.y + 1);
    Point bottom_right = new Point(node.location.x + 1, node.location.y - 1);

    List<Point> corners = [top_left, top_right, bottom_left, bottom_right];

    // Remove the corners that aren't exterior corners.

    Point left   = new Point(node.location.x - 1, node.location.y);
    Point right  = new Point(node.location.x + 1, node.location.y);
    Point top    = new Point(node.location.x, node.location.y - 1);
    Point bottom = new Point(node.location.x, node.location.y + 1);

    if (this.containsPoint(left)) {
      if (!this._grid[left.y][left.x].walkable) {
        corners.remove(top_left);
        corners.remove(bottom_left);
      }
    } 
    if (this.containsPoint(right)) {
      if (!this._grid[right.y][left.x].walkable) {
        corners.remove(top_right);
        corners.remove(bottom_right);
      }
    }

    if (corners.isEmpty) {
      return [];
    }

    if (this.containsPoint(top)) {
      if (!this._grid[top.y][top.x].walkable) {
        corners.remove(top_left);
        corners.remove(top_right);
      }
    }

    if (this.containsPoint(bottom)) {
      if (!this._grid[bottom.y][bottom.x].walkable) {
        corners.remove(bottom_left);
        corners.remove(bottom_right);
      }
    }

    if (corners.isEmpty) {
      return [];
    }

    List<Node> exteriorCorners = new List<Node>();

    for (Point corner in corners) {
      if (this.containsPoint(corner)) {
        Node node = this._grid[corner.y][corner.x];
        if (node.walkable) {
          exteriorCorners.add(node);
        }
      }
    }

    return exteriorCorners;
  }

  bool containsPoint(Point point) {
    if (point.x < 0 || point.y < 0) {
      return false;
    }
    if (point.x >= this.cols || point.y >= this.rows) {
      return false;
    }

    return true;
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