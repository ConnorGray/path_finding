import 'dart:html' as html;
import 'dart:math' show Random, Point;

import 'package:stagexl/stagexl.dart' hide Point;
import 'package:polymer/polymer.dart';
import 'package:path_finding/path_finding.dart';

@CustomTag('path-finding-demo')
class PathFindingDemoElement extends PolymerElement {
  static final int WIDTH = 640;
  static final int HEIGHT = 640;
  static final int TILE_SIZE = 32;
  static final int ROWS = 20;
  static final int COLS = 20;

  @observable final int DISPLAY_WIDTH = WIDTH;
  @observable final int DISPLAY_HEIGHT = HEIGHT;

  @observable String selectedAlgorithm = "aStar";
  @observable String selectedDiagonalMovement = "withOneObstruction";

  Algorithm _algorithm = Algorithm.AStar;
  DiagonalMovement _diagonalMovement = DiagonalMovement.WithOneObstruction;

  final List<List<Tile>> _tileGrid = new List<List<Tile>>();

  Point _startPoint = new Point(5, 10);
  Point _goalPoint = new Point(15, 10);
  Shape _pathLine = new Shape();

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

    this.stage.addChild(this._pathLine);

    _reset();
  }

  void _reset() {
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

  void onPathFindButtonPressed() {
    this.stage.removeChild(this._pathLine);

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
      } else if (this._tileDrawingType == TileType.Start) {
        Point newStart = new Point(col, row);
        if (newStart != this._startPoint && newStart != this._goalPoint) {
          this._tileGrid[this._startPoint.y][this._startPoint.x]
            .setType(TileType.Empty);
          this._startPoint = newStart;
          this._tileGrid[newStart.y][newStart.x].setType(TileType.Start);
        }
      } else if (this._tileDrawingType == TileType.Goal) {
        Point newGoal = new Point(col, row);
        if (newGoal != this._goalPoint && newGoal != this._startPoint) {
          this._tileGrid[this._goalPoint.y][this._goalPoint.x]
            .setType(TileType.Empty);
          this._goalPoint = newGoal;
          this._tileGrid[newGoal.y][newGoal.x].setType(TileType.Goal);
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
    print(this._algorithm);
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
    print(this._diagonalMovement);
  }

  void _addTileAt(Point location, TileType type) {
    Tile tile = new Tile(location, type);
    this._tileGrid[location.y][location.x] = tile;
    this.stage.addChild(tile);
  }
}

class Tile extends Sprite {
  TileType _type;
  final Point location;

  void setType(TileType newType) {
    this._type = newType;
    this.graphics.clear();
    this.graphics.beginPath();
    this.graphics
      .rect(1, 1, PathFindingDemoElement.TILE_SIZE - 1,
          PathFindingDemoElement.TILE_SIZE - 1);
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

  Tile(this.location, TileType initialType) {
    this.setType(initialType);
    this.x = this.location.x * PathFindingDemoElement.TILE_SIZE;
    this.y = this.location.y * PathFindingDemoElement.TILE_SIZE;
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