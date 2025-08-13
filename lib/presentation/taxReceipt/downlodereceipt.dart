import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puri/presentation/taxReceipt/receptCard.dart';
import '../../../app/generalFunction.dart';
import '../../../services/SearchPropertyTaxForPaymentRepo.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../model/downloadReceiptModel.dart';
import '../../services/downloadPropertyTaxReceiptRepo.dart';
import '../aboutDiu/Aboutdiupage.dart';
import '../resources/app_text_style.dart';


class DownlodeReceipt extends StatefulWidget {

  final pageName,pageCode;
  const DownlodeReceipt({super.key, required this.pageName, required this.pageCode});

  @override
  State<DownlodeReceipt> createState() => _PropertyTaxState();
}

class _PropertyTaxState extends State<DownlodeReceipt> {

  GeneralFunction generalFunction = GeneralFunction();
  List<dynamic> wardList = [];
  var _dropDownWard;
  //
  TextEditingController _houseController = TextEditingController();
  TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  //   return _future == null
  //         ? Center(child: Text("Loading..."))
  //         : FutureBuilder<List<DownloadReceiptModel>>(
  //       future: _future,
  //       builder: (context, snapshot) {
  //         if (snapshot.connectionState == ConnectionState.waiting) {
  //           return Center(child: CircularProgressIndicator());
  //         }
  //
  //         if (snapshot.hasError) {
  //
  //          // return Center(child: Text("❌ Error: ${snapshot.error}"));
  //           return Center(child: Text("No Data Found"));
  //
  //         }
  //
  //         final receipts = snapshot.data;
  //         if (receipts == null || receipts.isEmpty) {
  //           return Center(child: Text("No Data Found"));
  //         }
  //
  //         return ListView.builder(
  //           shrinkWrap: true,
  //           physics: NeverScrollableScrollPhysics(),
  //           itemCount: receipts.length,
  //           itemBuilder: (context, index) {
  //             final receipt = receipts[index];
  //             return ReceiptCard(
  //               sReceiptURL: receipt.sReceiptURL,
  //               sReceiptCode: receipt.sReceiptCode,
  //               fReceiptAmount: receipt.fReceiptAmount,
  //               dReceiptDate: receipt.dReceiptDate,
  //             );

  FocusNode _housefocus = FocusNode();
  FocusNode _houseOwnerfocus = FocusNode();
  //
  List<Map<String,dynamic>>? emergencyTitleList;
  List<Map<String,dynamic>>? emergencyTitleList2;
  bool isLoading = true; // logic
  String? sName, sContactNo;
  var houseNo;
  String? tempDate;
  String? formDate;
  String? toDate;
  List<dynamic> empList = [];
  var firstOfMonthDay,lastDayOfCurrentMonth;
  Future<List<DownloadReceiptModel>>? _future;
  List<DownloadReceiptModel> _allData = []; // Holds original data
  List<DownloadReceiptModel> _filteredData = [];


  final List<Color> borderColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.pink,
    Colors.teal,
    Colors.brown,
    Colors.cyan,
    Colors.amber,
  ];
  // GeneralFunction generalFunction = GeneralFunction();


  //

  void fromDateSelectLogic() {
    if (formDate != null && formDate!.isNotEmpty &&
        toDate != null && toDate!.isNotEmpty) {

      DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
      DateTime fromDate2 = dateFormat.parse(formDate!);
      DateTime toDate2 = dateFormat.parse(toDate!);

      if (fromDate2.isAfter(toDate2)) {
        setState(() {
          formDate = tempDate; // Reset to previous valid date
        });
        displayToast("From date cannot be greater than To Date");
      } else {
        // ✅ Call API
        setState(() {
          _future = GetPendingforApprovalReimRepo()
              .getPendingApprovalReim(context, formDate!, toDate!);
        });
      }
    } else {
      print("-- Dates not selected, API not called --");
    }
  }
  // toDateSelectedLogic
  void toDateSelectLogic() {
    if (formDate != null && formDate!.isNotEmpty &&
        toDate != null && toDate!.isNotEmpty) {

      DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
      DateTime fromDate2 = dateFormat.parse(formDate!);
      DateTime toDate2 = dateFormat.parse(toDate!);

      if (toDate2.isBefore(fromDate2)) {
        setState(() {
          toDate = tempDate; // revert to old valid date
        });
        displayToast("To Date cannot be less than From Date");
      } else {
        // ✅ Call API if both dates are valid
        setState(() {
          _future = GetPendingforApprovalReimRepo()
              .getPendingApprovalReim(context, formDate!, toDate!);
        });
      }
    } else {
      print("-- To Date not selected, API not called --");
    }
  }

  getCurrentdate() async {
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    formDate = DateFormat('dd/MM/yyyy').format(firstDayOfMonth);
    toDate = DateFormat('dd/MM/yyyy').format(lastDayOfMonth);

    // ✅ Check if both fromDate & toDate are set and not empty
    if (formDate != null && formDate!.isNotEmpty &&
        toDate != null && toDate!.isNotEmpty) {
      setState(() {
        _future = GetPendingforApprovalReimRepo()
            .getPendingApprovalReim(context, formDate!, toDate!);
      });
    } else {
      print("-- Not calling API, dates missing --");
    }
  }


  getEmergencyTitleResponse(selectedWardId, String houseno, String houseOwnerName) async {
    // final List<dynamic> list = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    emergencyTitleList = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    print('------57-----xxxx---xx----$emergencyTitleList');
    setState(() {
      isLoading = false;
    });
  }
  // online title
  var OnlineTitle = ["Property Tax",
    "Building Plan",
    "Property Assessment",
    "License",
    "Community Hall",
    "Water Supply",
    "Electricity Bill",
    "Mamlatdar Diu"
  ];


  var _selectedWardId;
  // dropDown
  bindWard() async {
    wardList = await BindCityzenWardRepo().getbindWard(context);
    print(" -----xxxxx-  wardList--50---> $wardList");
    setState(() {});
  }
  // bind
  Widget _bindWard() {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10.0),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 42,
          color: Color(0xFF255898), // Background color
          child: DropdownButtonHideUnderline(
            child: ButtonTheme(
              alignedDropdown: true,
              child: DropdownButton(
                isDense: true, // Reduces the vertical size of the button
                isExpanded: true, // Allows the DropdownButton to take full width
                dropdownColor: Colors.grey, // Set dropdown list background color
                iconEnabledColor: Colors.white, // Icon color (keeps the icon white)
                hint: RichText(
                  text: TextSpan(
                    text: "Select Ward",
                    style: AppTextStyle.font14OpenSansRegularWhiteTextStyle,
                  ),
                ),
                value: _dropDownWard,
                onChanged: (newValue) {
                  setState(() {
                    _dropDownWard = newValue;
                    wardList.forEach((element) {
                      if (element["sWardName"] == _dropDownWard) {
                        _selectedWardId = element['sWardCode'];
                      }
                    });
                    print("------99-----$_selectedWardId");
                  });
                },
                style: TextStyle(color: Colors.white), // Selected item text color
                items: wardList.map((dynamic item) {
                  return DropdownMenuItem(
                    value: item["sWardName"].toString(),
                    child: Row(
                      children: [
                        Expanded(
                          child: Text(
                            item['sWardName'].toString(),
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(color: Colors.white), // Dropdown menu item text color
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  // toDate and fromDate selecredLogic




  late Future<List<DownloadReceiptModel>> getPendingApprovalReim;
  // List<DownloadReceiptModel> _allData = []; // Holds original data
  // List<DownloadReceiptModel> _filteredData = [];


  hrmsReimbursementStatus(String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    getPendingApprovalReim = GetPendingforApprovalReimRepo().getPendingApprovalReim(context, firstOfMonthDay, lastDayOfCurrentMonth);
    print("------xxx---232------$getPendingApprovalReim");

    getPendingApprovalReim.then((data) {
      setState(() {
        _allData = data; // Store the data
        _filteredData = _allData; // Initially, no filter applied
      });
    });
  }
 // filter data
  void filterData(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredData = List.from(_allData); // Show all if search is empty
      } else {
        _filteredData = _allData.where((item) {
          final urlMatch = item.sReceiptURL.toLowerCase().contains(query.toLowerCase());
          final codeMatch = item.sReceiptCode.toLowerCase().contains(query.toLowerCase());
          return urlMatch || codeMatch;
        }).toList();
      }
    });
  }
 //  void filterData(String query) {
 //    setState(() {
 //      if (query.isEmpty) {
 //        _filteredData = _allData; // Show all data if search query is empty
 //      } else {
 //        _filteredData = _allData.where((item) {
 //          return item.sReceiptURL
 //              .toLowerCase()
 //              .contains(query.toLowerCase()) || // Filter by project name
 //              item.sReceiptCode.toLowerCase().contains(query.toLowerCase());
 //
 //          // Filter by employee name
 //        }).toList();
 //      }
 //    });
 //  }
  //

  Future<void> loadData(String? formDate, String? toDate) async {
    final data = await GetPendingforApprovalReimRepo().getPendingApprovalReim(
      context,
      formDate!,
      toDate!,
    );
    setState(() {
      _allData = data;
      _filteredData = List.from(data); // Initially show all
    });
  }

  Widget dateContainer(String text) {
    return Container(
      height: 35,
      padding: const EdgeInsets.symmetric(horizontal: 14.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
      ),
      child: Center(
        child: Text(
          text,
          style: const TextStyle(color: Colors.grey, fontSize: 12.0),
        ),
      ),
    );
  }


  @override
  void initState() {
    // TODO: implement initState
   // getCurrentdate();
    //bindWard();
    _housefocus = FocusNode();
   // datePickLogic();
    super.initState();
    DateTime now = DateTime.now();
    DateTime firstDayOfMonth = DateTime(now.year, now.month, 1);
    DateTime firstDayOfNextMonth = DateTime(now.year, now.month + 1, 1);
    DateTime lastDayOfMonth = firstDayOfNextMonth.subtract(const Duration(days: 1));

    formDate = DateFormat('dd/MMM/yyyy').format(firstDayOfMonth);
    toDate = DateFormat('dd/MMM/yyyy').format(lastDayOfMonth);

    //Initial API call
    _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
      context,
      formDate!,
      toDate!,
    );
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   loadData(formDate,toDate); // ✅ Called after the first frame to avoid setState issues
    // });


  }
  @override
  void dispose() {
    // TODO: implement dispose
    _housefocus.dispose();
    _houseController.dispose();
    _houseOwnerfocus.dispose();
    _searchController.dispose();
    super.dispose();
  }

  // this is a widget that bind listView data
  Widget buildReceiptListView() {
    return _future == null
        ? Center(child: Text("Loading..."))
        : FutureBuilder<List<DownloadReceiptModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError) {

         // return Center(child: Text("❌ Error: ${snapshot.error}"));
          return Center(child: Text("No Data Found"));

        }

        final receipts = snapshot.data;
        if (receipts == null || receipts.isEmpty) {
          return Center(child: Text("No Data Found"));
        }
        // search file
        final q = _searchQuery.trim().toLowerCase();
        final visible = q.isEmpty
            ? receipts
            : receipts.where((r) {
          final urlMatch  = r.sReceiptCode.toLowerCase().contains(q);
          final codeMatch = r.sReceiptCode.toLowerCase().contains(q);
          return urlMatch || codeMatch;
        }).toList();

        if (visible.isEmpty) {
          return const Center(child: Text("No matches"));
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: receipts.length,
          itemBuilder: (context, index) {
            final receipt = receipts[index];
            return ReceiptCard(
              sReceiptURL: receipt.sReceiptURL,
              sReceiptCode: receipt.sReceiptCode,
              fReceiptAmount: receipt.fReceiptAmount,
              dReceiptDate: receipt.dReceiptDate,
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: (){
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          backgroundColor: Colors.white,
          appBar: getAppBarBack(context,'${widget.pageName}'),
          body: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Container(
                 color: Color(0xFF255898),        //Color(0xFF255898),
                  height: 50,
                  child:Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              const SizedBox(width: 4),
                              Icon(Icons.calendar_month, size: 15, color: Colors.white),
                              const SizedBox(width: 4),
                              const Text('From', style: TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 4),

                              // FROM DATE PICKER
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                    setState(() {
                                      formDate = formattedDate;
                                      // ✅ API call with NEW fromDate and EXISTING toDate
                                      _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                        context,
                                        formDate!,
                                        toDate!, // Keep initState or latest toDate
                                      );
                                    });
                                  }
                                },
                                child: dateContainer(formDate ?? "Select From Date"),
                              ),

                              const SizedBox(width: 6),
                              Container(
                                height: 32,
                                width: 32,
                                child: Image.asset("assets/images/reimicon_2.png", fit: BoxFit.contain),
                              ),
                              const SizedBox(width: 8),
                              Icon(Icons.calendar_month, size: 16, color: Colors.white),
                              const SizedBox(width: 5),
                              const Text('To', style: TextStyle(color: Colors.white, fontSize: 12)),
                              const SizedBox(width: 5),

                              // TO DATE PICKER
                              GestureDetector(
                                onTap: () async {
                                  DateTime? pickedDate = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime(2000),
                                    lastDate: DateTime(2100),
                                  );

                                  if (pickedDate != null) {
                                    String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                    setState(() {
                                      toDate = formattedDate;
                                      // ✅ API call with EXISTING fromDate and NEW toDate
                                      _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                        context,
                                        formDate!, // Keep initState or latest fromDate
                                        toDate!,
                                      );
                                    });
                                  }
                                },
                                child: dateContainer(toDate ?? "Select To Date"),
                              ),
                            ],
                          )

                          // child: Row(
                          //   mainAxisAlignment: MainAxisAlignment.start,
                          //   children: [
                          //     const SizedBox(width: 4),
                          //     Icon(Icons.calendar_month,
                          //         size: 15, color: Colors.white),
                          //     const SizedBox(width: 4),
                          //     const Text(
                          //       'From',
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.normal),
                          //     ),
                          //     SizedBox(width: 4),
                          //     GestureDetector(
                          //       onTap: () async {
                          //         DateTime? pickedDate = await showDatePicker(
                          //           context: context,
                          //           initialDate: DateTime.now(),
                          //           firstDate: DateTime(2000),
                          //           lastDate: DateTime(2100),
                          //         );
                          //
                          //         if (pickedDate != null) {
                          //           String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                          //
                          //           setState(() {
                          //             formDate = formattedDate;
                          //
                          //             // ✅ Always call API when fromDate is selected
                          //             _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                          //               context,
                          //               formDate!,
                          //               toDate != null && toDate!.isNotEmpty
                          //                   ? toDate!
                          //                   : DateFormat('dd/MMM/yyyy').format(DateTime.now()), // fallback
                          //             );
                          //            });
                          //           print("-------450----$formDate");
                          //           print("-------451----$toDate");
                          //           print("-------452----${_future}");
                          //         }
                          //       },
                          //       child: Container(
                          //         height: 35,
                          //         padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(15),
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             formDate ?? "Select From Date",
                          //             style: const TextStyle(
                          //               color: Colors.grey,
                          //               fontSize: 12.0,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     ),
                          //
                          //     SizedBox(width: 6),
                          //     Container(
                          //       height: 32,
                          //       width: 32,
                          //       child: Image.asset(
                          //         "assets/images/reimicon_2.png",
                          //         fit: BoxFit
                          //             .contain, // or BoxFit.cover depending on the desired effect
                          //       ),
                          //     ),
                          //     //Icon(Icons.arrow_back_ios,size: 16,color: Colors.white),
                          //     SizedBox(width: 8),
                          //     const Icon(Icons.calendar_month,
                          //         size: 16, color: Colors.white),
                          //     SizedBox(width: 5),
                          //     const Text(
                          //       'To',
                          //       style: TextStyle(
                          //           color: Colors.white,
                          //           fontSize: 12,
                          //           fontWeight: FontWeight.normal),
                          //     ),
                          //     SizedBox(width: 5),
                          //     GestureDetector(
                          //       onTap: () async {
                          //         DateTime? pickedDate = await showDatePicker(
                          //           context: context,
                          //           initialDate: DateTime.now(),
                          //           firstDate: DateTime(2000),
                          //           lastDate: DateTime(2100),
                          //         );
                          //
                          //         if (pickedDate != null) {
                          //           String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                          //
                          //           setState(() {
                          //             toDate = formattedDate;
                          //
                          //             // ✅ Always call API when toDate is selected
                          //             _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                          //               context,
                          //               formDate != null && formDate!.isNotEmpty
                          //                   ? formDate!
                          //                   : DateFormat('dd/MMM/yyyy').format(DateTime.now()), // fallback
                          //               toDate!,
                          //             );
                          //           });
                          //         }
                          //       },
                          //       child: Container(
                          //         height: 35,
                          //         padding: const EdgeInsets.symmetric(horizontal: 14.0),
                          //         decoration: BoxDecoration(
                          //           color: Colors.white,
                          //           borderRadius: BorderRadius.circular(15),
                          //         ),
                          //         child: Center(
                          //           child: Text(
                          //             toDate ?? "Select To Date",
                          //             style: const TextStyle(
                          //               color: Colors.grey,
                          //               fontSize: 12.0,
                          //             ),
                          //           ),
                          //         ),
                          //       ),
                          //     )
                          //   ],
                          // ),
                      ),
                    ],
                  )
                ),
                SizedBox(height: 5),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 10),
                    // child: SearchBar(),
                    child: Container(
                      height: 45,
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.grey, // Outline border color
                          width: 0.2, // Outline border width
                        ),
                        color: Colors.white,
                      ),
                      child: Center(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 0),
                          child: Row(
                            children: [
                              Expanded(
                                child: TextFormField(
                                  controller: _searchController,
                                  autofocus: true,
                                  decoration: const InputDecoration(
                                    hintText: 'Enter Keywords',
                                    prefixIcon: Icon(Icons.search),
                                    hintStyle: TextStyle(
                                        fontFamily: 'Montserrat',
                                        color: Color(0xFF707d83),
                                        fontSize: 14.0,
                                        fontWeight: FontWeight.bold),
                                    border: InputBorder.none,
                                  ),
                                    onChanged: (value) {
                                      setState(() {
                                        _searchQuery = value; // <- triggers a rebuild; list will re-filter
                                      });
                                    },
                                    //filterData(query); // Call the filter function on text input change

                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 5),
                buildReceiptListView()


              ],
            ),
          ),

        )
    );

  }
  // paymentDialog widget
  Widget paymentDialog(BuildContext dialogContext){
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // 🔶 Gradient Header
          Container(
            height: 45,
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFFF15C3B), // First color: #ff5e62 (a warm coral)
                  Color(0xFF005BAC), // Second color: #005BAC (a deep blue)
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12),
                  child: Text(
                    'Choose Payment Gateway',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
                IconButton(
                    icon: Icon(Icons.close, color: Colors.white),
                    onPressed: () {
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }
                    }
                ),
              ],
            ),
          ),
          // 💳 Payment Options
          Container(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // First Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
                      // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
                      var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var sPageName = "Property Tax";

                      // close the DialogBox
                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AboutDiuPage(name: sPageName, sPageLink: baseurl)),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/bankborda.png',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'BOB',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(width: 12),

                // Second Card
                Expanded(
                  child: GestureDetector(
                    onTap: () {

                      var iWardCode = "${emergencyTitleList![0]['iWardCode']}";
                      // var houseNo = "${emergencyTitleList![index]['sHouseNo']}";
                      // var baseurl = "https://www.diusmartcity.com/PaymentGatewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var baseurl = "https://www.diusmartcity.com/SBIPropertyTaxDataformGetewayMobile.aspx?QS=$houseNo&iWardCode=$iWardCode";
                      var sPageName = "Property Tax";
                      print('-----baseURL--$baseurl');
                      // close the dialogbOS

                      if (Navigator.of(dialogContext).canPop()) {
                        Navigator.of(dialogContext).pop();
                      }

                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            AboutDiuPage(name: sPageName, sPageLink: baseurl)),
                      );
                    },
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/images/banksbi.png',
                              height: 30,
                            ),
                            SizedBox(width: 10),
                            const Text(
                              'SBI',
                              style: TextStyle(
                                color: Colors.black54,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

}
