import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/pages/home_page/tabs/calc_tab.dart';
import 'package:safe_money/pages/home_page/tabs/statistic_tab.dart';
import 'package:safe_money/providers/goal_provider.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
          appBar: AppBar(
            title: Text('Батыров Талгат'),
            backgroundColor: MyColors.color4,
            actions: [
              IconButton(
                  icon: Icon(Icons.exit_to_app),
                  onPressed: () async {
                    Provider.of<GoalProvider>(context, listen: false).logout();
                    Navigator.of(context).popAndPushNamed('/first');
                  })
            ],
            bottom: TabBar(
              tabs: [
                Tab(text: 'УЧЕТ'),
                Tab(text: 'СТАТИСТИКА'),
              ],
            ),
          ),
          body: TabBarView(children: [
            CalcTab(),
            StatisticTab(),
          ])),
    );
  }
}
