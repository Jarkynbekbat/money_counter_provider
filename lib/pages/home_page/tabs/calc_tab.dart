import 'dart:convert';

import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/my_simple_dialog.dart';
import 'package:safe_money/helpers/screen.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'package:safe_money/services/local_goal_service.dart';

class CalcTab extends StatefulWidget {
  @override
  _CalcTabState createState() => _CalcTabState();
}

class _CalcTabState extends State<CalcTab> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: MyColors.color1,
        body: Consumer<GoalProvider>(
          builder: (context, goalProvider, _) {
            return FutureBuilder(
              future: LocalGoalService.getGoal(),
              initialData: 'цель',
              builder: (BuildContext contex, data) {
                if (data.hasData) {
                  return SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(height: 12),
                          Text(
                            json.decode(data.data)['name'],
                            style: TextStyle(fontSize: 20),
                          ),
                          SizedBox(height: 50),
                          Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'ВЛОЖЕНО:      ',
                                  style: TextStyle(fontSize: 18),
                                ),
                                Text(
                                  json.decode(data.data)['haveSum'].toString(),
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
                                json.decode(data.data)['needSum'].toString(),
                                style: TextStyle(fontSize: 18),
                              ),
                            ],
                          ),
                          SizedBox(height: 25),
                          Container(
                            width: Screen.width(context) * 0.7,
                            height: Screen.heigth(context) * 0.56,
                            color: MyColors.color2,
                            child: SingleChildScrollView(
                              child: Column(
                                children: List<Widget>.generate(
                                  goalProvider.transations.length,
                                  (index) {
                                    return ListTile(
                                      leading: Icon(Icons.arrow_downward),
                                      title: Text(
                                          '${goalProvider.transations[index]['datetime']}   ${goalProvider.transations[index]['sum']} сом'),
                                      subtitle: Text('11:08'),
                                    );
                                  },
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else {
                  return CircularProgressIndicator();
                }
              },
            );
          },
        ),
        floatingActionButton: FloatingActionRow(
          color: MyColors.color4,
          children: [
            FloatingActionRowButton(
              icon: Icon(Icons.add),
              onTap: () {
                showMyDialog(context, 'положить деньги', 'ок', 'отмена', '+');
              },
            ),
            FloatingActionRowButton(
              icon: Icon(Icons.remove),
              onTap: () {},
            ),
          ],
        ));
  }
}
