import 'dart:html' as html;
import 'dart:math' show Random, Point, pow;

import 'package:stagexl/stagexl.dart' hide Point;
import 'package:polymer/polymer.dart';
import 'package:path_finding/path_finding.dart';

@CustomTag('path-finding-demo')
class PathFindingDemoElement extends PolymerElement {
  static final int WIDTH = 768;
  static final int HEIGHT = 768;

  int get TILE_SIZE => pow(2, this.tileSizeExponent);
  int get ROWS => WIDTH ~/ TILE_SIZE;
  int get COLS => HEIGHT ~/ TILE_SIZE;

  @observable final int DISPLAY_WIDTH = WIDTH;
  @observable final int DISPLAY_HEIGHT = HEIGHT;

  @observable String selectedAlgorithm = "aStar";
  @observable String selectedDiagonalMovement = "withOneObstruction";
  @observable double randomSparseness = 0.75;
  @observable int tileSizeExponent = 5;

  Algorithm _algorithm = Algorithm.AStar;
  DiagonalMovement _diagonalMovement = DiagonalMovement.WithOneObstruction;

  final List<List<Tile>> _tileGrid = new List<List<Tile>>();

  Point _startPoint;
  Point _goalPoint;
  Shape _pathLine;

  final random = new Random();

  bool _mouseIsDown = false;
  TileType _tileDrawingType = TileType.Wall;

  // StageXL Variables
  Stage stage = null;
  RenderLoop renderLoop = null;

  PathFindingDemoElement.created() : super.created() {
    StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
    html.CanvasElement canvas = shadowRoot.query('#stage');
    this.stage = new Stage(canvas);
    this.renderLoop = new RenderLoop();
    this.renderLoop.addStage(stage);

    this.stage.onMouseDown.listen(this._onMouseDown);
    this.stage.onMouseUp.listen(this._onMouseUp);
    this.stage.onMouseMove.listen(this._onMouseMove);

    _reset();
  }

  void _reset() {
    this._tileGrid.clear();
    this.stage.removeChildren();

    this._startPoint = new Point(0, 0);
    this._goalPoint = new Point(COLS - 1, ROWS - 1);

    for (int row = 0; row < ROWS; row++) {
      List<Tile> tileRow = new List<Tile>(COLS);
      this._tileGrid.add(tileRow);
      for (int col = 0; col < COLS; col++) {
        Point location = new Point(col, row);
        if (location == this._startPoint) {
          this._addTileAt(location, TileType.Start);
        } else if (location == this._goalPoint) {
          this._addTileAt(location, TileType.Goal);
        } else {
          this._addTileAt(location, TileType.Empty);
        }
      }
    }
  }

  void _drawPath() {
    List<List<bool>> boolGrid = new List<List<bool>>();
    for (int row = 0; row < ROWS; row++) {
      List<bool> boolRow = new List<bool>(COLS);
      for (int col = 0; col < COLS; col++) {
        if (this._tileGrid[row][col].getType() == TileType.Wall) {
          boolRow[col] = false;
        } else {
          boolRow[col] = true;
        }
      }
      boolGrid.add(boolRow);
    }

    Grid grid = new Grid(boolGrid);
    grid.diagonalMovement = this._diagonalMovement;

    Finder finder;
    switch (this._algorithm) {
      case Algorithm.AStar:
        finder = new AStarFinder(grid);
        break;
      case Algorithm.Dijkstra:
        finder = new DijkstraFinder(grid);
        break;
    }

    PointNode startNode = new PointNode(this._startPoint);
    PointNode goalNode = new PointNode(this._goalPoint);

    List<PointNode> path = finder.pathFind(startNode, goalNode); 

    if (this.stage.children.contains(this._pathLine)) {
      this.stage.removeChild(this._pathLine);
    }

    this._pathLine = new Shape();
    _pathLine.graphics.beginPath();
    for (PointNode pointNode in path) {
      Point scaledPoint = pointNode.location * TILE_SIZE;
      _pathLine.graphics
        .lineTo(scaledPoint.x + TILE_SIZE / 2, scaledPoint.y + TILE_SIZE / 2);
    }
    _pathLine.graphics.strokeColor(Color.DarkBlue, 2);
    _pathLine.graphics.closePath();
    this.stage.addChild(_pathLine);
  }

  void onPathFindButtonPressed() {
    _drawPath();
  }

  void onRandomGridButtonPressed() {
    if (this.stage.children.contains(this._pathLine)) {
      this.stage.removeChild(this._pathLine);
    }

    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        TileType existingType = this._tileGrid[row][col].getType();
        if (existingType == TileType.Wall) {
          this._tileGrid[row][col].setType(TileType.Empty);
        } else if (existingType != TileType.Empty) {
          continue; // It must be a Start or Goal, which we don't want to overwrite.
        }

        double chance = this.random.nextDouble();
        if (chance > this.randomSparseness) {
          this._tileGrid[row][col].setType(TileType.Wall);
        }
      }
    }

    _drawPath();
  }

  void _onMouseDown(MouseEvent e) {
    this._mouseIsDown = true;
    if (e.target is Tile) {
      Tile targetTile = e.target as Tile;
      if (targetTile.getType() == TileType.Wall) {
        this._tileDrawingType = TileType.Empty;
      } else if (targetTile.getType() == TileType.Empty) {
        this._tileDrawingType = TileType.Wall;
      } else {
        this._tileDrawingType = targetTile.getType();
      }
    }
  }

  void _onMouseUp(MouseEvent e) {
    this._mouseIsDown = false;
    if (e.target is Tile) {
      Tile targetTile = e.target as Tile;
    }
  }

  void _onMouseMove(MouseEvent e) {
    if (this._mouseIsDown) {
      int row = (e.stageY / TILE_SIZE).toInt();
      int col = (e.stageX / TILE_SIZE).toInt();

      if (this._tileDrawingType == TileType.Wall ||
          this._tileDrawingType == TileType.Empty) {
        if (this._tileGrid[row][col].getType() != TileType.Start &&
            this._tileGrid[row][col].getType() != TileType.Goal) {
          this._tileGrid[row][col].setType(this._tileDrawingType);
        }
      } else {
        Point newPoint = new Point(col, row);
        Point oldPoint = this._tileDrawingType == TileType.Start
          ? this._startPoint : this._goalPoint;

        if (this._tileGrid[newPoint.y][newPoint.x].getType() == TileType.Empty) {
          this._tileGrid[oldPoint.y][oldPoint.x].setType(TileType.Empty);
          oldPoint == this._startPoint ?
            this._startPoint = newPoint : this._goalPoint = newPoint;
          this._tileGrid[newPoint.y][newPoint.x].setType(this._tileDrawingType);
        }
      }
    }
  }

  void selectedAlgorithmChanged() {
    switch (this.selectedAlgorithm) {
      case "aStar":
        this._algorithm = Algorithm.AStar;
        break;
      case "dijkstra":
        this._algorithm = Algorithm.Dijkstra;
        break;
    }
  }

  void selectedDiagonalMovementChanged() {
    switch (this.selectedDiagonalMovement) {
      case "always":
        this._diagonalMovement = DiagonalMovement.Always;
        break;
      case "never":
        this._diagonalMovement = DiagonalMovement.Never;
        break;
      case "withOneObstruction":
        this._diagonalMovement = DiagonalMovement.WithOneObstruction;
        break;
      case "withNoObstructions":
        this._diagonalMovement = DiagonalMovement.WithNoObstructions;
        break;
    }
  }

  void tileSizeExponentChanged() {
    _reset();
  }

  void _addTileAt(Point location, TileType type) {
    Tile tile = new Tile(location, type, this.TILE_SIZE);
    this._tileGrid[location.y][location.x] = tile;
    this.stage.addChild(tile);
  }
}

class Tile extends Sprite {
  TileType _type;
  final Point location;
  final int size;

  void setType(TileType newType) {
    this._type = newType;
    this.graphics.clear();
    this.graphics.beginPath();
    this.graphics
      .rect(1, 1, this.size - 1, this.size - 1);
    this.graphics.strokeColor(Color.Black, 1);
    switch (newType) {
      case TileType.Empty:
        this.graphics.fillColor(Color.White);
        break;
      case TileType.Wall:
        this.graphics.fillColor(Color.Gray);
        break;
      case TileType.Start:
        this.graphics.fillColor(Color.Green);
        break;
      case TileType.Goal:
        this.graphics.fillColor(Color.Red);
        break;
    }
    this.graphics.closePath();
  }

  TileType getType() => this._type;

  Tile(this.location, TileType initialType, this.size) {
    this.setType(initialType);
    this.x = this.location.x * this.size;
    this.y = this.location.y * this.size;
  }
}

enum TileType {
  Empty,
  Wall,
  Start,
  Goal
}

enum Algorithm {
  AStar,
  Dijkstra
}