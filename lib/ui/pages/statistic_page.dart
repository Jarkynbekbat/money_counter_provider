import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:safe_money/providers/goal_provider.dart';

class StatisticPage extends StatelessWidget {
  static String route = 'statistic';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      body: Container(
        // padding: EdgeInsets.all(12.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              leading: FutureBuilder(
                  future: Provider.of<GoalProvider>(context, listen: false)
                      .getAverageSumPerDay(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text(
                        snapshot.data.toString(),
                        style: statisticCountStyle,
                      );
                    } else {
                      return CircularProgressIndicator();
                    }
                  }),
              title: Text(
                'средний вклад в день',
                style: textStyle,
              ),
            ),
            ListTile(
              leading: FutureBuilder(
                future: Provider.of<GoalProvider>(context, listen: false)
                    .getDaysCountBeforeGoal(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    if (snapshot.data != 0) {
                      return Text(
                        snapshot.data.toString(),
                        style: statisticCountStyle,
                      );
                    } else {
                      return Icon(Icons.all_inclusive, color: Colors.red);
                    }
                  } else {
                    return CircularProgressIndicator();
                  }
                },
              ),
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
