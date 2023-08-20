import 'package:flutter/material.dart';
import 'package:pakker_player/common/global_constants.dart';
import 'package:pakker_player/screens/widgets/main_game_provider.dart';
import 'package:provider/provider.dart';

class MainGameWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainGameWidgetState();
  }
}

List<int> addedWalls = [
  75,76,77,78,79,80,81,82,90,91,92,93,94,95,96,97,98,99,
  500,501,502,503,504,520,521,522,523,524,525,12,62,87,
  112,137,157,158,159,160,161,162,163,164,165,166,167,
    230,231,232,233,234,235,236,237,238,239,240,241,242,243,244,
    705,706,707,708,709,710,711,712,713,714,715,716,717,718,719,720,737,
    887,862,837,812,787,762,612,637,587,562,537,512,487,462,437,412,
    387,362,337,312
];

class _MainGameWidgetState extends State<MainGameWidget> {
  @override
  void initState() {
    MainGameProvider.mInstance.createBasicGrid();
    MainGameProvider.mInstance.addWalls(addedWalls);
    MainGameProvider.mInstance.addCoins();
    MainGameProvider.mInstance.startEnemyMovement();
    MainGameProvider.mInstance.startPakMovement();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<MainGameProvider>(
        builder: (context, mainGameProvider, child) => Container(
            padding: EdgeInsets.all(1),
            color: Colors.black,
            height: GlobalConstant.getFontSizeForDisplay(860, context),
            child: Stack(
              children: [GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount:
                        GlobalConstant.numberOfBlocksInRow, // Number of columns in the grid
                    crossAxisSpacing: 1.0, // Spacing between columns
                    mainAxisSpacing: 1.0, // Spacing between rows
                  ),
                  itemCount: GlobalConstant.totalNumberOfBlocks, // Total number of items in the grid
                  itemBuilder: (context, index) {
                    int row = index ~/ mainGameProvider.gameMatrix[0].length;
                    int col = index % mainGameProvider.gameMatrix[0].length;
                    if (mainGameProvider.gameMatrix[row][col] == -1) {
                      return Container(
                        color: Colors.blue,
                        child: Center(
                          child: Text(
                            '${index}', // Display numbers from 1 to 20
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 5.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    } else {
                      if (mainGameProvider.pacPosition[0] == row &&
                          mainGameProvider.pacPosition[1] == col) {
                        print("pacpostion drawing--$row--$col");
                        if(mainGameProvider.redEnemy.currentPosition![0] == row &&
                            mainGameProvider.redEnemy.currentPosition![1] == col){
                            mainGameProvider.gameOver();
                            return CircleAvatar(
                              radius: 30,
                              backgroundColor: Colors.white,
                            );

                        }
                        else{
                          return CircleAvatar(
                            radius: 10,
                            backgroundColor: Colors.purpleAccent,
                          );
                        }

                      } else {
                          return Stack(children: [

                            mainGameProvider.gameMatrix[row][col] == 1
                                ? Center(
                                  child: CircleAvatar(
                                      radius: 3,
                                      backgroundColor: Colors.yellowAccent,
                                    ),
                                )
                                : Container(
                                    color: Colors.black,
                                    child: Center(
                                      child: Text(
                                        '${index}', // Display numbers from 1 to 20
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 5.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),Visibility(
                              visible: mainGameProvider.redEnemy.currentPosition![0] == row &&
                                  mainGameProvider.redEnemy.currentPosition![1] == col,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.red,
                              ),
                            ),Visibility(
                              visible: mainGameProvider.orangeEnemy.currentPosition![0] == row &&
                                  mainGameProvider.orangeEnemy.currentPosition![1] == col,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.orangeAccent,
                              ),
                            ),Visibility(
                              visible: mainGameProvider.pinkEnemy.currentPosition![0] == row &&
                                  mainGameProvider.pinkEnemy.currentPosition![1] == col,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.green,
                              ),
                            ),
                            Visibility(
                              visible: mainGameProvider.blueEnemy.currentPosition![0] == row &&
                                  mainGameProvider.blueEnemy.currentPosition![1] == col,
                              child: CircleAvatar(
                                radius: 10,
                                backgroundColor: Colors.blueAccent,
                              ),
                            ),
                          ]);

                      }
                    }
                  }
                  //   if (mainGameProvider.gameWalls.contains(index)) {
                  //     return Container(
                  //       color: Colors.blue,
                  //       child: Center(
                  //         child: Text(
                  //           '${index}', // Display numbers from 1 to 20
                  //           style: TextStyle(
                  //             color: Colors.white,
                  //             fontSize: 5.0,
                  //             fontWeight: FontWeight.bold,
                  //           ),
                  //         ),
                  //       ),
                  //     );
                  //   }
                  //   else {
                  //     if(mainGameProvider.pacplayerPosition==index){
                  //       return CircleAvatar(
                  //         radius: 10,
                  //         backgroundColor: Colors.purpleAccent,
                  //       );
                  //
                  //     }
                  //     else{
                  //       return Container(
                  //         color: Colors.black,
                  //         child: Center(
                  //           child: Text(
                  //             '${index}', // Display numbers from 1 to 20
                  //             style: TextStyle(
                  //               color: Colors.white,
                  //               fontSize: 5.0,
                  //               fontWeight: FontWeight.bold,
                  //             ),
                  //           ),
                  //         ),
                  //       );
                  //     }
                  //
                  //   }
                  ),
                Visibility(
                  visible: mainGameProvider.isGameOverWindowShown,
                    child:AlertDialog(
                            backgroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                                side: BorderSide(color: Colors.white70,width: 0.5)
                            ),
                            title: Center(child: const Text("Game Over",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 22,
                                color: Colors.red,
                              ),)),
                            content: Column(
                              children: [
                                Center(child: Text(
                                    "Score : ${mainGameProvider.currentScore}"
                                ),),InkWell(
                                  onTap:() => mainGameProvider.restartGame(addedWalls),
                                  child: Container(color: Colors.green,child: Text("Play Again",
                                    style: TextStyle(color: Colors.white),
                                  ),),),
                              ],
                            )
                        ),
                    )
              ],
            )));
  }
}
