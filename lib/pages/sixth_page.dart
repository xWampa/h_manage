import 'package:flutter/material.dart';
import 'package:h_manage/server_request.dart';

//TODO: Create bills and coins icons

class SixthPage extends StatefulWidget {
  final num total;
  final num tnumber;
  SixthPage({
    Key? key,
    required this.total,
    required this.tnumber
  }) : super(key: key);


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
  @override SixthPage get widget => super.widget;
  num _counter = 0;
  List<int> listaInt = [200,100,50,20,10,5];
  List<double> listaDouble = [2,1,0.5,0.2,0.1,0.05,0.02,0.01];

  List<num> moneyChange = [0,0];

  void _incrementCounter() {
    setState(() {
      _counter = _counter + widget.total;
    });
  }

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

  void _clearTbills(){
    ServerRequest.updateCashCount(
        widget.total.toString(),
        null,
        widget.total.toString(),
        1,
        null,
        null,
        null,
        getDate()
    );
    ServerRequest.deleteTbill(widget.tnumber.toString());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
            icon: Icon(Icons.print, color: Colors.red),
            onPressed: (){
            Navigator.pop(context, [0,0]);
            }
            ),
        title: Text('Hola' + _counter.toString()),
      ),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Cash:',
                ),
                Text(
                  _counter.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline4,
                ),
                Text(
                  'Total:',
                ),
                Text(
                  widget.total.toStringAsFixed(2),
                  style: Theme.of(context).textTheme.headline4,
                ),
                ...tablesView2(listaInt),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(onPressed: () => Navigator.pop(context), child: Text('Atras')),
                    ElevatedButton(onPressed: () => _clearMoney(), child: Text('Clear')),
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
                                      onPressed: () => Navigator.pop(
                                          context, 'Cancel'),
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
                              int.parse(widget.tnumber.toString()), 0.toString()
                          );
                          _clearTbills();
                          Navigator.pop(context, moneyChange);
                        }
                      }
                    ),
                  ],
                ),
              ],
            ),
    //Coins
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ...tablesView2(listaDouble),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: "sum",
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }

  void stateSetter() {
    setState(() {
      _counter = 13;
    });
  }

  List<Widget> tablesView2 (List<num> listaDeInts){
    List<Widget> botones = [];
    for(var individual in listaDeInts) {
      // botones.add(Text(individual.number.toString()));
      botones.add(
          ElevatedButton(
            child: Text(individual.toString() + '€'),
            onPressed: () => _addMoney(individual),
          )
      );
    }
    return botones;
  }

}

class ButtonWidget extends StatelessWidget {
  final num foreignCount;
  final Function(int) onCountChange;
  ButtonWidget({required this.foreignCount, required this.onCountChange });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => onCountChange(13),
        child: Text('13')
    );
  }
}


