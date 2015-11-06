import 'dart:html';
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

  Point startPoint = new Point(5, 10);
  Point goalPoint = new Point(15, 10);

  @observable final int DISPLAY_WIDTH = WIDTH;
  @observable final int DISPLAY_HEIGHT = HEIGHT;

  final random = new Random();

  // StageXL Variables
  Stage stage = null;
  RenderLoop renderLoop = null;

  PathFindingDemoElement.created() : super.created() {
    StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
    CanvasElement canvas = shadowRoot.query('#stage');
    this.stage = new Stage(canvas);
    this.renderLoop = new RenderLoop();
    this.renderLoop.addStage(stage);

    _reset();
  }

  void _reset() {
    this.stage.removeChildren();

    for (int row = 0; row < ROWS; row++) {
      for (int col = 0; col < COLS; col++) {
        this._addTileAt(row, col, TileType.Empty);
      }
    }
  }

  void onShowNextMoveButtonPressed() {

  }

  void _addTileAt(int row, int col, TileType type) {
    this.stage.addChild(
        new Tile(type)
        ..x = col * TILE_SIZE
        ..y = row * TILE_SIZE
                        );
  }
}

class Tile extends Sprite {
  TileType _type;

  void setType(TileType newType) {
    this._type = newType;
    this.graphics.clear();
    this.graphics.beginPath();
    this.graphics
      .rect(0, 0, PathFindingDemoElement.TILE_SIZE,
          PathFindingDemoElement.TILE_SIZE);
    this.graphics.strokeColor(Color.Black, 2);
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

  void getType() => this._type;

  Tile(TileType initialType) {
    this.setType(initialType);
  }
}

enum TileType {
  Empty,
  Wall,
  Start,
  Goal
}