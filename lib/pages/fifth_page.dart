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
// TODO: Center the text in the CircleAvatar
// TODO: When a table is selected go to Products tab automatically
// TODO: Move the item() to other file
// TODO: Prevent further calls when tapping the same table over and over
// TODO: Add a refresh button on server connection fail
// TODO: Solve the problem when interacting SUPER-FAST with the server
//        Maybe create a buffer, a time guard? Do some research
//      I GOT IT, MAKE EVERYTHING LOCAL UNTIL THE EXIT OF THE PROGRAM OR
//      WHEN SWITCHING TO AN UNRELATED VIEW OR WHEN SOME TIME ELAPSED

class FifthPage extends StatefulWidget {
  final String data;

  FifthPage({Key? key, required this.data}) : super(key: key);

  @override
  _FifthPageState createState() => _FifthPageState();
}

class _FifthPageState extends State<FifthPage>
    with SingleTickerProviderStateMixin {
  List<bool> _isDisabled = [false, false, true, true];
  late TabController _tabController;
  int _selectedTable = 0;
  int _itemsInTable = 0;
  num _totalTableBill = 0;
  // List<Widget> _itemList = [];
  late Future<List<Product>> listOfDBProducts;
  late Future<List<Tablee>> listOfDBTables;
  late Future<List<Tbill>> listOfTbills;
  late Future<List<Tbill>> futureTableBill;
  final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  onTap() {
    if (_isDisabled[_tabController.index]) {
      final snackBar = SnackBar(
        content: Text('Select a table'),
        duration: const Duration(milliseconds: 1500),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      );
      scaffoldMessengerKey.currentState!.showSnackBar(snackBar);

      int index = _tabController.previousIndex;
      setState(() {
        _tabController.index = index;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    listOfDBProducts = ServerRequest.fetchProducts(http.Client());
    listOfDBTables = ServerRequest.fetchTables(http.Client());
    listOfTbills = ServerRequest.fetchTbills(http.Client());
    futureTableBill = ServerRequest.fetchTbills(http.Client());
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(onTap);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // Keeps updating the selected table at the top (title)
  Widget _resolveSelectedTable() {
    if (_selectedTable == 0) {
      _isDisabled = [false, false, true, true];
      return Text('Table: Please select a table');
    }
    _isDisabled = [false, false, false, false];
    return Text('Table: ' + _selectedTable.toString());
  }

  // Keeps updating the nº of items on the selected table (Tab(Row(Text)))
  Widget _resolveNumberOfItemsInTable() {
    if (_itemsInTable == 0) {
      return Text('0', textAlign: TextAlign.center);
    }
    return Text(_itemsInTable.toString(), textAlign: TextAlign.center);
  }

  void _changeSelectedTable(int number) {
    setState(() {
      _selectedTable = number;
      print("Selected table: " + _selectedTable.toString());
    });
  }

  // New function that updates the future and updates the nº of items badge
  void _newUpdateFuture(int number) {
    int count = 0;
    num total = 0;
    futureTableBill =
        ServerRequest.fetchTableTbills(http.Client(), number.toString());
    futureTableBill.then((value) {
      for (var item in value) {
        count = count + item.units;
        total = total + num.parse(item.total);
      }
      setState(() {
        _itemsInTable = count;
        _totalTableBill = total;
        print('Items in table: ' + _itemsInTable.toStringAsFixed(2));
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      onGenerateRoute: RouteGenerator.generateRoute,
      home: DefaultTabController(
        length: 4,
        child: ScaffoldMessenger(
          key: scaffoldMessengerKey,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                controller: _tabController,
                tabs: [
                  Tab(icon: Icon(Icons.directions_car)),
                  Tab(child: Text('Tables'), icon: Icon(Icons.chair_alt)),
                  Tab(
                      child: Text('Products'),
                      icon: Icon(Icons.grid_on_rounded)),
                  Tab(
                    child: Text('Bill'),
                    icon: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.format_list_bulleted_rounded),
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 10,
                          child: _resolveNumberOfItemsInTable(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              title: _resolveSelectedTable(),
            ),
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              controller: _tabController,
              children: [
                SingleChildScrollView(
                  child: Column(
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
                        updateFuture: (int val) => _newUpdateFuture(val),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
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
                        tnumber: _selectedTable,
                        products: snapshot.data!,
                        updateFuture: (int val) => _newUpdateFuture(val),
                      );
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                FutureBuilder<List<Tbill>>(
                  future: futureTableBill,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        print(snapshot.requireData.length.toString());
                        if (snapshot.requireData.length != 0) {
                          return Scaffold(
                            body: SingleChildScrollView(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Wrap(
                                  alignment: WrapAlignment.center,
                                  spacing: 8.0,
                                  runSpacing: 8.0,
                                  children: [
                                    PopulateDataTable(
                                      tbills: snapshot.data!,
                                    ),
                                    Padding(
                                      padding: EdgeInsets.all(28.0),
                                      child: Container(
                                        height: 250,
                                        width: 350,
                                        decoration: BoxDecoration(
                                          color: Colors.blue.shade50,
                                          borderRadius: BorderRadius.circular(15),
                                        ),
                                        child: ListView(
                                          padding: const EdgeInsets.all(8),
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 50,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                          'Total',
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '288.69',
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 50,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Money',
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '500.00',
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Container(
                                                height: 50,
                                                width: 350,
                                                decoration: BoxDecoration(
                                                  color: Colors.blue,
                                                  borderRadius: BorderRadius.circular(15),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        'Change',
                                                        style: TextStyle(
                                                          fontSize: 26,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets.all(8.0),
                                                      child: Text(
                                                        '211.31',
                                                        style: TextStyle(
                                                          fontSize: 28,
                                                          color: Colors.white,
                                                          fontWeight: FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            floatingActionButton: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                FloatingActionButton(
                                  child: Icon(Icons.euro_rounded),
                                  onPressed: () {
                                    print('a');
                                    showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                        title: const Text('Alert Dialog Title'),
                                        content: const Text(
                                            'Alert Dialog Description'),
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
                                  },
                                ),
                                FloatingActionButton(
                                  child: Icon(Icons.credit_card),
                                  onPressed: () {
                                    print('b');
                                  },
                                ),
                                FloatingActionButton(
                                  //child: Icon(Icons.add),
                                  child: Text(
                                    _totalTableBill.toStringAsFixed(2),
                                  ),
                                  onPressed: () {
                                    print('c');
                                  },
                                ),
                              ],
                            ),
                          );
                        } else {
                          return Center(child: Text('No items yet'));
                        }
                      } else {
                        return const Center(
                          child: Text('An error has occurred!'),
                        );
                      }
                    } else {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class PopulateDataTable extends StatelessWidget {
  final List<Tbill> tbills;
  final List<DataRow> itemRow = [];

  PopulateDataTable({
    Key? key,
    required this.tbills,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    for (var item in tbills) {
      itemRow.add(
        DataRow(
          cells: [
            DataCell(Text(item.item)),
            DataCell(Text(item.units.toString())),
            DataCell(Text(item.iprice)),
            DataCell(Text(item.total)),
          ],
        ),
      );
    }
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: DataTable(
        columns: [
          const DataColumn(label: Text('Product')),
          const DataColumn(label: Text('Units')),
          const DataColumn(label: Text('Price')),
          const DataColumn(label: Text('Total')),
        ],
        rows: itemRow,
      ),
    );
  }
}

class ProductsView extends StatelessWidget {
  final List<Product> products;
  // final Function(String, String) addItem;
  final int tnumber;
  late final Future<Tbill>? futureTbill;
  final Function(int) updateFuture;

  ProductsView({
    Key? key,
    required this.tnumber,
    required this.updateFuture,
    required this.products,
    // required this.addItem,
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
            // onPressed: () {
            //   addItem(products[index].name, products[index].price);
            //
            // }
            onPressed: () {
              futureTbill = ServerRequest.createTbill(
                tnumber,
                products[index].name,
                1,
                products[index].price,
                products[index].price,
              );
              updateFuture(tnumber);
            },
            child: Text(products[index].name));
      },
    );
  }
}

class TablesView extends StatelessWidget {
  final List<Tablee> tables;
  final Function(int) changeTable;
  final Function(int) updateFuture;
  TablesView({
    Key? key,
    required this.updateFuture,
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
            onPressed: () {
              changeTable(tables[index].number);
              updateFuture(tables[index].number);
            },
            child: Text(tables[index].number.toString()));
      },
    );
  }
}
