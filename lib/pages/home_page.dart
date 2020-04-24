import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/my_dialog_for_cancel_transaction.dart';
import 'package:safe_money/helpers/my_simple_dialog.dart';
import 'package:safe_money/pages/components/drawer.dart';
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
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      drawer: MyDrawer(),
      appBar: AppBar(
        title: Text('Мой учет'),
        actions: [],
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
                        lineWidth: 12.0,
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
                        lineWidth: 12.0,
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
                            size: 30.0,
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
                            size: 30.0,
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
                              bool res = await showMyDialogForCancelTransaction(
                                  context,
                                  'Вы уверены?',
                                  'это отменит транзакцию и вернет предыдущее состаяние',
                                  'да',
                                  'нет');
                              if (res) {
                                await goalProvider.cancelTransaction(
                                    goalProvider.transations[index]);
                              } else
                                return;
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
