import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:h_manage/data.dart';

import 'package:h_manage/route_generator.dart';
import 'package:h_manage/server_request.dart';

import 'package:flutter/foundation.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

// TODO: Force to select a table
// TODO: Do something when Futures completes with error
// TODO: Make Bill badge more appealing

class FifthPage extends StatefulWidget {
  final String data;

  FifthPage({Key? key, required this.data}) : super(key: key);

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage> {
  int _selectedTable = 0;
  List<Widget> _itemList = [];
  late Future<List<Product>> listOfDBProducts;
  late Future<List<Tablee>> listOfDBTables;
  int _counter = 1;

  @override
  void initState() {
    super.initState();
    listOfDBProducts = ServerRequest.fetchProducts(http.Client());
    listOfDBTables = ServerRequest.fetchTables(http.Client());
  }

  Widget _resolveSelectedTable() {
    if (_selectedTable == 0) {
      return Text('Table: Please select a table');
    }
    return Text('Table: ' + _selectedTable.toString());
  }

  void _changeSelectedTable(int number) {
    setState(() {
      _selectedTable = number;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      home: DefaultTabController(
        length: 5,
        child: Scaffold(
          appBar: AppBar(
            bottom: TabBar(
              tabs: [
                Tab(icon: Icon(Icons.directions_car)),
                Tab(
                    child: Text('Products'),
                    icon: Icon(Icons.directions_transit)),
                Tab(child: Text('Simple counter'), icon: Icon(Icons.directions_bike)),
                Tab(child: Text('Tables'), icon: Icon(Icons.directions_bike)),
                Tab(
                    child: Text('Bill'),
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.directions_transit),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: Text(_itemList.length.toString()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            title: _resolveSelectedTable(),
          ),
          body: TabBarView(
            children: [
              Column(
                children: [
                  Tab(icon: Icon(Icons.directions_car)),
                  ElevatedButton(
                    child: Text('Go to main'),
                    onPressed: () {
                      Navigator.of(context).pushNamed('/');
                    },
                  ),
                  Text('Hi there!'),
                  Container(
                    margin: EdgeInsets.all(10),
                    child: SizedBox(
                      width: 130,
                      height: 130,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(context).pushNamed('/second',
                              arguments: 'I just pressed the new button');
                        },
                        child: Text('Wine'),
                        style: TextButton.styleFrom(
                          textStyle: GoogleFonts.rubik(
                            fontSize: 25,
                          ),
                          primary: Colors.amber,
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('/second',
                            arguments: 'I just pressed the new button');
                      },
                      child: Text('I am pretty famous last words')),
                ],
              ),
              FutureBuilder<List<Product>>(
                future: listOfDBProducts,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  } else if (snapshot.hasData) {
                    return ProductsView(
                      products: snapshot.data!,
                      addItem: (String str1, String str2) =>
                          _addItemWidget(str1, str2),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Scaffold(
                body: Center(
                  child: Text(_counter.toString()),
                ),
                floatingActionButton: FloatingActionButton(
                  child: Icon(Icons.add),
                  onPressed: _addOne,
                ),
              ),
              FutureBuilder<List<Tablee>>(
                future: listOfDBTables,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const Center(
                      child: Text('An error has occurred!'),
                    );
                  } else if (snapshot.hasData) {
                    return TablesView(
                      tables: snapshot.data!,
                      changeTable: (int val) => _changeSelectedTable(val),
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
              Scaffold(
                floatingActionButton: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: _addOne,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: _addOne,
                    ),
                    FloatingActionButton(
                      child: Icon(Icons.add),
                      onPressed: _addOne,
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                        child: Column(
                        children: [
                        ..._itemList,
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addOne() {
    setState(() {
      _counter = _counter + 1;
    });
  }

  _addItemWidget(String itemName, String itemPrice) {
    setState(() {
      _itemList.add(_item(itemName, itemPrice));
    });
  }

  // void _addItemWidget() {
  //   setState(() {
  //     _itemList.add(_item());
  //     print(_itemList.length);
  //   });
  // }

  // void _addItemWidget() {
  //   _itemList.add(_item());
  //   print(_itemList.length);
  // }

  Widget _item(String itemName, String itemPrice) {
    // Widget _item() {
    return Container(
      height: 80,
      margin: EdgeInsets.fromLTRB(5, 8, 5, 0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: Colors.teal[100],
      ),
      child: Center(
        child: ListTile(
          leading: Icon(
            Icons.arrow_right,
            color: Colors.lightBlue[900],
          ),
          title: Text(
            itemName,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.blue[900],
            ),
          ),
          trailing: Card(
            elevation: 1,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Container(
                width: 60,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      itemPrice,
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.green[700],
                      ),
                    ),
                    SizedBox(
                      width: 1,
                    ),
                    Icon(
                      Icons.euro,
                      size: 20,
                      color: Colors.amberAccent,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ProductsView extends StatelessWidget {
  final List<Product> products;
  final Function(String, String) addItem;
  ProductsView({
    Key? key,
    required this.products,
    required this.addItem,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
            onPressed: () =>
                addItem(products[index].name, products[index].price),
            child: Text(products[index].name));
      },
    );
  }
}

class TablesView extends StatelessWidget {
  final List<Tablee> tables;
  final Function(int) changeTable;
  TablesView({
    Key? key,
    required this.tables,
    required this.changeTable,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: Axis.vertical,
      gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 100,
        crossAxisSpacing: 5,
        mainAxisSpacing: 5,
      ),
      padding: const EdgeInsets.all(10),
      itemCount: tables.length,
      itemBuilder: (context, index) {
        return ElevatedButton(
            onPressed: () => changeTable(tables[index].number),
            child: Text(tables[index].number.toString()));
      },
    );
  }
}
