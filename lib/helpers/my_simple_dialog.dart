import 'package:flutter/material.dart';
import 'package:easy_dialog/easy_dialog.dart';
import 'package:provider/provider.dart';
import 'package:safe_money/providers/goal_provider.dart';
import 'package:safe_money/services/local_transaction_service.dart';

showMyDialog(context, title, ok, cancel, type, scaffoldKey) async {
  TextStyle ts = TextStyle(
    fontSize: 15,
  );
  TextStyle tsTitle = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );
  TextEditingController textEditingController = TextEditingController();

  bool _result = false;
  await EasyDialog(
      height: 200,
      closeButton: false,
      title: Text(title, style: tsTitle),
      contentList: [
        TextField(
          controller: textEditingController,
          keyboardType: TextInputType.number,
        ),
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
                DateTime now = DateTime.now();
                String formatedDate = '${now.day}.${now.month}.${now.year}';
                String formatedTime = '${now.hour}:${now.minute}';

                Map<String, dynamic> transaction = {
                  "datetime": now.toString(),
                  "date": formatedDate,
                  "time": formatedTime,
                  "sum": textEditingController.text,
                  "type": type
                };
                await LocalTransactionService.addTransaction(transaction);
                await Provider.of<GoalProvider>(context, listen: false)
                    .addTransaction(transaction, scaffoldKey);

                _result = true;
                Navigator.of(context).pop();
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
                  _result = false;
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        )
      ]).show(context);

  return _result;
}
