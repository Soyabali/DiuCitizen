import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/GetLicenceDataDocsRepo.dart';
import '../../../services/assessmentRequestDocListRepo.dart';
import '../../../services/propertyAssessementPropertyRepo.dart';
import '../../fullscreen/imageDisplay.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';


class PropertyAssessementImages extends StatefulWidget {

  final licenseRequestId;
  const PropertyAssessementImages({super.key, required this.licenseRequestId});

  @override
  State<PropertyAssessementImages> createState() => _LicenseStatusImagesState();
}

class _LicenseStatusImagesState extends State<PropertyAssessementImages> {

  // initState
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>> _filteredData = [];
  bool isLoading = true;

  // Api response

  pendingInternalComplaintResponse(licenseNO) async {
    pendingInternalComplaintList = await AssessmentRequestDoclistRepo().getAssessmentDataDocs(context,licenseNO);
    print('-----32--->>>>>>----$pendingInternalComplaintList');
    _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }
  var licenseNO;

  // pdf Open

  void openPdf(BuildContext context, String pdfUrl) async {
    if (await canLaunchUrl(Uri.parse(pdfUrl))) {
      await launchUrl(Uri.parse(pdfUrl), mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Cannot open PDF")),
      );
    }
  }

  @override
  void initState() {
    // TODO: implement initStatep
    licenseNO = "${widget.licenseRequestId}";
    pendingInternalComplaintResponse(licenseNO);
    // pendingInternalComplaintResponse();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appbar
        appBar: getAppBarBack(context,'${"Images"}'),
        body: isLoading
            ? Center(child: Container())
            : (pendingInternalComplaintList == null || pendingInternalComplaintList!.isEmpty)
            ? NoDataScreenPage()
            :

        Center(
          child: GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Adjust as per design
            ),
            itemCount: pendingInternalComplaintList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = pendingInternalComplaintList![index];
              final documentUrl = item["sDocumentUrl"] ?? "";
              final isPdf = documentUrl.toLowerCase().endsWith('.pdf');

              return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item["sDocumentTypeName"] ?? "Unknown",
                        textAlign: TextAlign.center,
                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          print("------89----Open File---");
                          var fileUrl = documentUrl;
                          print("----File URL---93-->$fileUrl");

                          if (!isPdf) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => FullScreenImages(image: fileUrl),
                              ),
                            );
                          } else {
                            // Handle PDF case (e.g., open PDF viewer)
                            var fileUrl = documentUrl;
                            openPdf(context, fileUrl);
                            print("PDF tapped");
                          }
                        },
                        child: isPdf
                            ? Container(
                          color: Colors.grey[200],
                          child: const Center(
                            child: Icon(
                              Icons.picture_as_pdf,
                              color: Colors.red,
                              size: 60,
                            ),
                          ),
                        )
                            : Image.network(
                          documentUrl,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => const Icon(
                            Icons.broken_image,
                            size: 50,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        item["dCreatedDate"] ?? "Unknown Date",
                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ));

  }
}
