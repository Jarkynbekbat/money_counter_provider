import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/screen.dart';
import 'package:safe_money/providers/goal_provider.dart';

class StatisticTab extends StatefulWidget {
  @override
  _StatisticTabState createState() => _StatisticTabState();
}

class _StatisticTabState extends State<StatisticTab> {
  DateTime _dateTime;

  @override
  Widget build(BuildContext context) {
    //TODO доделать график фактического и планового
    //TODO добавить фактический ежедневный средний вклад
    //TODO добавить плановый ежедневный средний вклад
    //TODO вы отстаете на х сом от планового графика
    //TODO вы опережаете на х сом  плановый график
    //TODO с таким темпом вы накопите сумму цели через х дней

    //вычисляю график для фактических накоплений
    var transations = Provider.of<GoalProvider>(context).transations;

    Map<DateTime, double> objectFact = {};
    double sumFact = 0;
    transations.forEach((t) {
      sumFact += double.parse(t['sum']);
      objectFact[DateTime.parse(t['datetime'])] = sumFact;
    });

    //вычисляю график для плановых накоплений
    Map<DateTime, double> objectPlan = {};
    double sumPlan = 0;

    if (_dateTime != null) {
      DateTime now = DateTime.now();
      int daysBetween = _dateTime.difference(now).inDays;
      int goalSum = Provider.of<GoalProvider>(context).goalSum;
      double dailySum = goalSum / daysBetween;

      for (int i = 0; i < daysBetween; i++) {
        sumPlan += dailySum;
        objectPlan[now] = sumPlan;
        now = now.add(Duration(days: 1));
      }
    }

    //создаю line chart для фактических и плановых накоплений
    LineChart lineChart = LineChart.fromDateTimeMaps(
      [
        objectFact,
        objectPlan,
      ],
      [
        Colors.green,
        Colors.purple,
      ],
      [
        'ФАКТИЧЕСКИ',
        'ПО ПЛАНУ',
      ],
    );

    return Scaffold(
      backgroundColor: MyColors.color1,
      body: Padding(
        padding: const EdgeInsets.only(top: 15),
        child: Wrap(
          children: [
            Text(
              _dateTime == null
                  ? "выберите планируемую дату"
                  : _dateTime.toString(),
            ),
            RaisedButton(
              child: Text('Выбрать дату'),
              onPressed: () async {
                _dateTime = await showDatePicker(
                    context: context,
                    initialDate: _dateTime == null
                        ? DateTime.now().add(Duration(days: 1))
                        : _dateTime,
                    firstDate: DateTime.now(),
                    lastDate: DateTime(2222));
                setState(() {});
              },
            ),
            Container(
              width: Screen.width(context) * 1,
              height: 300,
              child: Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(child: AnimatedLineChart(lineChart)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
