import 'dart:async';

import 'package:flutter/material.dart';
import 'package:escpos/escpos.dart';

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

  PrinterNetworkManager _printerManager = PrinterNetworkManager();

  void initPrinter(String host) {
    _printerManager.selectPrinter(
        host, port: 9100, timeout: Duration(seconds: 5));
  }

  Future<void> _printNow() async {
    final profile = await CapabilityProfile.load();
    const PaperSize paper = PaperSize.mm80;
    Ticket ticket = Ticket(paper, profile);
    ticket.text('testing');
    ticket.feed(2);
    ticket.cut();

    final PosPrintResult result = await _printerManager.printTicket(ticket);
    print('Print result: ${result.msg}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Print test '),
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
            initPrinter(_controllerHost.text);
            _printNow();
          },
          child: const Text('Print'),
        ),
      ],
    );
  }
}
