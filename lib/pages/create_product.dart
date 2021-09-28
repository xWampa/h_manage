import 'package:flutter/material.dart';
import 'package:h_manage/server_request.dart';

class CreateProduct extends StatefulWidget {
  CreateProduct({
    Key? key,
  }) : super(key: key);

  @override
  _CreateProductState createState() => _CreateProductState();
}

class _CreateProductState extends State<CreateProduct> {
  num itemPrice = 0;
  bool productError = false;
  bool priceError = false;
  bool categoryError = false;

  TextEditingController _controllerProduct = TextEditingController();
  TextEditingController _controllerPrice = TextEditingController();
  TextEditingController _controllerCategory = TextEditingController();

  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create'),
      ),
      body: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.all(8.0),
        margin: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 20,
          vertical: MediaQuery.of(context).size.width / 20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Product:  ', style: TextStyle(fontSize: 18),),
                Container(
                  width: 155,
                  child: TextField(
                      textAlign: TextAlign.center,
                      controller: _controllerProduct,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                        errorText: productError ? "Value Can't Be Empty" : null,
                      ),
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Price: ', style: TextStyle(fontSize: 18),),
                Container(
                  width: 155,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controllerPrice,
                    decoration: InputDecoration(
                      hintText: 'Price of the product',
                      errorText: priceError ? "Value Can't Be Empty" : null,
                    ),
                  ),
                ),
              ],
            ),
            // TODO: Improve category management
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Category: ', style: TextStyle(fontSize: 18),),
                Container(
                  width: 155,
                  child: TextField(
                    textAlign: TextAlign.center,
                    controller: _controllerCategory,
                    decoration: InputDecoration(
                      hintText: 'Category of the product',
                      errorText: categoryError ? "Value Can't Be Empty" : null,
                    ),
                  ),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controllerProduct.text.isEmpty
                      ? productError = true
                      : productError = false;
                  _controllerPrice.text.isEmpty
                      ? priceError = true
                      : priceError = false;
                  _controllerCategory.text.isEmpty
                      ? categoryError = true
                      : categoryError = false;
                });
                if (!productError && !priceError && !categoryError) {
                  ServerRequest.createProduct(
                    _controllerProduct.text,
                    _controllerPrice.text,
                    _controllerCategory.text,
                  );
                  Navigator.pop(context, true);
                }

              },
              child: const Text('Create'),
            ),
            // ElevatedButton(
            //   onPressed: () async{
            //       Navigator.pop(context, true);
            //   },
            //   child: const Text('TEST'),
            // ),
          ],
        ),
      ),
    );
  }
}