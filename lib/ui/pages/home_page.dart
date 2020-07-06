import 'package:easy_dialog/easy_dialog.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';

import '../../helpers/my_dialog_for_cancel_transaction.dart';
import '../../helpers/my_simple_dialog.dart';
import '../../providers/goal_provider.dart';
import 'about_page.dart';
import 'auth_page.dart';
import 'statistic_page.dart';

class HomePage extends StatefulWidget {
  static String route = 'home';
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    const roundedContainerDecoration = BoxDecoration(
      color: Color(0xFFE9EEF9),
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(30),
      ),
    );

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('  Мой учет'),
        actions: [
          IconButton(icon: Icon(Icons.insert_chart), onPressed: _goToStatistic),
          IconButton(
              icon: Icon(Icons.question_answer), onPressed: _goToAboutUs),
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _logout),
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
                        lineWidth: 12.0,
                        animation: true,
                        header: Text(
                          "Накоплено",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        percent: (goalProvider.precent / 100),
                        center: Text(
                          "${goalProvider.precent.toStringAsFixed(1)}%",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        footer: Text(
                          '${goalProvider.haveSum}',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        progressColor: Colors.green,
                      ),
                      CircularPercentIndicator(
                        radius: 120.0,
                        lineWidth: 12.0,
                        animation: true,
                        header: Text(
                          "Осталось",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        percent: 1 - (goalProvider.precent / 100),
                        center: Text(
                          "${(100 - goalProvider.precent).toStringAsFixed(1)}%",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        footer: Text(
                          '${goalProvider.goalSum - goalProvider.haveSum} ',
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        progressColor: Colors.red,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: roundedContainerDecoration,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          leading: Icon(
                            Icons.flag,
                            color: Colors.blueGrey[700],
                            size: 30.0,
                          ),
                          title: Text(
                            '${goalProvider.name}',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.blueGrey[700]),
                          ),
                        ),
                        ListTile(
                          leading: Icon(
                            Icons.attach_money,
                            color: Colors.blueGrey[700],
                            size: 30.0,
                          ),
                          title: Text(
                            '${goalProvider.goalSum} ',
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                .copyWith(color: Colors.blueGrey[700]),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 4,
                  child: Container(
                    color: Color(0xFFE9EEF9),
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
                                style: Theme.of(context).textTheme.bodyText1,
                              ),
                              subtitle: Text(
                                goalProvider.transations[index]['time'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              trailing: Text(
                                '${goalProvider.transations[index]['type']}${goalProvider.transations[index]['sum']} ',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    .copyWith(
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
        children: [
          FloatingActionRowButton(
            icon: Icon(Icons.add),
            onTap: () => showMyDialog(
                context, 'Положить деньги', 'ок', 'отмена', '+', _scaffoldKey),
          ),
          FloatingActionRowButton(
            icon: Icon(Icons.remove),
            onTap: () => showMyDialog(
                context, 'Взять деньги', 'ок', 'отмена', '-', _scaffoldKey),
          ),
        ],
      ),
    );
  }

  Future<void> _logout() async {
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
            Provider.of<GoalProvider>(context, listen: false).logout();
            Navigator.of(context).pushNamed(AuthPage.route);
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
      ],
    ).show(context);
  }

  void _goToStatistic() {
    Navigator.pushNamed(context, StatisticPage.route);
  }

  void _goToAboutUs() {
    Navigator.pushNamed(context, AboutPage.route);
  }
}
