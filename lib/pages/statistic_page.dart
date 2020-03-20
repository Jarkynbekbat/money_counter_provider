import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:safe_money/providers/goal_provider.dart';

class StatisticPage extends StatelessWidget {
  static String route = 'statistic';
  @override
  Widget build(BuildContext context) {
    double averageSumPerDay =
        Provider.of<GoalProvider>(context, listen: false).getAverageSumPerDay();
    int daysCount = Provider.of<GoalProvider>(context, listen: false)
        .getDaysCountBeforeGoal();

    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: Container(
        // padding: EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: Text(
                '$averageSumPerDay',
                style: statisticCountStyle,
              ),
              title: Text(
                'средний вклад в день',
                style: textStyle,
              ),
            ),
            ListTile(
              leading: daysCount != 0
                  ? Text('$daysCount', style: statisticCountStyle)
                  : Icon(Icons.all_inclusive, color: Colors.red),
              title: Text(
                'количество дней до достижения цели в таком темпе',
                style: textStyle,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
