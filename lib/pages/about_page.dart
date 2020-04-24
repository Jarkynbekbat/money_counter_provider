import 'package:flutter/material.dart';
import 'package:safe_money/helpers/constants.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  static String route = 'about';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('О приложении'),
      ),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text(
            '''
              Приложение "Мой учет" предназначено помочь людям вести
учет накопления,смотреть статистику , прогнозировать , приложение находится на стадии разработки поэтому если у вас возникли проблемы , просьба сообщить нам нажав на кнопку ниже.
              ''',
            style: textStyle,
            softWrap: true,
          ),
          Container(
            child: OutlineButton(
              color: Colors.white,
              disabledBorderColor: Colors.white,
              textColor: Colors.black,
              onPressed: () => openUrl('mailto:jarkynbekbat@gmail.com'),
              child: Text(
                'Напишите нам',
                style: TextStyle(
                  color: Theme.of(context).textTheme.body1.color,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}

openUrl(url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
