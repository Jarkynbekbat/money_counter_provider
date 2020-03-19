import 'package:easy_dialog/easy_dialog.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/my_simple_dialog.dart';
import 'package:safe_money/pages/auth_page.dart';
import 'package:safe_money/pages/statistic_page.dart';
import 'package:safe_money/providers/goal_provider.dart';

class HomePage extends StatefulWidget {
  static String route = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Мой учет'),
        centerTitle: true,
        backgroundColor: MyColors.color3,
        actions: [
          IconButton(
            icon: Icon(Icons.insert_chart),
            onPressed: () async {
              //TODO сделать дизайн экрана статистики
              Navigator.pushNamed(context, StatisticPage.route);
            },
          ),
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () async {
              await EasyDialog(
                  title: Text('Вы уверены что хотите прервать учет ?'),
                  height: 200,
                  closeButton: false,
                  contentList: [
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        'да,прервать',
                      ),
                      onPressed: () {
                        // TODO - исправить проблему с страрыми данными после выхода
                        Provider.of<GoalProvider>(context, listen: false)
                            .logout();
                        Navigator.of(context).popAndPushNamed(AuthPage.route);
                      },
                    ),
                    OutlineButton(
                      shape: RoundedRectangleBorder(
                          borderRadius: new BorderRadius.circular(30.0)),
                      child: Text(
                        'нет,вернуться',
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ]).show(context);
            },
          ),
        ],
      ),
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, _) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 10.0,
                        animation: true,
                        header: Text(
                          "Накоплено",
                          style: textStyle,
                        ),
                        percent: (goalProvider.precent / 100),
                        center: Text(
                            "${goalProvider.precent.toStringAsFixed(1)}%",
                            style: textStyle),
                        footer: Text(
                          '${goalProvider.haveSum} ',
                          style: textStyle,
                        ),
                        progressColor: Colors.green,
                      ),
                      CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 10.0,
                        animation: true,
                        header: Text(
                          "Осталось",
                          style: textStyle,
                        ),
                        percent: 1 - (goalProvider.precent / 100),
                        center: Text(
                            "${(100 - goalProvider.precent).toStringAsFixed(1)}%",
                            style: textStyle),
                        footer: Text(
                          '${goalProvider.goalSum - goalProvider.haveSum} ',
                          style: textStyle,
                        ),
                        progressColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: roundedContainerDecoration.copyWith(
                      color: MyColors.color3,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.flag,
                            color: Colors.lightGreen,
                          ),
                          title: Text(
                            '${goalProvider.name}',
                            style: textStyle.copyWith(
                              color: MyColors.color1,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.lightGreen,
                          ),
                          title: Text(
                            '${goalProvider.goalSum} ',
                            style: textStyle.copyWith(
                              color: MyColors.color1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: MyColors.color3,
                    child: Container(
                      decoration: roundedContainerDecoration.copyWith(
                        color: Colors.white,
                      ),
                      child: ListView.builder(
                        reverse: true,
                        itemCount: goalProvider.transations.length,
                        itemBuilder: (context, index) {
                          return Dismissible(
                            key: Key(
                                goalProvider.transations[index]['datetime']),
                            onDismissed: (key) async {
                              await goalProvider.cancelTransaction(
                                  goalProvider.transations[index]);
                            },
                            child: ListTile(
                              leading:
                                  goalProvider.transations[index]['type'] == "+"
                                      ? Icon(
                                          Icons.arrow_downward,
                                          color: Colors.green,
                                        )
                                      : Icon(
                                          Icons.arrow_upward,
                                          color: Colors.red,
                                        ),
                              title: Text(
                                '${goalProvider.transations[index]['date']}',
                                style: TextStyle(
                                  color: Colors.black87,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text(
                                goalProvider.transations[index]['time'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                '${goalProvider.transations[index]['type']}${goalProvider.transations[index]['sum']} ',
                                style: textStyle.copyWith(
                                  color: goalProvider.transations[index]
                                              ['type'] ==
                                          '+'
                                      ? Colors.green
                                      : Colors.red,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionRow(
        color: MyColors.color3,
        children: [
          FloatingActionRowButton(
            icon: Icon(Icons.add),
            onTap: () => showMyDialog(
                context, 'положить деньги', 'ок', 'отмена', '+', _scaffoldKey),
          ),
          FloatingActionRowButton(
            icon: Icon(Icons.remove),
            onTap: () => showMyDialog(
                context, 'взять деньги', 'ок', 'отмена', '-', _scaffoldKey),
          ),
        ],
      ),
    );
  }
}
