import 'dart:async';
import 'dart:io';
import 'dart:io' show Platform;

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:image_picker/image_picker.dart';

import 'package:h_manage/server_request.dart';
import 'package:h_manage/pages/hero_dialog_route.dart';
import 'package:h_manage/pages/edit_price.dart';

class EditProduct extends StatefulWidget {
  final int id;
  final String product;
  final String price;
  final String category;
  final String? image;
  EditProduct({
    Key? key,
    required this.id,
    required this.product,
    required this.price,
    required this.category,
    this.image,
  }) : super(key: key);

  @override
  _EditProductState createState() => _EditProductState();
}

class _EditProductState extends State<EditProduct> {
  int id = 0;
  num itemPrice = 0;
  String imageRoute = '';
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
    if (widget.image != null) imageRoute = widget.image!;

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

  // This is for Android
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

  // This is for Windows
  void _openImageFile(BuildContext context) async {
    final typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'png'],
    );
    final files = await FileSelectorPlatform.instance
        .openFiles(acceptedTypeGroups: [typeGroup]);
    final file = files[0];
    final fileName = file.name;
    final filePath = file.path;

    await showDialog(
      context: context,
      builder: (context) => ImageDisplay(fileName, filePath, id),
    );
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
                // Navigator.of(context).pushNamed(
                //   '/seventh/edit_product/open_image_page',
                //   arguments: true,
                // );
                _openImageFile(context);
              },
              child:
              imageRoute == '' ? Text('Select an Image') : Text(imageRoute)
          ),
          if (imageRoute == '') Icon(Icons.image,size: 16,),
          imageRoute != ''
              ? Image.network(
            ServerRequest.getImageRoute() + imageRoute,
            width: 24,
            height: 24,
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

/// Widget that displays a text file in a dialog
class ImageDisplay extends StatelessWidget {
  /// Default Constructor
  const ImageDisplay(this.fileName, this.filePath, this.fileNameDb);

  /// Image's name
  final String fileName;

  /// Image's path
  final String filePath;

  /// Image's path rel to DB
  final int fileNameDb;

  Future uploadToServer(BuildContext context) async {
    final uri = Uri.parse('http://192.168.1.134:8888/image');
    var request = http.MultipartRequest('POST', uri);
    request.fields['imageName'] = fileNameDb.toString() + '.' + getExt(fileName);
    var pic = await http.MultipartFile.fromPath('photo', filePath);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('uploaded');
      // TODO: Make sure that the request completes with success
      // TODO: Rn you need to reload fifth to see changes, solve by setState
      ServerRequest.updateProductImage(fileNameDb, fileNameDb.toString() + '.' + getExt(fileName));
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Image Updated')));
    } else {
      print('failed');

      ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('FAILED')));
    }
  }
  
  String getExt(String filename) {
    return filename.split(".")[1];
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(fileName),
      // On web the filePath is a blob url
      // while on other platforms it is a system path.
      content: kIsWeb ? Image.network(filePath) : Image.file(File(filePath)),
      actions: [
        Row(
          children: [
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            TextButton(
              child: const Text('Upload'),
              onPressed: () {
                uploadToServer(context);
              },
            ),
          ],
        ),
      ],
    );
  }
}