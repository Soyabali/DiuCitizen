import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';

class DownloadReceiptScreen extends StatefulWidget {
  final String pdfUrl;
  const DownloadReceiptScreen({super.key, required this.pdfUrl});

  @override
  State<DownloadReceiptScreen> createState() => _DownloadReceiptScreenState();
}

class _DownloadReceiptScreenState extends State<DownloadReceiptScreen> {
  PdfController? _pdfController;
  bool _downloading = false;
  bool _loadingPdf = true;

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  /// Download PDF bytes from network
  Future<Uint8List> _loadPdfFromNetwork(String url) async {
    final response = await http.get(Uri.parse(url));
    return Uint8List.fromList(response.bodyBytes);
  }

  /// Load PDF into controller
  Future<void> _loadPdf() async {
    final pdfBytes = await _loadPdfFromNetwork(widget.pdfUrl);
    setState(() {
      _pdfController = PdfController(
        document: PdfDocument.openData(pdfBytes),
      );
      _loadingPdf = false;
    });
  }

  /// Download and save PDF file

  Future<void> _downloadPdf() async {
    try {
      setState(() => _downloading = true);

      // Save inside app sandbox first
      final dir = await getApplicationDocumentsDirectory();
      final folderPath = "${dir.path}/DownloadReceipt";
      final folder = Directory(folderPath);
      if (!await folder.exists()) {
        await folder.create(recursive: true);
      }

      final fileName = "${const Uuid().v4()}.pdf";
      final filePath = "$folderPath/$fileName";

      print("---60 --filePath : $filePath");

      // Download PDF from URL
      final response = await http.get(Uri.parse(widget.pdfUrl));
      final file = File(filePath);
      await file.writeAsBytes(response.bodyBytes);

      // Share Sheet so user can save/open anywhere (iOS-friendly)
      await Share.shareXFiles([XFile(filePath)], text: 'Here is your PDF receipt');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("File downloaded & ready to save anywhere")),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Download failed: $e")),
      );
    } finally {
      setState(() => _downloading = false);
    }
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("DownloadReceipt"),
        actions: [
          IconButton(
            icon: _downloading
                ? const CircularProgressIndicator(color: Colors.white)
                : const Icon(Icons.download),
            onPressed: _downloading ? null : _downloadPdf,
          )
        ],
      ),
      body: _loadingPdf
          ? const Center(child: CircularProgressIndicator())
          : PdfView(
        controller: _pdfController!,
        scrollDirection: Axis.vertical,
      ),
    );
  }
}
