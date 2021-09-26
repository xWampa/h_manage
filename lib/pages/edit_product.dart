import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';

import 'package:image_picker/image_picker.dart';

import 'package:h_manage/server_request.dart';
import 'package:h_manage/pages/hero_dialog_route.dart';
import 'package:h_manage/pages/edit_price.dart';

class EditProduct extends StatefulWidget {
  final int id;
  final String product;
  final String price;
  final String category;
  EditProduct({
    Key? key,
    required this.id,
    required this.product,
    required this.price,
    required this.category,
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  int id = 0;
  num itemPrice = 0;
  bool justOnceProduct = true;
  bool justOnceCategory = true;
  bool productError = false;
  bool categoryError = false;

  TextEditingController _controllerProduct = TextEditingController();
  TextEditingController _controllerCategory = TextEditingController();

  final ImagePicker _picker = ImagePicker();
  File? image;

  String getDate() {
    DateTime now = DateTime.now();
    DateTime date = DateTime(now.year, now.month, now.day);
    final List<String> finalDate = date.toString().split(" ");
    return finalDate[0];
  }

  @override
  EditProduct get widget => super.widget;

  @override
  void initState() {
    super.initState();
    id = widget.id;
    itemPrice = num.parse(widget.price);

    _controllerProduct.text = widget.product;
    _controllerProduct.selection = TextSelection(
        baseOffset: 0, extentOffset: _controllerProduct.text.length);

    _controllerCategory.text = widget.category;
    _controllerCategory.selection = TextSelection(
        baseOffset: 0, extentOffset: _controllerCategory.text.length);
  }

  // Goes to the ..itemPrice and edit the product price
  void editPrice(BuildContext context, num price) async {
    final returnedPrice = await Navigator.of(context)
        .pushNamed('/fifth/edit_product/price', arguments: price);
    returnedPrice as num;
  }

  void editPrice2(BuildContext context, num price) async {
    final returnedPrice =
        await Navigator.of(context).push(HeroDialogRoute(builder: (context) {
      return AddPricePopupCard(price: price);
    }));
    if (returnedPrice != null) returnedPrice as num;
    print(returnedPrice);
    if (returnedPrice is num) {
      setState(() {
        itemPrice = returnedPrice;
      });
    }
  }

  Future selectImage() async {
    try {
      final image = await _picker.pickImage(source: ImageSource.gallery);
      if (image == null) return;
      final imageTemporary = File(image.path);
      setState(() {
        this.image = imageTemporary;
      });
    } on Exception catch (e) {
      print('Failed to pick an image: $e');
    }
  }

  Row resolveImageWidget() {
    if (Platform.isWindows) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Image(windows): ',
            style: TextStyle(fontSize: 18),
          ),
          TextButton(
              onPressed: () async {
                Navigator.of(context).pushNamed(
                  '/seventh/edit_product/open_image_page',
                  arguments: true,
                );
              },
              child: Text('Select an Image')),
          Icon(
            Icons.image,
            size: 16,
          ),
          image != null
              ? Image.file(
            image!,
            width: 160,
            height: 160,
          )
              : FlutterLogo(
            size: 24,
          ),
        ],
      );
    } else {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Image: ',
            style: TextStyle(fontSize: 18),
          ),
          TextButton(
              onPressed: () async {
                selectImage();
              },
              child: Text('Select an Image')),
          Icon(
            Icons.image,
            size: 16,
          ),
          image != null
              ? Image.file(
            image!,
            width: 160,
            height: 160,
          )
              : FlutterLogo(
            size: 24,
          ),
        ],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
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
                Text(
                  'Product:  ',
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                  width: 155,
                  child: TextField(
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerProduct,
                      decoration: InputDecoration(
                        hintText: 'Product name',
                        errorText: productError ? "Value Can't Be Empty" : null,
                      ),
                      onTap: () {
                        if (justOnceProduct == true) {
                          justOnceProduct = false;
                          _controllerProduct.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controllerProduct.text.length);
                        }
                      }),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Price: ',
                  style: TextStyle(fontSize: 18),
                ),
                TextButton(
                    onPressed: () {
                      editPrice2(context, itemPrice);
                    },
                    child: Text(itemPrice.toStringAsFixed(2) + ' €')),
                Icon(
                  Icons.edit,
                  size: 16,
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Category:  ',
                  style: TextStyle(fontSize: 18),
                ),
                Container(
                  width: 155,
                  child: TextField(
                      textAlign: TextAlign.center,
                      textCapitalization: TextCapitalization.sentences,
                      controller: _controllerCategory,
                      decoration: InputDecoration(
                        hintText: 'Enter category',
                        errorText:
                            categoryError ? "Value Can't Be Empty" : null,
                      ),
                      onTap: () {
                        if (justOnceCategory == true) {
                          justOnceCategory = false;
                          _controllerProduct.selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: _controllerProduct.text.length);
                        }
                      }),
                ),
              ],
            ),
            resolveImageWidget(),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Image: ',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     TextButton(
            //         onPressed: () async {
            //           selectImage();
            //         },
            //         child: Text('Select an Image')),
            //     Icon(
            //       Icons.image,
            //       size: 16,
            //     ),
            //     image != null
            //         ? Image.file(
            //             image!,
            //             width: 160,
            //             height: 160,
            //           )
            //         : FlutterLogo(
            //             size: 24,
            //           ),
            //   ],
            // ),
            // Row(
            //   mainAxisAlignment: MainAxisAlignment.center,
            //   children: [
            //     Text(
            //       'Image: ',
            //       style: TextStyle(fontSize: 18),
            //     ),
            //     TextButton(
            //         onPressed: () async {
            //           Navigator.of(context).pushNamed(
            //             '/seventh/edit_product/open_image_page',
            //             arguments: true,
            //           );
            //         },
            //         child: Text('Select an Image')),
            //     Icon(
            //       Icons.image,
            //       size: 16,
            //     ),
            //     image != null
            //         ? Image.file(
            //             image!,
            //             width: 160,
            //             height: 160,
            //           )
            //         : FlutterLogo(
            //             size: 24,
            //           ),
            //   ],
            // ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _controllerProduct.text.isEmpty
                      ? productError = true
                      : productError = false;

                  _controllerCategory.text.isEmpty
                      ? categoryError = true
                      : categoryError = false;
                });
                if (!productError && !categoryError) {
                  ServerRequest.updateProduct(id, _controllerProduct.text,
                      itemPrice.toString(), _controllerCategory.text);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Product updated')),
                  );
                  Navigator.pop(context, true);
                }
              },
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}
