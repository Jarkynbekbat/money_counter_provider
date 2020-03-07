import 'package:flutter/material.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/screen.dart';

class StatisticTab extends StatefulWidget {
  @override
  _StatisticTabState createState() => _StatisticTabState();
}

class _StatisticTabState extends State<StatisticTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.color1,
      body: Container(
        width: Screen.width(context) * 1,
        height: Screen.heigth(context) * 80,
        child: Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Text('scaasc'),
              ),
            ]),
      ),
    );
  }
}
