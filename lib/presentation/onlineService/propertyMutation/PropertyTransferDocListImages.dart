import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../app/generalFunction.dart';
import '../../../../services/GetLicenceDataDocsRepo.dart';
import '../../../services/PropertyTransferDocListRepo.dart';
import '../../fullscreen/imageDisplay.dart';
import '../../nodatavalue/NoDataValue.dart';
import '../../resources/app_text_style.dart';

class PropertyTransferDocListImages extends StatefulWidget {

  final licenseRequestId;
  const PropertyTransferDocListImages({super.key, required this.licenseRequestId});

  @override
  State<PropertyTransferDocListImages> createState() => _LicenseStatusImagesState();
}

class _LicenseStatusImagesState extends State<PropertyTransferDocListImages> {

  // initState
  List<Map<String, dynamic>>? pendingInternalComplaintList;
  List<Map<String, dynamic>> _filteredData = [];
  bool isLoading = true;

  // Api response

  pendingInternalComplaintResponse(licenseNO) async {
    pendingInternalComplaintList = await PropertyTransferDocListRepo().propertyTransferDocs(context,licenseNO);
    print('-----27--->>>>>>----$pendingInternalComplaintList');
    _filteredData = List<Map<String, dynamic>>.from(pendingInternalComplaintList ?? []);

    setState(() {
      // parkList=[];
      isLoading = false;
    });
  }
  var licenseNO;

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
          child:  GridView.builder(
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, // 2 items per row
              crossAxisSpacing: 8.0,
              mainAxisSpacing: 8.0,
              childAspectRatio: 0.7, // Adjust as per design
            ),
            itemCount: pendingInternalComplaintList?.length ?? 0,
            itemBuilder: (context, index) {
              final item = pendingInternalComplaintList![index];
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
                          style: AppTextStyle.font14OpenSansRegularBlack45TextStyle
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: (){
                          print("------89----Open Image---");
                          // FullScreenImages
                          // navigate on screen to another screen
                          var image = "${item["sDocumentUrl"]}";
                          print("----Image---93-->$image");

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => FullScreenImages(image:image)),);
                        },
                        child: Image.network(
                          item["sDocumentUrl"] ?? "",
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) => Icon(Icons.broken_image, size: 50, color: Colors.grey),
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
