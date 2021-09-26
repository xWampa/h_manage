import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:file_selector_platform_interface/file_selector_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

/// Screen that shows an example of openFiles
class OpenImagePage extends StatelessWidget {
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
      builder: (context) => ImageDisplay(fileName, filePath),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Open an image'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              child: const Text('Press to open an image file(png, jpg)'),
              onPressed: () => _openImageFile(context),
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
  const ImageDisplay(this.fileName, this.filePath);

  /// Image's name
  final String fileName;

  /// Image's path
  final String filePath;

  Future uploadToServer() async {
    final uri = Uri.parse('http://192.168.1.134:8888/image');
    var request = http.MultipartRequest('POST', uri);
    var pic = await http.MultipartFile.fromPath('photo', filePath);
    request.files.add(pic);
    var response = await request.send();

    if (response.statusCode == 200) {
      print('uploaded');
    } else {
      print('failed');
    }
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
                uploadToServer();
              },
            ),
          ],
        ),
      ],
    );
  }
}