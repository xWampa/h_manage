import 'package:flutter/material.dart';

class SecondPage extends StatelessWidget {
  final String data;

  SecondPage({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TITLE PAGE 2'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'PLACE',
              style: TextStyle(fontSize: 50),
            ),
            Text(
              data,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}