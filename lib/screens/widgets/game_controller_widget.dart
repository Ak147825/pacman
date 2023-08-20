
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pakker_player/screens/widgets/main_game_provider.dart';
import 'package:provider/provider.dart';

class GameControllerWidget extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return _GameControllerWidgetState();
  }
}
class _GameControllerWidgetState extends State<GameControllerWidget>{
  @override
  Widget build(BuildContext context) {
    return Consumer<MainGameProvider>(
        builder: (context, mainGameProvider, child) => Container(
      child: Column(
        children: [
          InkWell(
              onTap:() =>mainGameProvider.continueUp(),
              child: Icon(Icons.keyboard_arrow_up)),
          Row(
            mainAxisAlignment:MainAxisAlignment.spaceAround,
            children: [
            InkWell(
                onTap:() =>mainGameProvider.continueLeft(),
                child: Icon(Icons.keyboard_arrow_left)),
            InkWell(
                onTap:() =>mainGameProvider.continueRight(),
                child: Icon(Icons.keyboard_arrow_right)),
          ],),
          InkWell(
              onTap:() =>mainGameProvider.continueDown(),
              child: Icon(Icons.keyboard_arrow_down)),
        ],
      )
    )
    );
  }
}