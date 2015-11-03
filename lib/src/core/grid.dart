part of path_finding;

class Grid extends Graph {
  final List<List<Node>> grid;

  int get rows => this.grid.length;
  int get cols => this.grid.first.length;

  bool allowDiagonals = true;

  Grid(List<List<Node>> nodeGrid) : grid = nodeGrid {
    if (!(this.grid is List<List<Node>>)) {
      throw new TypeError();
    } else if (!_isRectangular(this.grid)) {
      throw new ArgumentError('Grid must be rectangular!');
    }
  }

  factory Grid.fromBools(List<List<bool>> boolGrid) {
    if (!(boolGrid is List<List<bool>>)) {
      throw new TypeError();
    };

    List<List<Node>> nodeGrid = new List<List<Node>>();

    for (int y = 0; y < boolGrid.length; y++) {
      List<Node> nodeRow = new List<Node>();

      for (int x = 0; x < boolGrid[y].length; x++) {
        if (boolGrid[y][x] is! bool) {
          throw new TypeError('Grid rows must contain only booleans!');
        }
        Node node = new Node(new Point(x, y))..walkable = boolGrid[y][x];
        nodeRow.add(node);
      }

      nodeGrid.add(nodeRow); 
    }

    return new Grid(nodeGrid);
  }

  factory Grid.fromString(String stringGrid) {
    if (!(stringGrid is String)) {
      throw new TypeError();
    } else if (stringGrid == "") {
      throw new ArgumentError('String cannot be "" (empty)!');
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

    return new Grid.fromBools(boolGrid);
  }

  List<Node> getNeighbors(Node node, {bool onlyWalkable: true}) {
    final List<int> offsets = [-1, 0, 1];

    List<Node> neighbors = new List<Node>();

    for (int xOffset in offsets) {
      for (int yOffset in offsets) {
        if (!this.allowDiagonals) {
          if (xOffset == yOffset) {
            continue;
          } else if (xOffset == -1 && yOffset == 1) {
            continue;
          } else if (xOffset == 1 && yOffset == -1) {
            continue; 
          }
        }

        if (xOffset == 0 && yOffset == 0) {
          continue;
        }

        Point possibleNeighborPoint = new Point(node.location.x + xOffset, node.location.y + yOffset);
        if (this.containsPoint(possibleNeighborPoint)) {
          Node neighbor = this.grid[possibleNeighborPoint.y][possibleNeighborPoint.x];
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

    for (List<Node> nodeRow in this.grid) {
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
      if (!this.grid[left.y][left.x].walkable) {
        corners.remove(top_left);
        corners.remove(bottom_left);
      }
    }

    if (this.containsPoint(right)) {
      if (!this.grid[right.y][left.x].walkable) {
        corners.remove(top_right);
        corners.remove(bottom_right);
      }
    }

    if (corners.isEmpty) {
      return [];
    }

    if (this.containsPoint(top)) {
      if (!this.grid[top.y][top.x].walkable) {
        corners.remove(top_left);
        corners.remove(top_right);
      }
    }

    if (this.containsPoint(bottom)) {
      if (!this.grid[bottom.y][bottom.x].walkable) {
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
        Node node = this.grid[corner.y][corner.x];
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
      throw new ArgumentError('This graph does not contain that point!');
    }
    return this.grid[point.y][point.x];
  }

  /**
   * Check whether or not the 2-dimensional List grid is rectangular.
   */
  static bool _isRectangular(List<List> boolList) {
    if (boolList.length == 0) {
      return false;
    } else if (boolList.first.length == 0) {
      return false;
    }

    final int firstRowLength = boolList.first.length;

    for (int i = 0; i < boolList.length; i++) {
      if (boolList[i].length != firstRowLength) {
        return false;
      }
    }

    return true;
  }
}