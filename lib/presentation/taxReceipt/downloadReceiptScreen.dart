import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:pdfx/pdfx.dart';
import 'package:share_plus/share_plus.dart';
import 'package:uuid/uuid.dart';
import '../resources/app_text_style.dart';
import 'package:share_plus/share_plus.dart';

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

  // shareCode
  Future<void> sharePdf(BuildContext context, String pdfUrl) async {
    try {
      final response = await http.get(Uri.parse(pdfUrl));

      if (response.statusCode == 200) {
        final dir = await getTemporaryDirectory();
        final file = File('${dir.path}/receipt.pdf');

        await file.writeAsBytes(response.bodyBytes);

        final box = context.findRenderObject() as RenderBox?;

        await Share.shareXFiles(
          [XFile(file.path)],
          text: 'Receipt PDF',
          subject: 'Receipt PDF',
          sharePositionOrigin:
          box!.localToGlobal(Offset.zero) & box.size, // 🔥 FIX
        );
      } else {
        debugPrint('Failed to download PDF');
      }
    } catch (e) {
      debugPrint('Share error: $e');
    }
  }

  // Future<void> sharePdf(String pdfUrl) async {
  //   try {
  //     final response = await http.get(Uri.parse(pdfUrl));
  //
  //     if (response.statusCode == 200) {
  //       final dir = await getTemporaryDirectory();
  //       final file = File('${dir.path}/receipt.pdf');
  //
  //       await file.writeAsBytes(response.bodyBytes);
  //
  //       await Share.shareXFiles(
  //         [XFile(file.path)],
  //         text: 'Receipt PDF',
  //         subject: 'Receipt PDF',
  //       );
  //     } else {
  //       debugPrint('Failed to download PDF');
  //     }
  //   } catch (e) {
  //     debugPrint('Share error: $e');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        // statusBarColore
        systemOverlayStyle: const SystemUiOverlayStyle(
          statusBarColor: Color(0xFF12375e),
          statusBarIconBrightness: Brightness.dark, // For Android (dark icons)
          statusBarBrightness: Brightness.light, // For iOS (dark icons)
        ),
        // backgroundColor: Colors.blu
        centerTitle: true,
        backgroundColor: Color(0xFF255898),
        leading: GestureDetector(
          onTap: (){
            print("------back---");
            Navigator.pop(context);
          },
          child: const Padding(
            padding: EdgeInsets.all(8.0),
            child: Icon(Icons.arrow_back_ios,
              color: Colors.white,),
          ),
        ),
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5),
          child: Text(
            'Download Receipt',
            style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
            textAlign: TextAlign.center,
          ),
        ),
          actions: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: IconButton(
                icon: const Icon(Icons.share, color: Colors.white),
                onPressed: () {
                  sharePdf(context, widget.pdfUrl);
                },
              ),
            ),
            // IconButton(
            //   icon: const Icon(Icons.share, color: Colors.white),
            //   iconSize: 24,
            //   constraints: const BoxConstraints(
            //     minWidth: 44,
            //     minHeight: 44, // 🔥 REQUIRED FOR iOS
            //   ),
            //   onPressed: () {
            //     print("-----157------");
            //     sharePdf(widget.pdfUrl);
            //   },
            // ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: IconButton(
            //     onPressed: () {
            //       print("-----157------");
            //       sharePdf(widget.pdfUrl);
            //       // final pdfUrl = widget.pdfUrl;
            //       //
            //       // Share.share(
            //       //   'Download your receipt PDF:\n$pdfUrl',
            //       //   subject: 'Receipt PDF',
            //       // );
            //     },
            //     icon: const Icon(Icons.share, color: Colors.white),
            //   ),
            // )
        ],
        //centerTitle: true,
        elevation: 0, // Removes shadow under the AppBar
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
