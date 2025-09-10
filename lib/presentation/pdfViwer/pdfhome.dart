import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:path_provider/path_provider.dart';
import 'PdfViewPage.dart';

class PdfHome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatelessWidget {

  //
  Future<String> loadPdfFromAssets(String assetPath) async {
    try {
      final byteData = await rootBundle.load(assetPath);
      final buffer = byteData.buffer;
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/temp.pdf');
      await tempFile.writeAsBytes(buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes));
      return tempFile.path;
    } catch (e) {
      print(e);
      return '';
    }
  }

  void openPdf(BuildContext context) async {
    String path = await loadPdfFromAssets('assets/images/sample.pdf');

    if (path.isNotEmpty) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PdfViewPage(path: path),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load PDF")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Open PDF from Assets"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () => openPdf(context),
          child: Text("Open PDF"),
        ),
      ),
    );
  }
}