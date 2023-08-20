import 'package:flutter/material.dart';
import 'package:pakker_player/screens/widgets/game_controller_widget.dart';
import 'package:pakker_player/screens/widgets/main_game_provider.dart';
import 'package:pakker_player/screens/widgets/main_game_widget.dart';
import 'package:provider/provider.dart';


class GamePage extends StatefulWidget{

  @override
  State<StatefulWidget> createState() => _GamePageState();

}

class _GamePageState extends State<GamePage>{

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: Consumer<MainGameProvider>(
        builder: (context, mainGameProvider, child) => Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Pakker Man"),
            Text("Score ${mainGameProvider.currentScore}")
          ],
        ),),
      ),
      body:
      Column(
        children: [
          MainGameWidget(),
          GameControllerWidget(),
        ],
      ),
    );
  }

}