import 'dart:async';
import 'package:flutter/material.dart';

class SeventhPage extends StatefulWidget {
  const SeventhPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SeventhPageState createState() {
    return _SeventhPageState();
  }
}

class _SeventhPageState extends State<SeventhPage> {
  final TextEditingController _controllerHost = TextEditingController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product: '),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery
              .of(context)
              .size
              .width / 20,
          vertical: MediaQuery
              .of(context)
              .size
              .width / 20,
        ),
        child: buildColumn(),
      ),
    );
  }

  Column buildColumn() {
    return Column(
      //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      mainAxisSize: MainAxisSize.max,
      children: <Widget>[
        TextField(
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.sentences,
          controller: _controllerHost,
          decoration: const InputDecoration(hintText: 'Enter host'),
        ),
        ElevatedButton(
          onPressed: () {
            print(_controllerHost.text);
          },
          child: const Text('Print'),
        ),
      ],
    );
  }
}
