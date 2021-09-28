import 'package:flutter/material.dart';
import 'package:h_manage/server_request.dart';

//TODO: Create bills and coins icons

class SixthPage extends StatefulWidget {
  final num total;
  final num tnumber;
  SixthPage({Key? key, required this.total, required this.tnumber})
      : super(key: key);

  @override
  _SixthPageState createState() => _SixthPageState();
}

class _SixthPageState extends State<SixthPage> {
  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  SixthPage get widget => super.widget;
  num _counter = 0;
  List<int> listInt = [200, 100, 50, 20, 10, 5];
  List<Map<String, dynamic>> listBills1 = [
    {'asset': '200e.png', 'value': 200},
    {'asset': '100e.png', 'value': 100},
    {'asset': '50e.png', 'value': 50},
  ];
  List<Map<String, dynamic>> listBills2 = [
    {'asset': '20e.png', 'value': 20},
    {'asset': '10e.png', 'value': 10},
    {'asset': '5e.png', 'value': 5},
  ];
  List<Map<String, dynamic>> listCoins1 = [
    {'asset': '2e.png', 'value': 2},
    {'asset': '1e.png', 'value': 1},
    {'asset': '50c.png', 'value': 0.5},
    {'asset': '20c.png', 'value': 0.2},
  ];
  List<Map<String, dynamic>> listCoins2 = [
    {'asset': '10c.png', 'value': 0.1},
    {'asset': '5c.png', 'value': 0.05},
    {'asset': '2c.png', 'value': 0.02},
    {'asset': '1c.png', 'value': 0.01},
  ];
  List<double> listDouble = [2, 1, 0.5, 0.2, 0.1, 0.05, 0.02, 0.01];

  List<num> moneyChange = [0, 0];

  void _addMoney(num number) {
    setState(() {
      _counter = _counter + number;
    });
  }

  void _clearMoney() {
    setState(() {
      _counter = 0;
    });
  }

  void _clearTbills() {
    ServerRequest.updateCashCount(widget.total.toString(), null,
        widget.total.toString(), 1, null, null, null, getDate());
    ServerRequest.deleteTbill(widget.tnumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment table: ' + widget.tnumber.toString()),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                'Total:',
              ),
              Text(
                widget.total.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headline4,
              ),
              Text(
                'Cash:',
              ),
              Text(
                _counter.toStringAsFixed(2),
                style: Theme.of(context).textTheme.headline4,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...generateButton(listBills1),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ...generateButton(listBills2),
                    ],
                  ),
                ],
              ),
              //...tablesView2(listInt),
              //...generateButton(listBills),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...generateButton(listCoins1),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  ...generateButton(listCoins2),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => _clearMoney(), child: Text('Clear')),
                  ElevatedButton(
                      child: Text('OK'),
                      onPressed: () {
                        moneyChange[0] = _counter;
                        moneyChange[1] = _counter - widget.total;
                        if (moneyChange[1] < 0) {
                          _clearMoney();
                          showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                                // TODO: Handle iOS Dialog
                                AlertDialog(
                              title: const Text('Not enough money'),
                              content: const Text(
                                  'Please introduce quantity again'),
                              actions: <Widget>[
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'Cancel'),
                                  child: const Text('Cancel'),
                                ),
                                TextButton(
                                  onPressed: () =>
                                      Navigator.pop(context, 'OK'),
                                  child: const Text('OK'),
                                ),
                              ],
                            ),
                          );
                        } else {
                          ServerRequest.updateTable(
                              int.parse(widget.tnumber.toString()),
                              0.toString());
                          _clearTbills();
                          Navigator.pop(context, moneyChange);
                        }
                      }),
                ],
              ),
            ],
          ),
        ),
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: "sum",
      //   onPressed: _incrementCounter,
      //   tooltip: 'Increment',
      //   child: Icon(Icons.add),
      // ),
    );
  }

  List<Widget> generateButton(List<Map> listOfValues) {
    List<Widget> buttons = [];
    double iSize = 100;
    for (var individual in listOfValues) {
      individual["value"] < 5 ? iSize = 50 : iSize = 100;
      buttons.add(IconButton(
        onPressed: () => _addMoney(individual["value"]),
        iconSize: iSize,
        icon: Image(image: AssetImage('assets/money/' + individual["asset"])),
      ));
    }
    return buttons;
  }
}

class ButtonWidget extends StatelessWidget {
  final num foreignCount;
  final Function(int) onCountChange;
  ButtonWidget({required this.foreignCount, required this.onCountChange});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onCountChange(13), child: Text('13'));
  }
}
