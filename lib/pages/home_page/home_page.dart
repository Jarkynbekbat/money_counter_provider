import 'package:floating_action_row/floating_action_row.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/helpers/my_simple_dialog.dart';
import 'package:safe_money/pages/auth_page.dart';

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
        title: Text('Учет накопления'),
        backgroundColor: MyColors.color4,
        actions: [
          IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                Provider.of<GoalProvider>(context, listen: false).logout();
                Navigator.of(context).popAndPushNamed(AuthPage.route);
              })
        ],
      ),
      body: Consumer<GoalProvider>(
        builder: (context, goalProvider, _) {
          return Container(
            child: Column(
              children: [
                Expanded(
                  flex: 3,
                  child: Text('Header'),
                ),
                Expanded(
                  flex: 2,
                  child: Container(
                    decoration: roundedContainerDecoration.copyWith(
                      color: MyColors.color3,
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
                        itemBuilder: (context, index) {
                          return ListTile(
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
                              '${goalProvider.transations[index]['type']}${goalProvider.transations[index]['sum']} сом',
                              style: TextStyle(
                                fontSize: 18,
                                color: goalProvider.transations[index]
                                            ['type'] ==
                                        '+'
                                    ? Colors.green
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          );
                        },
                        itemCount: goalProvider.transations.length,
                      ),
                    ),
                  ),
                ),
                //       Container(
                //         color: MyColors.color3,
                //         // decoration: BoxDecoration(
                //         //   color: MyColors.color3,
                //         //   borderRadius: BorderRadius.only(
                //         //     topLeft: const Radius.circular(20.0),
                //         //     topRight: const Radius.circular(20.0),
                //         //   ),
                //         // ),
                //         width: Screen.width(context) * 0.85,
                //         height: Screen.heigth(context) * 0.46,
                //         child: SingleChildScrollView(
                //           child: Column(
                //               children: goalProvider.transations.length != 0
                //                   ? List<Widget>.generate(
                //                       goalProvider.transations.length,
                //                       (index) {
                //                         return Dismissible(
                //                           key: Key(goalProvider.transations[index]
                //                               ['datetime']),
                //                           onDismissed: (key) async {
                //                             await goalProvider.deleteTransaction(
                //                                 goalProvider.transations[index]);
                //                           },
                //                           child: ListTile(
                //                             leading:
                //                                 goalProvider.transations[index]
                //                                             ['type'] ==
                //                                         "+"
                //                                     ? Icon(
                //                                         Icons.arrow_downward,
                //                                         color: Colors.green,
                //                                       )
                //                                     : Icon(
                //                                         Icons.arrow_upward,
                //                                         color: Colors.red,
                //                                       ),
                //                             title: Wrap(
                //                                 alignment:
                //                                     WrapAlignment.spaceBetween,
                //                                 children: [
                //                                   Text(
                //                                     '${goalProvider.transations[index]['date']}',
                //                                     style: TextStyle(
                //                                       color: Colors.black54,
                //                                       fontWeight: FontWeight.bold,
                //                                     ),
                //                                   ),
                //                                   Text(
                //                                     '${goalProvider.transations[index]['type']}${goalProvider.transations[index]['sum']} сом',
                //                                     style: TextStyle(
                //                                       color:
                //                                           goalProvider.transations[
                //                                                           index]
                //                                                       ['type'] ==
                //                                                   '+'
                //                                               ? Colors.green
                //                                               : Colors.red,
                //                                       fontWeight: FontWeight.bold,
                //                                     ),
                //                                   ),
                //                                 ]),
                //                             subtitle: Text(
                //                               goalProvider.transations[index]
                //                                   ['time'],
                //                               style: TextStyle(
                //                                 color: MyColors.color4,
                //                                 fontStyle: FontStyle.italic,
                //                                 fontWeight: FontWeight.bold,
                //                               ),
                //                             ),
                //                           ),
                //                         );
                //                       },
                //                     )
                //                   : [Text('НЕТ ОПЕРАЦИЙ')]),
                //         ),
                //       ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionRow(
        color: MyColors.color4,
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
