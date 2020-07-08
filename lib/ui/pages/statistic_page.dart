import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../data/models/page_models/statistic_screen_model.dart';
import '../../providers/goal_provider.dart';

class StatisticPage extends StatelessWidget {
  static String route = 'statistic';

  @override
  Widget build(BuildContext context) {
    const statisticCountStyle = TextStyle(
      fontSize: 25.0,
      color: Colors.green,
      fontWeight: FontWeight.bold,
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('Статистика'),
      ),
      body: Container(
        // padding: EdgeInsets.all(12.0),
        child: FutureBuilder<StatisticScreenModel>(
          future: Provider.of<GoalProvider>(context, listen: false)
              .getStatisticData(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return ListView(
                children: <Widget>[
                  ListTile(
                    leading: Text(
                      snapshot.data.averageSumPerDay.toStringAsFixed(1),
                      style: statisticCountStyle,
                    ),
                    title: const Text('средний вклад в день'),
                  ),
                  const Divider(),
                  const Text(
                    '* До достижения цели в таком темпе',
                    style:
                        TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const Divider(),
                  if (snapshot.data.years != 0)
                    ListTile(
                      leading: Text(
                        snapshot.data.years.toString(),
                        style: statisticCountStyle,
                      ),
                      title: Text('количество лет'),
                    ),
                  if (snapshot.data.months != 0)
                    ListTile(
                      leading: Text(
                        snapshot.data.months.toString(),
                        style: statisticCountStyle,
                      ),
                      title: Text('количество месяцев'),
                    ),
                  ListTile(
                    leading: snapshot.data.days == 0
                        ? Icon(Icons.all_inclusive, color: Colors.red)
                        : Text(
                            snapshot.data.days.toString(),
                            style: statisticCountStyle,
                          ),
                    title: Text('количество дней'),
                  ),

                  // return
                ],
              );
            }
            return CircularProgressIndicator();
          },
        ),
      ),
    );
  }
}
