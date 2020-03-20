import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/helpers/my_colors.dart';
import 'package:safe_money/pages/about_page.dart';
import 'package:safe_money/pages/auth_page.dart';
import 'package:safe_money/pages/statistic_page.dart';
import 'package:safe_money/providers/goal_provider.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        color: MyColors.color1,
        child: ListView(
          children: [
            ListTile(
              leading: Icon(Icons.insert_chart),
              title: Text(
                'Статистика',
              ),
              subtitle: Text('прогнозы'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, StatisticPage.route);
              },
            ),
            Divider(color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
            ListTile(
              leading: Icon(Icons.question_answer),
              title: Text('О приложении'),
              subtitle: Text('обратная сзязь'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushNamed(context, AboutPage.route);
              },
            ),
            Divider(color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
            ListTile(
              leading: Icon(Icons.exit_to_app),
              title: Text('Выйти'),
              subtitle: Text('остановить учет'),
              onTap: () async {
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
                  ],
                ).show(context);
              },
            ),
            Divider(color: Theme.of(context).iconTheme.color.withOpacity(0.5)),
          ],
        ),
      ),
    );
  }
}
