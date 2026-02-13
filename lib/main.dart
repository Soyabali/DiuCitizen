import 'dart:convert';
import 'dart:io';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:puri/presentation/complaints/complaintHomePage.dart';
import 'package:puri/presentation/login/loginScreen_2.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/myapp.dart';
import 'firebase_options.dart';

// firebase notification code
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>(); // ✅ Global Key

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

@pragma('vm:entry-point') // ✅ Required for background handlers
Future<void> firebaseBackgroundHandler(RemoteMessage message) async {
  print("🔔 Background Notification Received: ${message.notification?.title}");

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? title = message.notification?.title ?? "No Title";
  String? body = message.notification?.body ?? "No Body";

  await prefs.setString('notification_title', title);
  await prefs.setString('notification_body', body);

  print("✅ Stored Title: $title");
  print("✅ Stored Body: $body");
}


void main() async {

   //print("----Main Page---");
   WidgetsFlutterBinding.ensureInitialized();
   await Firebase.initializeApp(
     options: DefaultFirebaseOptions.currentPlatform,
   );
   initializeNotifications();
   createNotificationChannel();

   FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

   // ✅ For background & foreground click (already running app)

   // FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
   //   print("🔔 Notification Clicked: ${message.data}");
   //   String payload = jsonEncode({"title": message.notification?.title, "body": message.notification?.body});
   //   storeNotificationPayload(payload); // ✅ Save for later navigation
   //   navigateToNotificationScreen(payload); // ✅ Navigate if app is already running
   // });
   // ✅ For background & foreground click (already running app)
   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
     print("🔔 Notification Clicked: ${message.data}");
     openVisitorListDirectly(); // ✅ Always open VisitorList
   });


  HttpOverrides.global = MyHttpOverrides();
  runApp(MyApp());
  //runApp(SplashView());
  configLoading();
   WidgetsBinding.instance.addPostFrameCallback((_) async {
     await checkAndNavigateFromStoredPayload(); // ✅ Handle stored payload
   });
}
//
Future<void> openVisitorListDirectly() async {

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sToken = prefs.getString('sToken');

  int retryCount = 0;
  while (navigatorKey.currentState == null && retryCount < 10) {
    await Future.delayed(const Duration(milliseconds: 500));
    retryCount++;
  }

  await Future.delayed(const Duration(milliseconds: 300)); // ✅ Extra safety delay

  if (sToken == null || sToken.isEmpty) {
    // here you simle navigate login screen
   // safeNavigate('/LoginScreen_2');

    // Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(builder: (context) => ComplaintHomePage()),
    //       (Route<dynamic> route) => false, // This condition removes all previous routes
    // );

    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  } else {
    // here you simple navigate Dashboard
   // safeNavigate('/VisitorList');   LoginPage
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ComplaintHomePage()),
          (route) => false,
    );
  }
}

Future<void> storeNotificationPayload(String payload) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString('pending_notification_payload', payload);
}

/// ✅ Check and navigate after app starts
Future<void> checkAndNavigateFromStoredPayload() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? payload = prefs.getString('pending_notification_payload');

  if (payload != null && payload.isNotEmpty) {
    prefs.remove('pending_notification_payload'); // Clear after using
    navigateToNotificationScreen(payload);
  }

  // ✅ Also check Firebase initial message for killed app
  RemoteMessage? initialMessage = await FirebaseMessaging.instance.getInitialMessage();
  if (initialMessage != null) {
    String payload = jsonEncode(initialMessage.data.isNotEmpty ? initialMessage.data : {
      "title": initialMessage.notification?.title,
      "body": initialMessage.notification?.body
    });

    // Store and navigate after router is ready
    await storeNotificationPayload(payload);
    Future.delayed(const Duration(seconds: 1), () {
      navigateToNotificationScreen(payload);
    });
    //navigateToNotificationScreen(payload);
  }
}

// Future<void> safeNavigate(String route, {String? payload}) async {
//   await Future.delayed(const Duration(milliseconds: 300)); // small delay
//   if (navigatorKey.currentContext != null) {
//
//     GoRouter.of(navigatorKey.currentContext!).go(route, extra: payload);
//
//   } else {
//     print("Navigator still not ready, retrying...");
//     Future.delayed(const Duration(milliseconds: 500), () {
//       safeNavigate(route, payload: payload);
//     });
//   }
// }

void navigateToNotificationScreen(String payload) async {
  print("🔗 Navigating to VisitorList with Payload: $payload");

  if (navigatorKey.currentState == null) {
    print("⚠️ Navigator not ready yet, retrying...");
    Future.delayed(const Duration(milliseconds: 500), () {
      navigateToNotificationScreen(payload);
    });
    return;
  }

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? sToken = prefs.getString('sToken');

  if (sToken == null || sToken.isEmpty) {
    //safeNavigate('/LoginScreen_2');
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => LoginPage()),
          (route) => false,
    );
  } else {
    //safeNavigate('/VisitorList', payload: payload);
    /// here you take a notification data that is payload
    navigatorKey.currentState?.pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => ComplaintHomePage()),
          (route) => false,
    );
  }
}
// Initialize Notification
void initializeNotifications() {
  var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosSettings = const DarwinInitializationSettings();
  var initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);

  flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        storeNotificationPayload(response.payload!);
        navigateToNotificationScreen(response.payload!);
      }
    },
    onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        storeNotificationPayload(response.payload!);
      }
    },
  );
}
/// ✅ Create Custom Notification Channel for Android
void createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'custom_channel',
    'Custom Notifications',
    description: 'Channel for custom sound notifications',
    importance: Importance.high,
    playSound: true,
    sound: RawResourceAndroidNotificationSound('coustom_sound'),
  );

  final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
  await androidImplementation?.createNotificationChannel(channel);
}
/// ✅ Show Local Notification
Future<void> showNotification(RemoteMessage message) async {
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'custom_channel',
    'Custom Sound Channel',
    channelDescription: 'Channel for custom sound notifications',
    importance: Importance.high,
    priority: Priority.high,
    sound: RawResourceAndroidNotificationSound('coustom_sound'),
    playSound: true,
  );

  const DarwinNotificationDetails iosDetails = DarwinNotificationDetails(
    sound: 'coustom_sound.wav',
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    0,
    message.notification?.title ?? "New Alert",
    message.notification?.body ?? "This should play a custom sound",
    notificationDetails,
  );
}




class MyHttpOverrides extends HttpOverrides {

  @override
  HttpClient createHttpClient(SecurityContext? context){
    return super.createHttpClient(context)
      ..badCertificateCallback = (X509Certificate cert, String host, int port)=> true;
  }
}

void configLoading() {
  EasyLoading.instance

    ..displayDuration = const Duration(milliseconds: 2000)

    ..indicatorType = EasyLoadingIndicatorType.fadingCircle

    ..loadingStyle = EasyLoadingStyle.custom

    ..indicatorSize = 45.0

    ..radius = 10.0

    ..progressColor = Colors.white

    ..backgroundColor = Colors.black

    ..indicatorColor = Colors.white

    ..textColor = Colors.white

    ..maskColor = Colors.blue.withOpacity(0.5)

    ..userInteractions = false

    ..dismissOnTap = false;

}


