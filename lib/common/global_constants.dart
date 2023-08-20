import 'package:flutter/material.dart';

class GlobalConstant {

  static double getFontSizeForDisplay(int value,BuildContext context) {
    double size = 0;
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      size = MediaQuery.of(context).size.height;
    } else {
      size = MediaQuery.of(context).size.width;
    }

    return size*value/600;
  }

  static int numberOfBlocksInRow=25;
  static int lastBlocksInRow=numberOfBlocksInRow-1;

  static int totalNumberOfBlocks=900;
  static List<int> basicwWalls=[];



}