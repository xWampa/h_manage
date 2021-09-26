import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:h_manage/data.dart';
import 'package:h_manage/server_request.dart';

class SeventhPage extends StatefulWidget {
  const SeventhPage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _SeventhPageState createState() {
    return _SeventhPageState();
  }
}

class _SeventhPageState extends State<SeventhPage> {

  late Future<List<Product>> listOfDBProducts;

  @override
  void initState() {
    super.initState();
    listOfDBProducts = ServerRequest.fetchProducts(http.Client());
  }

  void editProduct(BuildContext context, List<dynamic> productDetails) async {
    print(productDetails.toString());
    final updateFuture = await Navigator.of(context)
        .pushNamed('/seventh/edit_product', arguments: productDetails);
    if (updateFuture != null) updateFuture as bool;
    if (updateFuture == true) {
      setState(() {
        listOfDBProducts = ServerRequest.fetchProducts(http.Client());
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit product'),
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
        child: FutureBuilder<List<Product>>(
            future: listOfDBProducts,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (snapshot.hasData) {
                  if (snapshot.requireData.length != 0) {
                    return ProductsViewEdit(
                      products: snapshot.data!,
                      productParameters: (List<dynamic> val) =>
                          editProduct(context, val),
                    );
                  } else {
                    return const Center(child: Text('No products to show'),);
                  }
                } else {
                  return const Center(child: Text('An error has occurred!'),);
                }
              } else {
                return const Center(child: CircularProgressIndicator(),);
              }
            }
        ),
      ),
    );
  }
}

class ProductsViewEdit extends StatelessWidget {
  final List<Product> products;
  final Function(List<dynamic>) productParameters;
  //final Function(int) updateFuture;

  ProductsViewEdit({
    Key? key,
    //required this.updateFuture,
    required this.products,
    required this.productParameters,
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
            onPressed: () {
              productParameters([
                products[index].id,
                products[index].name,
                products[index].price,
                products[index].category,
              ]);
            },
            onLongPress: () => Navigator.of(context).pushNamed('/seventh'),
            child: Text(products[index].name));
      },
    );
  }
}