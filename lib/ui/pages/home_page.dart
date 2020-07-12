import 'package:easy_dialog/easy_dialog.dart';
import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_file.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/localization/get_value.dart';

import '../../data/providers/goal_provider.dart';
import '../../main.dart';
import '../widgets/my_dialog_for_cancel_transaction.dart';
import '../widgets/my_simple_dialog.dart';
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
  void _changeLanguage(Locale language) {
    Locale _temp;
    switch (language.languageCode) {
      case 'en':
        _temp = Locale(language.languageCode, 'US');
        break;
      case 'ru':
        _temp = Locale(language.languageCode, 'RU');
        break;
      default:
        _temp = Locale(language.languageCode, 'US');
    }
    MyApp.setLocale(context, _temp);
  }

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
        title: Text(getValue(context, 'title')),
        actions: [
          IconButton(icon: Icon(Icons.insert_chart), onPressed: _goToStatistic),
          IconButton(
              icon: Icon(Icons.question_answer), onPressed: _goToAboutUs),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton(
              selectedItemBuilder: (context) => [Text('')],
              items: [
                DropdownMenuItem(
                  child: Text('RU'),
                  value: Locale('ru', 'RU'),
                ),
                DropdownMenuItem(
                  child: Text('EN'),
                  value: Locale('en', 'US'),
                ),
              ],
              onChanged: (Locale language) {
                _changeLanguage(language);
              },
              icon: Icon(Icons.language, color: Colors.white),
            ),
          ),
          IconButton(icon: Icon(Icons.exit_to_app), onPressed: _logout),
        ],
      ),
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, child) {
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
                          getValue(context, 'accumulated'),
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
                          getValue(context, 'нaveToSave'),
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        percent: 1 - (goalProvider.precent / 100),
                        center: Text(
                          "${(100 - goalProvider.precent).toStringAsFixed(1)}%",
                          style: Theme.of(context).textTheme.bodyText1,
                        ),
                        footer: Text(
                          '${goalProvider.goalSum - goalProvider.haveSum}',
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
                          Locale myLocale = Localizations.localeOf(context);
                          DateTime date = DateTime.parse(
                              goalProvider.transations[index]['datetime']);
                          String formatedDate = DateFormat(
                                  DateFormat.YEAR_ABBR_MONTH_DAY,
                                  myLocale.toString())
                              .format(date)
                              .toString();

                          return Dismissible(
                            key: ValueKey(
                                goalProvider.transations[index]['datetime']),
                            confirmDismiss: (direction) async {
                              return await _onDismissed(
                                  context, goalProvider, index);
                            },
                            background: Container(
                              color: Colors.red,
                              child: Icon(
                                Icons.delete_outline,
                                color: Colors.white,
                                size: 30,
                              ),
                            ),
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
                                '$formatedDate',
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
                context,
                getValue(context, 'put'),
                getValue(context, 'ok'),
                getValue(context, 'cancel'),
                '+',
                _scaffoldKey),
          ),
          FloatingActionRowButton(
            icon: Icon(Icons.remove),
            onTap: () => showMyDialog(
                context,
                getValue(context, 'take'),
                getValue(context, 'ok'),
                getValue(context, 'cancel'),
                '-',
                _scaffoldKey),
          ),
        ],
      ),
    );
  }

  Future<bool> _onDismissed(
      BuildContext context, GoalProvider goalProvider, int index) async {
    bool res = await showMyDialogForCancelTransaction(
      context,
      getValue(context, 'transactionTitle'),
      getValue(context, 'transactionSubtitle'),
      getValue(context, 'ok'),
      getValue(context, 'cancel'),
    );
    if (res) {
      await goalProvider.cancelTransaction(goalProvider.transations[index]);
      return true;
    } else
      return false;
  }

  Future<void> _logout() async {
    await EasyDialog(
      title: Text(getValue(context, 'transactionTitle')),
      height: 200,
      closeButton: false,
      contentList: [
        OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: Text(getValue(context, 'ok')),
          onPressed: () {
            Provider.of<GoalProvider>(context, listen: false).logout();
            Navigator.of(context).pushNamed(AuthPage.route);
          },
        ),
        OutlineButton(
          shape: RoundedRectangleBorder(
              borderRadius: new BorderRadius.circular(30.0)),
          child: Text(getValue(context, 'cancel')),
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
