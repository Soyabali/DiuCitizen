
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:puri/presentation/taxReceipt/receptCard.dart';
import '../../../app/generalFunction.dart';
import '../../../services/SearchPropertyTaxForPaymentRepo.dart';
import '../../../services/bindCityzenWardRepo.dart';
import '../../model/downloadReceiptModel.dart';
import '../../services/downloadPropertyTaxReceiptRepo.dart';
import 'dart:async';


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
  String _searchQuery = '';
  Timer? _debounce;
  var pageCode;

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
              .getPendingApprovalReim(context, formDate!, toDate!,pageCode);
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
              .getPendingApprovalReim(context, formDate!, toDate!,pageCode);
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
            .getPendingApprovalReim(context, formDate!, toDate!,pageCode);
      });
    } else {
      print("-- Not calling API, dates missing --");
    }
  }
  // searchBar
  Widget buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.only(left: 10, right: 10),
      child: Container(
        // 1. Decorate the outer Container for the border
        decoration: BoxDecoration(
          color: Colors.white, // White background for the TextFormField area
          borderRadius: BorderRadius.circular(8.0), // Optional: for rounded corners
          border: Border.all(
            color: Colors.grey.shade300, // Light gray border color
            width: 1.0,                 // Border width
          ),
        ),
        child: TextFormField(
          controller: _searchController,
          decoration: const InputDecoration(
            hintText: 'Enter keywords',
            prefixIcon: Icon(Icons.search),
            // 2. Remove the default underline border of TextFormField
            border: InputBorder.none,
            // 3. Ensure content padding is appropriate if needed
            contentPadding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0), // Adjust as needed
          ),
          onChanged: _onSearchChanged,
          // Optional: Style the text input area itself if default white isn't enough
          // style: TextStyle(backgroundColor: Colors.white),
        ),
      ),
    );
  }

  getEmergencyTitleResponse(selectedWardId, String houseno, String houseOwnerName) async {
    // final List<dynamic> list = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    // emergencyTitleList = await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(context,selectedWardId,houseno,houseOwnerName);
    // print('------57-----xxxx---xx----$emergencyTitleList');
    // setState(() {
    //   isLoading = false;
    // });

    setState(() {
      isLoading = true;
    });

    final response =
    await SearchPropertyTaxForPaymentRepo().searchPropertyTaxForPayment(
        context, selectedWardId, houseno, houseOwnerName);

    /// 🔹 SAME LIST AS BEFORE
    emergencyTitleList = response.data;

    /// 🔹 NEW: message & result
    print("Result 👉 ${response.result}");
    print("Message 👉 ${response.message}");

    if (emergencyTitleList == null || emergencyTitleList!.isEmpty) {
     // displayToast(response.message); // ✅ dynamic API msg
    }

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

  late Future<List<DownloadReceiptModel>> getPendingApprovalReim;
  // List<DownloadReceiptModel> _allData = []; // Holds original data
  // List<DownloadReceiptModel> _filteredData = [];


  hrmsReimbursementStatus(String firstOfMonthDay, String lastDayOfCurrentMonth) async {
    getPendingApprovalReim = GetPendingforApprovalReimRepo().getPendingApprovalReim(context, firstOfMonthDay, lastDayOfCurrentMonth,pageCode);
    print("------xxx---203------$getPendingApprovalReim");

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


  Future<void> loadData(String? formDate, String? toDate) async {
    final data = await GetPendingforApprovalReimRepo().getPendingApprovalReim(
      context,
      formDate!,
      toDate!,
      pageCode
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
    pageCode = "${widget.pageCode}";
    print("--xxxxxxx---xx--: 269---:  ${pageCode}");

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
      pageCode
    );
  }
  @override
  void dispose() {
    // TODO: implement dispose
    _housefocus.dispose();
    _houseController.dispose();
    _houseOwnerfocus.dispose();
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  //  filter data
  List<DownloadReceiptModel> _applyFilter(String q, List<DownloadReceiptModel> src) {
    final query = q.trim().toLowerCase();
    if (query.isEmpty) return List.of(src);

    return src.where((r) {
      final code   = (r.sReceiptCode ?? '').toLowerCase();
      final url    = (r.sReceiptURL  ?? '').toLowerCase();
      final amount = r.fReceiptAmount.toString();     // "100.0"
      final date   = (r.dReceiptDate ?? '').toLowerCase();
      return code.contains(query) ||
          url.contains(query) ||
          amount.contains(query) ||
          date.contains(query);
    }).toList();
  }

  void _onSearchChanged(String value) {
    // Optional debounce (250ms) for smoother typing
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    _debounce = Timer(const Duration(milliseconds: 250), () {
      setState(() {
        _searchQuery = value;
        _filteredData = _applyFilter(_searchQuery, _allData);
      });
    });
  }


  // this is a widget that bind listView data
  Widget buildReceiptListView() {
    if (_future == null) {
      return const Center(child: Text("Loading..."));
    }

    return FutureBuilder<List<DownloadReceiptModel>>(
      future: _future,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return const Center(child: Text("No Data Found"));
        }

        final data = snapshot.data ?? [];
        if (data.isEmpty) {
          return const Center(child: Text("No Data Found"));
        }

        // Seed once after a fresh API load
        if (_allData.isEmpty) {
          _allData = data;
          _filteredData = _applyFilter(_searchQuery, _allData);
        }

        if (_filteredData.isEmpty) {
          return const Center(child: Text("No matches"));
        }

        // Fully scrollable list
        return RefreshIndicator(
          onRefresh: () async {
            // optional: reload with same date range if you keep them in state
            // _loadReceipts(formDate!, toDate!);
            // await _future;
          },
          child: ListView.builder(
            itemCount: _filteredData.length,
            itemBuilder: (context, index) {
              final r = _filteredData[index];
              return ReceiptCard(
                sReceiptURL: r.sReceiptURL,
                sReceiptCode: r.sReceiptCode,
                fReceiptAmount: r.fReceiptAmount,
                dReceiptDate: r.dReceiptDate,
              );
            },
          ),
        );
      },
    );
  }
  // fromDateSelectionLogic
  // You can keep your existing fromDateSelectLogic if it's used elsewhere,
// or adapt/rename it. Here's a version focused on validation:

  Future<bool> validateFromDateSelection(String selectedFromDate, String? currentToDate) async {
    // Check if toDate is even selected. If not, any fromDate is potentially valid on its own.
    if (currentToDate == null || currentToDate.isEmpty) {
      return true; // No "To Date" to compare against, so "From Date" is fine for now
    }

    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime fromDateAsDateTime = dateFormat.parse(selectedFromDate);
    DateTime toDateAsDateTime = dateFormat.parse(currentToDate);

    if (fromDateAsDateTime.isAfter(toDateAsDateTime)) {
      displayToast("From date cannot be greater than To Date");
      return false; // Validation failed
    }
    return true; // Validation passed
  }

// You'll also need a similar validation for when "To Date" is selected
  Future<bool> validateToDateSelection(String? currentFromDate, String selectedToDate) async {
    if (currentFromDate == null || currentFromDate.isEmpty) {
      return true; // No "From Date" to compare against
    }

    DateFormat dateFormat = DateFormat("dd/MMM/yyyy");
    DateTime fromDateAsDateTime = dateFormat.parse(currentFromDate);
    DateTime toDateAsDateTime = dateFormat.parse(selectedToDate);

    if (toDateAsDateTime.isBefore(fromDateAsDateTime)) {
      displayToast("To date cannot be earlier than From Date");
      return false; // Validation failed
    }
    return true; // Validation passed
  }

// Your displayToast function (if not already defined)
  void displayToast(String message) {
    // Implement your toast message display (e.g., using fluttertoast package)
    // Fluttertoast.showToast(msg: message);
    print("TOAST: $message"); // Placeholder
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
          body:

          Container(
            color: Colors.white,
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
                                  // Inside your From Date Picker's GestureDetector:
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      // Try to set initialDate intelligently, perhaps based on current formDate or toDate
                                      initialDate: formDate != null && formDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(formDate!)
                                          : (toDate != null && toDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(toDate!) // Or some logic relative to toDate
                                          : DateTime.now()),
                                      firstDate: DateTime(2000),
                                      // Crucially, lastDate for "From Date" picker should not be after "To Date" if "To Date" is already selected
                                      lastDate: toDate != null && toDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(toDate!) // Can't pick a "From Date" after the current "To Date"
                                          : DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      String newSelectedFromDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                      String? currentToDate = toDate; // Get current toDate

                                      // --- TEMPORARILY SET formDate FOR VALIDATION ---
                                      // This allows fromDateSelectLogic to use the newly picked date
                                      String? previousFromDate = formDate; // Store previous valid fromDate to revert if needed
                                      setState(() {
                                        formDate = newSelectedFromDate;
                                      });

                                      // --- APPLY YOUR VALIDATION LOGIC ---
                                      // We'll adapt fromDateSelectLogic to return a boolean indicating success
                                      bool isValidSelection = await validateFromDateSelection(newSelectedFromDate, currentToDate);

                                      if (isValidSelection) {
                                        // If valid, proceed with API call using the newSelectedFromDate
                                        setState(() {
                                          // formDate is already set to newSelectedFromDate
                                          _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                              context,
                                              newSelectedFromDate, // Use the validated new fromDate
                                              currentToDate!,     // Use existing toDate
                                              pageCode
                                          );
                                          _allData = [];
                                          _filteredData = [];
                                        });
                                      } else {
                                        // If not valid, revert formDate to its previous state
                                        setState(() {
                                          formDate = previousFromDate; // Revert to the old valid date
                                        });
                                        // The toast message should be handled by validateFromDateSelection
                                      }
                                    }
                                  },


                                  // onTap: () async {
                                  //   DateTime? pickedDate = await showDatePicker(
                                  //     context: context,
                                  //     initialDate: DateTime.now(),
                                  //     firstDate: DateTime(2000),
                                  //     lastDate: DateTime(2100),
                                  //   );
                                  //
                                  //   if (pickedDate != null) {
                                  //     String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                  //     setState(() {
                                  //       formDate = formattedDate;
                                  //       // ✅ API call with NEW fromDate and EXISTING toDate
                                  //       _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                  //         context,
                                  //         formDate!,
                                  //         toDate!, // Keep initState or latest toDate
                                  //         pageCode
                                  //       );
                                  //       _allData = [];
                                  //       _filteredData = [];
                                  //     });
                                  //   }
                                  // },
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
                                  // Inside your To Date Picker's GestureDetector:
                                  onTap: () async {
                                    DateTime? pickedDate = await showDatePicker(
                                      context: context,
                                      initialDate: toDate != null && toDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(toDate!)
                                          : (formDate != null && formDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(formDate!)
                                          : DateTime.now()),
                                      // "To Date" cannot be before "From Date"
                                      firstDate: formDate != null && formDate!.isNotEmpty
                                          ? DateFormat('dd/MMM/yyyy').parse(formDate!)
                                          : DateTime(2000),
                                      lastDate: DateTime(2100),
                                    );

                                    if (pickedDate != null) {
                                      String newSelectedToDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                      String? currentFromDate = formDate;

                                      String? previousToDate = toDate; // Store previous valid toDate
                                      setState(() {
                                        toDate = newSelectedToDate; // Temporarily set for validation
                                      });

                                      bool isValidSelection = await validateToDateSelection(currentFromDate, newSelectedToDate);

                                      if (isValidSelection) {
                                        setState(() {
                                          // toDate is already set to newSelectedToDate
                                          _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                              context,
                                              currentFromDate!, // Use existing fromDate
                                              newSelectedToDate,  // Use the validated new toDate
                                              pageCode
                                          );
                                          _allData = [];
                                          _filteredData = [];
                                        });
                                      } else {
                                        setState(() {
                                          toDate = previousToDate; // Revert to old valid date
                                        });
                                      }
                                    }
                                  },

                                  // onTap: () async {
                                  //   DateTime? pickedDate = await showDatePicker(
                                  //     context: context,
                                  //     initialDate: DateTime.now(),
                                  //     firstDate: DateTime(2000),
                                  //     lastDate: DateTime(2100),
                                  //   );
                                  //
                                  //   if (pickedDate != null) {
                                  //     String formattedDate = DateFormat('dd/MMM/yyyy').format(pickedDate);
                                  //     setState(() {
                                  //       toDate = formattedDate;
                                  //       // ✅ API call with EXISTING fromDate and NEW toDate
                                  //       _future = GetPendingforApprovalReimRepo().getPendingApprovalReim(
                                  //         context,
                                  //         formDate!, // Keep initState or latest fromDate
                                  //         toDate!,
                                  //         pageCode
                                  //       );
                                  //       _allData = [];
                                  //       _filteredData = [];
                                  //     });
                                  //   }
                                  // },
                                  child: dateContainer(toDate ?? "Select To Date"),
                                ),
                              ],
                            )
                        ),
                      ],
                    )
                  ),
                  SizedBox(height: 5),
                  Material(
                    color: Theme.of(context).cardColor,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      child: buildSearchBar(),
                    ),
                  ),
                  SizedBox(height: 5),
                  Expanded(child: buildReceiptListView()),
                ],
              ),
          ),
          ),

    );
  }
}
