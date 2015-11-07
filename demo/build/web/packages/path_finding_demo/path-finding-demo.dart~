import 'dart:html';
import 'package:stagexl/stagexl.dart';
import 'package:polymer/polymer.dart';
import 'dart:math';
import 'dart:async';
import 'dart:collection';

import 'package:towers_of_hanoi/solvers.dart';

class Tower extends Sprite {
  final int center;
  final Queue<Shape> disks = new Queue<Shape>();

  Tower(this.center) {
    this.graphics.beginPath();
    this.graphics.rect(center - 20, TowersOfHanoiElement.HEIGHT * .2, 40, TowersOfHanoiElement.HEIGHT * .8);
    this.graphics.fillColor(Color.Brown);
    this.graphics.strokeColor(Color.Brown, 1);
    this.graphics.closePath();
  }

  void removeDisks() {
    for (int i = 0; i < disks.length; i++) {
      disks.elementAt(i).removeFromParent();
    }
    disks.clear();
  }
}

@CustomTag('towers-of-hanoi')
class TowersOfHanoiElement extends PolymerElement {
  static final int WIDTH = 1000;
  static final int HEIGHT = 600;

  @observable final int DISPLAY_WIDTH = WIDTH;
  @observable final int DISPLAY_HEIGHT = HEIGHT;

  static final int MAX_DISK_WIDTH = (WIDTH / 4.0).toInt();
  double MAX_DISK_HEIGHT = 0.0;

  @observable int numberOfDisks = 5;
  @observable double movesPerSecond = 1.0;
  @observable int steps = 0;
  @observable bool playing = false;

  List<Tower> towers = [
    new Tower(((WIDTH / 4.0) * 1).toInt()),
    new Tower(((WIDTH / 4.0) * 2).toInt()),  
    new Tower(((WIDTH / 4.0) * 3).toInt())
  ];

  final random = new Random();

  List<Move> _moves = [];

  // StageXL Variables
  Stage stage = null;
  RenderLoop renderLoop = null;

  TowersOfHanoiElement.created() : super.created() {
    StageXL.stageOptions.renderEngine = RenderEngine.Canvas2D;
    CanvasElement canvas = shadowRoot.query('#stage');
    this.stage = new Stage(canvas);
    this.renderLoop = new RenderLoop();
    this.renderLoop.addStage(stage);

    for (Tower tower in this.towers) {
      this.stage.addChild(tower);
    }

    _reset();
  }

  void _reset() async {
    this.renderLoop.juggler.clear();
    this._moves = [];
    this.steps = 0;
    this.MAX_DISK_HEIGHT = (HEIGHT * .8) / this.numberOfDisks;

    for (Tower tower in this.towers) {
      tower.removeDisks();
    }

    _initDisks();

    this._moves = await getMovesRecursive(this.numberOfDisks);
  }

  void numberOfDisksChanged() async {
    this.playing = false;
    await _reset();
  }

  void onTogglePlayingButtonPressed() async {
    await _reset();
    playing = !playing;

    if (playing) {
      void animateNextMove() {
        if (this._moves.isEmpty) {
          this.playing = false;
          return;
        } 

        Move move = this._moves.removeAt(0);

        Shape disk = towers[move.from].disks.removeLast();
        towers[move.to].disks.addLast(disk);

        Tween tween = new Tween(disk, 1 / this.movesPerSecond, Transition.linear);
        tween.animate.x.to(towers[move.to].center);
        tween.animate.y.to(HEIGHT - MAX_DISK_HEIGHT * (towers[move.to].disks.length - 1));
        tween.onComplete = () {
          this.steps++;
          animateNextMove();
        };

        this.renderLoop.juggler.add(tween);
      }

      animateNextMove();
    } else {
      this.renderLoop.juggler.clear();
    }
  }

  void onShowNextMoveButtonPressed() {
    showNextMove();
  }

  void showNextMove() {
    if (this._moves.isEmpty) {
      return;
    }

    Move move = this._moves.removeAt(0);

    Shape disk = towers[move.from].disks.removeLast();
    towers[move.to].disks.addLast(disk);

    disk.x = towers[move.to].center;
    disk.y = HEIGHT - MAX_DISK_HEIGHT * (towers[move.to].disks.length-1);

    this.steps++;
  }

  void _initDisks() {
    for (int i = 0; i < numberOfDisks; i++) {
      int size = numberOfDisks - i;
      int diskWidth = (MAX_DISK_WIDTH * (size / numberOfDisks)).toInt();

      Shape disk = new Shape()
        ..graphics.beginPath()
        ..graphics.rect(-diskWidth / 2, -MAX_DISK_HEIGHT/ 2, diskWidth, MAX_DISK_HEIGHT)
        ..graphics.strokeColor(Color.Black, 1)
        ..graphics.fillColor(Color.BlanchedAlmond)
        ..graphics.closePath()
        ..pivotY = MAX_DISK_HEIGHT / 2;

      disk.x = towers[0].center;
      disk.y = HEIGHT - MAX_DISK_HEIGHT * i;

      towers[0].disks.addLast(disk);
      this.stage.addChild(disk);
    }
  }
}