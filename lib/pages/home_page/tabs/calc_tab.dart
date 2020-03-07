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
                    SizedBox(height: 60),
                    Padding(
                      padding: const EdgeInsets.only(left: 30),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              Text(
                                'ВАША ЦЕЛЬ:    ' + goalProvider.name,
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 5),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Text(
                                  'ВЛОЖЕНО:       ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  goalProvider.haveSum.toString(),
                                  style: TextStyle(fontSize: 18),
                                )
                              ]),
                          SizedBox(height: 5),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                        ],
                      ),
                    ),
                    SizedBox(height: 40),
                    Container(
                      decoration: BoxDecoration(
                        color: MyColors.color3,
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(20.0),
                          topRight: const Radius.circular(20.0),
                        ),
                      ),
                      width: Screen.width(context) * 0.7,
                      height: Screen.heigth(context) * 0.56,
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
                                            ? Icon(
                                                Icons.arrow_downward,
                                                color: Colors.green,
                                              )
                                            : Icon(
                                                Icons.arrow_upward,
                                                color: Colors.red,
                                              ),
                                        title: Wrap(
                                            alignment:
                                                WrapAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                '${goalProvider.transations[index]['date']}',
                                                style: TextStyle(
                                                  color: MyColors.color4,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              Text(
                                                '${goalProvider.transations[index]['type']}${goalProvider.transations[index]['sum']} сом',
                                                style: TextStyle(
                                                  color: MyColors.color4,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ]),
                                        subtitle: Text(
                                          goalProvider.transations[index]
                                              ['time'],
                                          style: TextStyle(
                                            color: MyColors.color4,
                                            fontStyle: FontStyle.italic,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
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
            FloatingActionRowButton(
              icon: Icon(Icons.local_dining),
              onTap: () =>
                  Provider.of<GoalProvider>(context, listen: false).initData(),
            ),
          ],
        ));
  }
}
