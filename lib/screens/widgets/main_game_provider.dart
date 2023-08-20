
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:pakker_player/common/global_constants.dart';
class Enemy{
  int? currentMovementDirection;
  List<int>? currentPosition;
  int? movementTimer;
  Enemy(int currentMovementDirection, List<int> currentPosition, int timer) {
    this.currentMovementDirection=currentMovementDirection;
    this.currentPosition=currentPosition;
    this.movementTimer=timer;

  }
}
class MainGameProvider extends ChangeNotifier{
  static final _mInstance = MainGameProvider._();
  static MainGameProvider get mInstance => _mInstance;

  String TAG="MainGameProvider";
  int pacplayerPosition=26;
  List<int> pacPosition=[1,3];


  Enemy redEnemy= new Enemy(-1, [8,4],600);
  Enemy blueEnemy= new Enemy(1, [25,4],500);
  Enemy pinkEnemy= new Enemy(-2, [25,14],700);
  Enemy orangeEnemy= new Enemy(2, [8,14],500);
  Timer? timer;
  Timer? enemyTimer1;
  Timer? enemyTimer2;
  Timer? enemyTimer3;
  Timer? enemyTimer4;
  int currentScore=1;


  List<List<int>> gameMatrix=[];

  int currentEnemyMovement=-1;//left initially
  //right=+1
  //up=-2
  //down=+2
  int leftMovement=-1;
  int rightMovement=1;
  int upMovement=-2;
  int downMovement=2;

  int wallCode=-1;
  int coinCode=1;
  int blankTileCode=0;

  bool isGameOverWindowShown=false;

  MainGameProvider._() {
    print('${TAG} MainGameProvider....');
  }

  List<int> totalCells = List.generate(GlobalConstant.totalNumberOfBlocks, (index) => index);
  List<int> gameWalls=[];
  List<int> coinsAvailable =[];
   void createBasicGrid(){
     gameMatrix = List.generate(
       GlobalConstant.totalNumberOfBlocks~/GlobalConstant.numberOfBlocksInRow,
           (row) => List<int>.filled(GlobalConstant.numberOfBlocksInRow, 0),
     );

    for(int i=0;i<gameMatrix.length;i++){
      for(int j=0;j<gameMatrix[0].length;j++){
        if(i==0 || i==gameMatrix.length-1 || j==0||j==gameMatrix[0].length-1 ){
          gameMatrix[i][j]=-1;
        }
      }
    }


    for (int i =0;i<GlobalConstant.totalNumberOfBlocks;i++){
      if(i<GlobalConstant.numberOfBlocksInRow){
        gameWalls.add(i);
      }
      else if(i%GlobalConstant.numberOfBlocksInRow==0){
        gameWalls.add(i-1);
        gameWalls.add(i);
      }
      else if(i>(GlobalConstant.totalNumberOfBlocks-GlobalConstant.numberOfBlocksInRow-1)){
        gameWalls.add(i);
      }
    }
  }

  void startPakMovement(){
    timer=Timer.periodic(movementTime, (Timer t) => movePlayerLeft());
  }
  void movePlayerUp(){
     if(gameMatrix[pacPosition[0]-1][pacPosition[1]]!=-1){
       if(gameMatrix[pacPosition[0]-1][pacPosition[1]]==1){
         gameMatrix[pacPosition[0]-1][pacPosition[1]]=0;
         incrementScore();
       }
       pacPosition[0]-=1;
     }
    // if (!gameWalls.contains(pacplayerPosition-GlobalConstant.numberOfBlocksInRow)){
    //   pacplayerPosition=pacplayerPosition-GlobalConstant.numberOfBlocksInRow;
    // }
    notifyListeners();
  }
  void movePlayerDown(){
    if(gameMatrix[pacPosition[0]+1][pacPosition[1]]!=-1){
      if(gameMatrix[pacPosition[0]+1][pacPosition[1]]==1){
        gameMatrix[pacPosition[0]+1][pacPosition[1]]=0;
        incrementScore();
      }
      pacPosition[0]+=1;
    }
    // if (!gameWalls.contains(pacplayerPosition+GlobalConstant.numberOfBlocksInRow)){
    //   pacplayerPosition=pacplayerPosition+GlobalConstant.numberOfBlocksInRow;
    // }
    notifyListeners();
  }
  void movePlayerLeft(){
    if(gameMatrix[pacPosition[0]][pacPosition[1]-1]!=-1){
      if(gameMatrix[pacPosition[0]][pacPosition[1]-1]==1){
        gameMatrix[pacPosition[0]][pacPosition[1]-1]=0;
        incrementScore();
      }
      pacPosition[1]-=1;
    }
    // if (!gameWalls.contains(pacplayerPosition-1)){
    //   pacplayerPosition=pacplayerPosition-1;
    // }
    notifyListeners();
  }
  void movePlayerRight(){
    if(gameMatrix[pacPosition[0]][pacPosition[1]+1]!=-1){
      if(gameMatrix[pacPosition[0]][pacPosition[1]+1]==1){
        gameMatrix[pacPosition[0]][pacPosition[1]+1]=0;
        incrementScore();
      }
      pacPosition[1]+=1;
    }
    // if (!gameWalls.contains(pacplayerPosition+1)){
    //   pacplayerPosition=pacplayerPosition+1;
    // }
    notifyListeners();
  }

  void addWalls(List<int> addedWalls) {
     for (int j in addedWalls){
       int row = j ~/ gameMatrix[0].length;
       int col = j % gameMatrix[0].length;
       gameMatrix[row][col]=-1;
       gameWalls.add(j);
     }
     notifyListeners();
  }
  void addCoins(){
     coinsAvailable=totalCells.where((element) => !gameWalls.contains(element)).toList();
     for (int j in coinsAvailable){
       int row = j ~/ gameMatrix[0].length;
       int col = j % gameMatrix[0].length;
       if(pacPosition[0]!=row || pacPosition[1]!=col){
         gameMatrix[row][col]=1;
       }
     }
  }

  Duration movementTime=Duration(milliseconds: 500);
  Duration enemyMovementTime=Duration(milliseconds: 400);


  void continueLeft(){
    if(timer!=null){
      if(timer!.isActive){
        timer!.cancel();
      }
    }
    timer=
    Timer.periodic(movementTime, (Timer t) => movePlayerLeft());
  }
  void continueRight(){
    if(timer!=null){
      if(timer!.isActive){
        timer!.cancel();
      }
    }
    timer=
        Timer.periodic(movementTime, (Timer t) => movePlayerRight());
  }
  void continueUp(){
    if(timer!=null){
      if(timer!.isActive){
        timer!.cancel();
      }
    }
    timer=
        Timer.periodic(movementTime, (Timer t) => movePlayerUp());
  }
  void continueDown(){
    if(timer!=null){
      if(timer!.isActive){
        timer!.cancel();
      }
    }
    timer=
        Timer.periodic(movementTime, (Timer t) => movePlayerDown());
  }

  void incrementScore(){
    currentScore++;
  }


  void startEnemyMovement(){
    enemyTimer1=
        Timer.periodic(enemyMovementTime, (Timer t) => moveEnemy(blueEnemy));
    enemyTimer2=
        Timer.periodic(enemyMovementTime, (Timer t) => moveEnemy(redEnemy));
    enemyTimer3=
        Timer.periodic(enemyMovementTime, (Timer t) => moveEnemy(pinkEnemy));
    enemyTimer4=
        Timer.periodic(enemyMovementTime, (Timer t) => moveEnemy(orangeEnemy));
  }
  void gameOver(){
    timer!.cancel();
    isGameOverWindowShown=true;
    enemyTimer1!.cancel();
    enemyTimer2!.cancel();
    enemyTimer3!.cancel();
    print("called game over");
    Future.delayed(Duration(milliseconds: 10),(){  notifyListeners();});

  }

  void moveEnemy(Enemy enemy){
      if(enemy.currentMovementDirection==leftMovement){//if current enemy movement is left
        if(!isLeftCellWall(enemy)){//if left cell is not wall
          moveEnemyLeft(enemy);
        }
        else{//but there is wall in left of current cell
          if(isPakPlayerDownward(enemy)){// if pakplayer is in downward direction from this tile
              if(!isDownCellWall(enemy)){//if downward cell is not wall.
                moveEnemyDown(enemy);
              }
              else{//if downward cell is wall
                if(!isUpCellWall(enemy)){//check if upward cell is not wall
                  moveEnemyUp(enemy);
                }
                else{
                  moveEnemyRight(enemy);
                }
              }
          }
          else{
            if(!isUpCellWall(enemy)){//if upward cell is not wall.
              moveEnemyUp(enemy);
            }
            else{//if upward cell is wall
              if(!isDownCellWall(enemy)){//check if downward cell is not wall
                moveEnemyDown(enemy);
              }
              else{
                moveEnemyRight(enemy);
              }
            }
          }
        }
      }
      else if(enemy.currentMovementDirection==rightMovement){
        if(!isRightCellWall(enemy)){//if right cell is not wall
          moveEnemyRight(enemy);
        }
        else{//but there is wall in right of current cell
          if(isPakPlayerDownward(enemy)){// if pakplayer is in downward direction from this tile
            if(!isDownCellWall(enemy)){//if downward cell is not wall.
              moveEnemyDown(enemy);
            }
            else{//if downward cell is wall
              if(!isUpCellWall(enemy)){//check if upward cell is not wall
                moveEnemyUp(enemy);
              }
              else{
                moveEnemyLeft(enemy);
              }
            }
          }
          else{
            if(!isUpCellWall(enemy)){//if upward cell is not wall.
              moveEnemyUp(enemy);
            }
            else{//if upward cell is wall
              if(!isDownCellWall(enemy)){//check if downward cell is not wall
                moveEnemyDown(enemy);
              }
              else{
                moveEnemyLeft(enemy);
              }
            }
          }
        }
      }
      else if(enemy.currentMovementDirection==upMovement){
        if(!isUpCellWall(enemy)){//if right cell is not wall
          moveEnemyUp(enemy);
        }
        else{//but there is wall in up of current cell
          if(isPakPlayerRightward(enemy)){// if pakplayer is in rightward direction from this tile
            if(!isRightCellWall(enemy)){//if rightward cell is not wall.
              moveEnemyRight(enemy);
            }
            else{//if Right cell is wall
              if(!isLeftCellWall(enemy)){//check if leftward cell is not wall
                moveEnemyLeft(enemy);
              }
              else{
                moveEnemyDown(enemy);
              }
            }
          }
          else{
            if(!isLeftCellWall(enemy)){//if left cell is not wall.
              moveEnemyLeft(enemy);
            }
            else{//if leftward cell is wall
              if(!isRightCellWall(enemy)){//check if rightward cell is not wall
                moveEnemyRight(enemy);
              }
              else{
                moveEnemyDown(enemy);
              }
            }
          }
        }
      }
      else{
        if(!isDownCellWall(enemy)){//if down cell is not wall
          moveEnemyDown(enemy);
        }
        else{//but there is wall in down of current cell
          if(isPakPlayerRightward(enemy)){// if pakplayer is in rightward direction from this tile
            if(!isRightCellWall(enemy)){//if rightward cell is not wall.
              moveEnemyRight(enemy);
            }
            else{//if Right cell is wall
              if(!isLeftCellWall(enemy)){//check if leftward cell is not wall
                moveEnemyLeft(enemy);
              }
              else{
                moveEnemyDown(enemy);
              }
            }
          }
          else{
            if(!isLeftCellWall(enemy)){//if left cell is not wall.
              moveEnemyLeft(enemy);
            }
            else{//if leftward cell is wall
              if(!isRightCellWall(enemy)){//check if rightward cell is not wall
                moveEnemyRight(enemy);
              }
              else{
                moveEnemyDown(enemy);
              }
            }
          }
        }
      }
  }
  void moveEnemyLeft(Enemy enemy){
    enemy.currentPosition![1]-=1; //move enemy left
    enemy.currentMovementDirection=leftMovement;
    // currentEnemyMovement=leftMovement;
    notifyListeners();
  }
  void moveEnemyRight(Enemy enemy){
    enemy.currentPosition![1]+=1; //move enemy right
    enemy.currentMovementDirection=rightMovement;
    notifyListeners();
  }
  void moveEnemyUp(Enemy enemy){
    enemy.currentPosition![0]-=1; //move enemy up
    enemy.currentMovementDirection=upMovement;
    notifyListeners();
  }
  void moveEnemyDown(Enemy enemy){
    enemy.currentPosition![0]+=1; //move enemy down
    enemy.currentMovementDirection=downMovement;
    notifyListeners();
  }

  bool isLeftCellWall(Enemy enemy){
    if(gameMatrix[enemy.currentPosition![0]][enemy.currentPosition![1]-1]==wallCode){//if left cell is not wall
      return true;
    }
    return false;
  }
  bool isRightCellWall(Enemy enemy){
    if(gameMatrix[enemy.currentPosition![0]][enemy.currentPosition![1]+1]==wallCode){//if right cell is not wall
      return true;
    }
    return false;
  }
  bool isUpCellWall(Enemy enemy){
    if(gameMatrix[enemy.currentPosition![0]-1][enemy.currentPosition![1]]==wallCode){//if upward cell is not wall
      return true;
    }
    return false;
  }
  bool isDownCellWall(Enemy enemy){
    if(gameMatrix[enemy.currentPosition![0]+1][enemy.currentPosition![1]]==wallCode){//if downward cell is not wall
      return true;
    }
    return false;
  }

  bool isPakPlayerDownward(Enemy enemy){
        if(pacPosition[0]>=enemy.currentPosition![0]){
          return true;
        }
        return false;
  }
  bool isPakPlayerRightward(Enemy enemy){
        if(pacPosition[1]>=enemy.currentPosition![1]){
          return true;
        }
        return false;
  }

  void restartGame(List<int> addedWalls){
    currentScore=0;
    isGameOverWindowShown=false;
    createBasicGrid();
    addWalls(addedWalls);
    addCoins();
    pacPosition=[1,1];
     redEnemy= new Enemy(-1, [8,4],600);
     blueEnemy= new Enemy(1, [25,4],300);
     pinkEnemy= new Enemy(-2, [25,14],400);
     orangeEnemy= new Enemy(2, [8,14],500);
    startEnemyMovement();
    notifyListeners();
  }

}