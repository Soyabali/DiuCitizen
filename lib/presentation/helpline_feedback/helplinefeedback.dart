
import 'package:flutter/material.dart';
import 'package:puri/presentation/helpline_feedback/twitte_page.dart';
import 'package:puri/presentation/helpline_feedback/website.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import '../../app/generalFunction.dart';
import 'package:url_launcher/url_launcher.dart' as UrlLauncher;
import '../../services/feedbackRepo.dart';
import '../resources/app_text_style.dart';
import '../resources/values_manager.dart';
import 'facebook.dart';
import 'instagrampage.dart';

class HelpLineFeedBack extends StatefulWidget {

  final String name;
  final String image;

  HelpLineFeedBack({Key? key,
    required this.name,
    required this.image}) : super(key: key);

  @override
  State<HelpLineFeedBack> createState() => _HelpLineFeedBackState();
}

class _HelpLineFeedBackState extends State<HelpLineFeedBack> {

  GeneralFunction generalFunction = GeneralFunction();

  TextEditingController _feedbackController = TextEditingController();
  final String phoneNumber = '918826772888';
  final String message = 'Hello';
  var result;
  var msg;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    super.dispose();
  }
  // call a api
  void validateAndCallApi() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Contact No
    String? sContactNo = prefs.getString('sContactNo');
    var feedback = _feedbackController.text.trim();
    if (feedback.isNotEmpty) {
      // All conditions met; call the API
      print('---Call API---');

     var  feedbackResponse = await FeedbackRepo().feedfack(context, feedback,sContactNo);
      print('----845---->>.--->>>>---$feedbackResponse');
      result = feedbackResponse['Result'];
      msg = feedbackResponse['Msg'];
      _feedbackController.clear();
      Navigator.pop(context);
      // Your API call logic here
    } else {
      displayToast(msg);
      // If conditions fail, display appropriate error messages
      print('--Not Call API--');
      if (feedback.isEmpty) {
        displayToast('Please enter Feedback');
        return;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: getAppBarBack(context,'HelpLine/Feedback'),
        body: ListView(
          children: <Widget>[
            SizedBox(height: 10),
            Stack(
              children: <Widget>[
                Center(
                  child: Image.asset(
                    "assets/images/Diu_icon-02.png",
                    // Replace with your image asset path
                    width: AppSize.s145,
                    height: AppSize.s145,
                    fit: BoxFit.contain, // Adjust as needed
                  ),
                ),
              ],
            ),
            SizedBox(height: 25),
            Container(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5,right: 5),
                    child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0,
                                horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color(0xFF255898),
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  /// TODO HERE GET A CURRECT LOCATION
                                  double lat = 19.80494797579724;
                                  double long = 85.81796005389619;
                                  launchGoogleMaps(lat,long);
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 80,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Diu Municipal Council Address',
                                                  style: AppTextStyle.font14OpenSansRegularBlackTextStyle,),
                                                SizedBox(height: 5),
                                                Text('Fort Road, Diu,(Union territory),India',
                                                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: const Icon(Icons.location_on,
                                                color: Color(0xFF255898),
                                                size:
                                                22), //Image.asset('assets/images/callicon.png',
                                          )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                         // SizedBox(height: 2),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color:Color(0xFF255898),
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  print('call---numbr--');
                                 // launchUrlString("tel://+91-6752-222002");
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 5),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Phone Number',
                                                  style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                                SizedBox(height: 5),
                                                Text("+91-9099910215",
                                                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                       // launchUrlString("tel://7520014455");
                                        launchUrlString("tel://9099910215");
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: const Icon(Icons.phone,
                                                color: Color(0xFF255898),
                                                size:
                                                22), //Image.asset('assets/images/callicon.png',
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            // padding: EdgeInsets.only(left: 5,right: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                border: Border.all(
                                  color:Color(0xFF255898),
                                  // Set the golden border color
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {
                                  UrlLauncher.launch('mailto:${'jagannath@nic.in'}');
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Email id',
                                                    style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                                SizedBox(height: 5),
                                                Text('dmc-diu-dd@nic.in',
                                                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        /// TODO CHANGE EMAIL IN A FUTURE
                                       // UrlLauncher.launch('mailto:${'puri@gmail.com'}');
                                        UrlLauncher.launch('mailto:${'dmc-diu-dd@nic.in'}');
                                      },
                                      child: Padding(
                                          padding: const EdgeInsets.only(right: 10),
                                          child: Container(
                                            height: 20,
                                            width: 20,
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                            ),
                                            child: const Icon(Icons.email,
                                                color: Color(0xFF255898),
                                                size:
                                                22), //Image.asset('assets/images/callicon.png',
                                          )),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Padding(
                            // padding: EdgeInsets.only(left: 5,right: 5),
                            padding: const EdgeInsets.symmetric(
                                vertical: 2.0, horizontal: 2.0),
                            child: Container(
                              decoration: BoxDecoration(
                                //color: Colors.red,
                                border: Border.all(
                                  color: Color(0xFF255898),
                                  // Set the golden border color
                                  width: 1.0, // Set the width of the border
                                ),
                              ),
                              child: InkWell(
                                onTap: () {

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => WebSitePage()),
                                  );
                                },
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Container(
                                        height: 60,
                                        child: Padding(
                                          padding: EdgeInsets.only(top: 10),
                                          child: Padding(
                                            padding: EdgeInsets.only(left: 10),
                                            child: Column(
                                              mainAxisAlignment:
                                              MainAxisAlignment.start,
                                              crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                              children: [
                                                Text('Website',
                                                    style: AppTextStyle.font14OpenSansRegularBlackTextStyle),
                                                SizedBox(height: 5),
                                                Text('https://www.diusmartcity.com/',
                                                    style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                                                SizedBox(height: 5),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: (){
                                        /// TODO OPEN WEBURL
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => WebSitePage()),
                                        );
                                        },
                                      child: Padding(
                                          padding:
                                          const EdgeInsets.only(right: 0),
                                          child: Padding(
                                              padding: const EdgeInsets.only(right: 10),
                                              child: Container(
                                                height: 20,
                                                width: 20,
                                                decoration: BoxDecoration(
                                                  borderRadius: BorderRadius.circular(5),
                                                ),
                                                child: const Icon(Icons.webhook,
                                                    color: Color(0xFF255898),
                                                    size:
                                                    22), //Image.asset('assets/images/callicon.png',
                                              )
                                          ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 5),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            child: Center(
                              child: Text(
                                'Click on the Icon given below to connect with Diu Municipal Council',
                                  style: AppTextStyle.font14OpenSansRegularBlack45TextStyle,
                                textAlign: TextAlign.center, // Centers the text horizontally
                              ),
                            ),
                          ),
                          SizedBox(height: 10),
                           Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  InkWell(
                                    onTap: (){
                                      print('--facebook---');
                                      // FacebookPage();
                                      //displayToast("Coming Soon");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => FacebookPage(name: "Facebook",)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/images/facebook.png', height: 40, width: 40),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      print('--twitter---');
                                      //  TwitterPage();
                                     // displayToast("Coming Soon");
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TwitterPage(name: "Twitter",)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/images/twitternew.jpeg', height: 40, width: 40),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      print('--instagram---');
                                      //InstagramPage();
                                     // displayToast("Coming Soon");

                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => InstagramPage(name: "Instagram",)),
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/images/instagram.png', height: 40, width: 40),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: (){
                                      _showCustomBottomSheet(context);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.asset('assets/images/feedback.png',
                                          height: 40, width: 40,
                                          fit: BoxFit.fill,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                        ],
                    ),
                  ),
                ),
          ]
      ),
      ),
    );
  }
  // bottomSheet
  void _showCustomBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Ensures the bottom sheet adjusts for the keyboard
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)), // Rounded top corners
      ),
      builder: (BuildContext context) {
        return SingleChildScrollView( // Allows the content to scroll if it overflows
          child: Padding(
            padding: EdgeInsets.only(
              top: 20,
              left: 16,
              right: 16,
              bottom: MediaQuery.of(context).viewInsets.bottom + 16, // Adjust for keyboard
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Shrinks the column to fit its children
              children: [
                // Center image
                Center(
                  child: Image.asset(
                     "assets/images/Diu_icon-02.png",
                   // ImageAssets.iclauncher, // Replace with your image asset path
                    width: AppSize.s145,
                    height: AppSize.s145,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 16),

                // Row with circular widget and "Feedback" text
                Row(
                  children: [
                    // Circular widget
                    Container(
                      height: 20,
                      width: 20,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.blue.withOpacity(0.2),
                      ),
                      child: Icon(Icons.feedback, color: Colors.blue),
                    ),
                    SizedBox(width: 10),
                    // Text "Feedback"
                    Text(
                      "Feedback",
                      style: AppTextStyle.font14OpenSansRegularBlackTextStyle,
                    ),
                  ],
                ),
                SizedBox(height: 16),

                // EditText with multiline support
                TextFormField(
                  controller: _feedbackController, // Controller to manage the text field's value
                  textInputAction: TextInputAction.done, // Adjust action for the keyboard
                  maxLines: 4, // Allows the text field to expand to multiple lines
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(), // Add a border around the text field
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 10.0, // Adjust padding inside the text field
                      horizontal: 10.0,
                    ),
                    filled: true, // Enable background color for the text field
                    fillColor: Colors.white,
                    hintText: "Enter your feedback here...", // Placeholder text
                    hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                ),
                SizedBox(height: 16),

                // Submit button
                InkWell(
                  onTap: () {
                    validateAndCallApi(); // Your validation logic
                  },
                  child: Container(
                    width: double.infinity, // Make the button fill the width
                    height: AppSize.s45,
                    decoration: BoxDecoration(
                      color: Color(0xFF255898), // Button color
                      borderRadius: BorderRadius.circular(AppMargin.m10), // Rounded corners
                    ),
                    child: Center(
                      child: Text(
                        "Submit",
                        style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}