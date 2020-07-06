import 'package:easy_dialog/easy_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/goal_provider.dart';

showMyDialog(context, title, ok, cancel, type, scaffoldKey) async {
  const TextStyle ts = TextStyle(
    fontSize: 15,
  );
  const TextStyle tsTitle = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );
  TextEditingController textEditingController = TextEditingController();

  await EasyDialog(
      height: 200,
      closeButton: false,
      title: Text(title, style: tsTitle),
      contentList: [
        TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: 'введите сумму',
          ),
        ),
        const SizedBox(height: 20.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            OutlineButton(
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(30.0)),
              child: Text(
                ok,
                style: ts,
              ),
              onPressed: () async {
                try {
                  initializeDateFormatting();
                  DateTime now = DateTime.now();
                  String formatedTime = DateFormat.Hm('RU_ru').format(now);
                  String formatedDate =
                      DateFormat(DateFormat.YEAR_ABBR_MONTH_DAY, 'RU_ru')
                          .format(now)
                          .toString();

                  int.parse(textEditingController.text);
                  Map<String, dynamic> transaction = {
                    "datetime": now.toString(),
                    "date": formatedDate,
                    "time": formatedTime,
                    "sum": textEditingController.text,
                    "type": type
                  };
                  await Provider.of<GoalProvider>(context, listen: false)
                      .addTransaction(transaction, scaffoldKey);
                  Navigator.of(context).pop();
                } catch (ex) {
                  final snackBar = SnackBar(content: Text('ВВЕДИТЕ ЧИСЛО...'));
                  scaffoldKey.currentState.showSnackBar(snackBar);
                  Navigator.of(context).pop();
                }
              },
            ),
            Container(
              margin: EdgeInsets.only(left: 5),
              child: OutlineButton(
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(30.0)),
                child: Text(
                  cancel,
                  style: ts,
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        )
      ]).show(context);
  return true;
}
