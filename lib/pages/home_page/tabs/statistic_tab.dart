import 'package:fl_animated_linechart/chart/animated_line_chart.dart';
import 'package:fl_animated_linechart/chart/line_chart.dart';
import 'package:flutter/material.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/screen.dart';

class StatisticTab extends StatefulWidget {
  @override
  _StatisticTabState createState() => _StatisticTabState();
}

List<Map<DateTime, double>> createLineAlmostSaveValues() {
  List<Map<DateTime, double>> data = [];
  data.add({DateTime.now().subtract(Duration(minutes: 40)): 25.0});
  data.add({DateTime.now().subtract(Duration(minutes: 50)): 30.0});

  return data;
}

class _StatisticTabState extends State<StatisticTab> {
  @override
  Widget build(BuildContext context) {
    List<Map<DateTime, double>> data = createLineAlmostSaveValues();

    LineChart lineChart = LineChart.fromDateTimeMaps(data, [
      Colors.green,
      Colors.blue,
    ], [
      'unut1',
      'unut2',
    ]);

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
              Expanded(child: AnimatedLineChart(lineChart)),
            ]),
      ),
    );
  }
}
