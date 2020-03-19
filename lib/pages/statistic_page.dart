import 'package:flutter/material.dart';

class StatisticPage extends StatefulWidget {
  static String route = 'statistic';

  @override
  _StatisticPageState createState() => _StatisticPageState();
}

class _StatisticPageState extends State<StatisticPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Статистика'),
      ),
      // TODO сделать вывод - средний вклад в день
      // TODO сделать вывод - количество дней до достижения цели в таком темпе
      // TODO сделать вывод - количество месяцев до достижения  цели в таком темпе

      body: Container(),
    );
  }
}
