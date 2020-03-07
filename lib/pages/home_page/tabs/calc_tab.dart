import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/my_simple_dialog.dart';
import 'package:safe_money/helpers/screen.dart';
import 'package:safe_money/providers/goal_provider.dart';

class CalcTab extends StatefulWidget {
  @override
  _CalcTabState createState() => _CalcTabState();
}

class _CalcTabState extends State<CalcTab> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: MyColors.color1,
        body: Consumer<GoalProvider>(
          builder: (context, goalProvider, _) {
            return SingleChildScrollView(
              child: Container(
                child: Column(
                  children: [
                    SizedBox(height: 12),
                    Text(
                      goalProvider.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 50),
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text(
                        'ВЛОЖЕНО:      ',
                        style: TextStyle(fontSize: 18),
                      ),
                      Text(
                        goalProvider.haveSum.toString(),
                        style: TextStyle(fontSize: 18),
                      )
                    ]),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'ОСТАЛОСЬ:     ',
                          style: TextStyle(fontSize: 18),
                        ),
                        Text(
                          goalProvider.needSum.toString(),
                          style: TextStyle(fontSize: 18),
                        ),
                      ],
                    ),
                    SizedBox(height: 25),
                    Container(
                      width: Screen.width(context) * 0.7,
                      height: Screen.heigth(context) * 0.56,
                      color: MyColors.color3,
                      child: SingleChildScrollView(
                        child: Column(
                            children: goalProvider.transations.length != 0
                                ? List<Widget>.generate(
                                    goalProvider.transations.length,
                                    (index) {
                                      return ListTile(
                                        leading: goalProvider.transations[index]
                                                    ['type'] ==
                                                "+"
                                            ? Icon(Icons.arrow_downward)
                                            : Icon(Icons.arrow_upward),
                                        title: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                  '${goalProvider.transations[index]['date']}'),
                                              Text(
                                                  '${goalProvider.transations[index]['sum']} сом'),
                                            ]),
                                        subtitle: Text(goalProvider
                                            .transations[index]['time']),
                                      );
                                    },
                                  )
                                : [Text('НЕТ ОПЕРАЦИЙ')]),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        floatingActionButton: FloatingActionRow(
          color: MyColors.color4,
          children: [
            FloatingActionRowButton(
              icon: Icon(Icons.add),
              onTap: () => showMyDialog(context, 'положить деньги', 'ок',
                  'отмена', '+', _scaffoldKey),
            ),
            FloatingActionRowButton(
              icon: Icon(Icons.remove),
              onTap: () => showMyDialog(
                  context, 'взять деньги', 'ок', 'отмена', '-', _scaffoldKey),
            ),
          ],
        ));
  }
}
