import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../app/generalFunction.dart';
import '../../services/feedbackRepo.dart';
import '../circle/circle.dart';
import '../resources/app_text_style.dart';
import '../resources/assets_manager.dart';
import '../resources/values_manager.dart';

class FeedbackBottomSheet extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FeedbackForm(),
    );
  }
}

class FeedbackForm extends StatefulWidget {
  const FeedbackForm({super.key});

  @override
  State<FeedbackForm> createState() => _FeedbackFormState();
}

class _FeedbackFormState extends State<FeedbackForm> {

  TextEditingController _feedbackController = TextEditingController();
  var feedbackResponse;

  final _formKey = GlobalKey<FormState>();
  FocusNode feedbackfocus = FocusNode();
  var result,msg;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    _feedbackController.dispose();
    feedbackfocus.dispose();
    super.dispose();
  }
  // rest api call
  void validateAndCallApi() async {
    // Trim values to remove leading/trailing spaces

    SharedPreferences prefs = await SharedPreferences.getInstance();
    // Contact No
    String? sContactNo = prefs.getString('sContactNo');

    var feedback = _feedbackController.text.trim();
    final isFormValid = _formKey.currentState!.validate();

 // Validate all conditions

    if (isFormValid && feedback.isNotEmpty) {
      // All conditions met; call the API
      print('---Call API---');

      feedbackResponse = await FeedbackRepo().feedfack(context, feedback,sContactNo);
      print('----845---->>.--->>>>---$feedbackResponse');
      result = feedbackResponse['Result'];
      msg = feedbackResponse['Msg'];
      Navigator.of(context, rootNavigator: true).pop();
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

  void clearText() {
    _feedbackController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                SizedBox(height: 10),
                Center(
                  child: Image.asset(
                    //"assets/images/home.png",
                    ImageAssets.iclauncher, // Replace with your image asset path
                    width: AppSize.s145,
                    height: AppSize.s145,
                    fit: BoxFit.contain, // Adjust as needed
                  ),
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    SizedBox(width: 5),
                    CircleWithSpacing(),
                    Text('Feedback',
                        style: AppTextStyle.font14OpenSansRegularBlack45TextStyle),
                  ],
                ),
                SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.only(
                    left: 15, // Adjusted padding value
                    right: 15, // Adjusted padding value
                  ),
                  child: Container(
                   // height: 80, // Adjusted container height
                    child: Expanded(
                      child: TextFormField(
                        focusNode: feedbackfocus, // Focus node for the text field
                        controller: _feedbackController, // Controller to manage the text field's value
                        textInputAction: TextInputAction.next, // Set action for the keyboard
                        onEditingComplete: () => FocusScope.of(context).nextFocus(), // Move to next input on completion
                        maxLines: null, // Allows the text field to expand to multiple lines
                        minLines: 4, // Minimum height of the text field (approximately 100 in height)
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(), // Add a border around the text field
                          contentPadding: EdgeInsets.symmetric(
                            vertical: 10.0, // Adjust padding inside the text field
                            horizontal: 10.0,
                          ),
                          filled: true, // Enable background color for the text field
                          fillColor: Colors.white,
                          hintText: "Enter your feedback here...", // Placeholder text when field is empty
                          hintStyle: TextStyle(color: Colors.grey), // Style for the placeholder text
                        ),
                        autovalidateMode: AutovalidateMode.onUserInteraction, // Enable validation on user interaction
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 10),

                /// LoginButton code and onclik Operation
                InkWell(
                  onTap: () {
                     validateAndCallApi();
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15,right: 15),
                    child: Container(
                      // Make container fill the width of its parent
                      height: AppSize.s45,
                      padding: EdgeInsets.all(AppPadding.p5),
                      decoration: BoxDecoration(
                        color: Color(0xFF255898),
                        // Background color using HEX value
                        borderRadius: BorderRadius.circular(
                            AppMargin.m10), // Rounded corners
                      ),
                      //  #00b3c7
                      child: Center(
                        child: Text(
                          "Submit",
                          style: AppTextStyle.font16OpenSansRegularWhiteTextStyle,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
