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

   FirebaseMessaging messaging = FirebaseMessaging.instance;
   await messaging.requestPermission(
     alert: true,
     badge: true,
     sound: true,
   );

   initializeNotifications();
   /// 🔥 Android 13+ notification permission (ADD HERE)
   await flutterLocalNotificationsPlugin
       .resolvePlatformSpecificImplementation<
       AndroidFlutterLocalNotificationsPlugin>()
       ?.requestNotificationsPermission();
   createNotificationChannel();

   FirebaseMessaging.onBackgroundMessage(firebaseBackgroundHandler);

   // ✅ For background & foreground click (already running app)
   /// ✅ ADD THIS (Foreground Fix)
   FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
     print("🔔 Foreground Notification Received: ${message.notification?.title}");
     await showNotification(message);
   });

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
void initializeNotifications() async {
  const AndroidInitializationSettings androidSettings =
  AndroidInitializationSettings('@mipmap/ic_launcher');

  const DarwinInitializationSettings iosSettings =
  DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
  );

  const InitializationSettings initSettings =
  InitializationSettings(android: androidSettings, iOS: iosSettings);

  await flutterLocalNotificationsPlugin.initialize(
    initSettings,
    onDidReceiveNotificationResponse: (NotificationResponse response) {
      if (response.payload != null) {
        storeNotificationPayload(response.payload!);
        navigateToNotificationScreen(response.payload!);
      }
    },
  );

  /// 🔥 VERY IMPORTANT FOR FOREGROUND iOS
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
}


// void initializeNotifications() async {
//   const AndroidInitializationSettings androidSettings =
//   AndroidInitializationSettings('@mipmap/ic_launcher');
//
//   const DarwinInitializationSettings iosSettings =
//   DarwinInitializationSettings(
//     requestAlertPermission: true,
//     requestBadgePermission: true,
//     requestSoundPermission: true,
//   );
//
//   const InitializationSettings initSettings =
//   InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//   await flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       if (response.payload != null) {
//         storeNotificationPayload(response.payload!);
//         navigateToNotificationScreen(response.payload!);
//       }
//     },
//     onDidReceiveBackgroundNotificationResponse:
//         (NotificationResponse response) {
//       if (response.payload != null) {
//         storeNotificationPayload(response.payload!);
//       }
//     },
//   );
// }

// void initializeNotifications() {
//   var androidSettings = const AndroidInitializationSettings('@mipmap/ic_launcher');
//   var iosSettings = const DarwinInitializationSettings();
//   var initSettings = InitializationSettings(android: androidSettings, iOS: iosSettings);
//
//   flutterLocalNotificationsPlugin.initialize(
//     initSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       if (response.payload != null) {
//         storeNotificationPayload(response.payload!);
//         navigateToNotificationScreen(response.payload!);
//       }
//     },
//     onDidReceiveBackgroundNotificationResponse: (NotificationResponse response) {
//       if (response.payload != null) {
//         storeNotificationPayload(response.payload!);
//       }
//     },
//   );
// }
/// ✅ Create Custom Notification Channel for Android
void createNotificationChannel() async {
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'custom_channel',
    'Custom Notifications',
    description: 'Channel for notifications',
    importance: Importance.max,
    playSound: true,
  );

  final androidImplementation =
  flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();

  await androidImplementation?.createNotificationChannel(channel);
}

// void createNotificationChannel() async {
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'custom_channel',
//     'Custom Notifications',
//     description: 'Channel for custom sound notifications',
//     importance: Importance.high,
//     playSound: true,
//     sound: RawResourceAndroidNotificationSound('coustom_sound'),
//   );
//
//   final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
//   flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
//   await androidImplementation?.createNotificationChannel(channel);
// }
/// ✅ Show Local Notification
// Future<void> showNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidDetails =
//   AndroidNotificationDetails(
//     'custom_channel', // MUST match channel id
//     'Custom Notifications', // MUST match channel name
//     channelDescription: 'Channel for custom sound notifications',
//     importance: Importance.max, // 🔥 changed to max
//     priority: Priority.high,
//     playSound: true,
//     enableVibration: true,
//     ticker: 'ticker',
//   );
//
//   const DarwinNotificationDetails iosDetails =
//   DarwinNotificationDetails(
//     presentAlert: true,
//     presentBadge: true,
//     presentSound: true,
//   );
//
//   const NotificationDetails notificationDetails =
//   NotificationDetails(android: androidDetails, iOS: iosDetails);
//
//   await flutterLocalNotificationsPlugin.show(
//     DateTime.now().millisecondsSinceEpoch ~/ 1000, // 🔥 unique ID
//     message.notification?.title ?? message.data['title'] ?? "New Alert",
//     message.notification?.body ?? message.data['body'] ?? "New Message",
//     notificationDetails,
//     payload: message.data.isNotEmpty ? jsonEncode(message.data) : null,
//   );
// }

Future<void> showNotification(RemoteMessage message) async {

  const AndroidNotificationDetails androidDetails =
  AndroidNotificationDetails(
    'custom_channel',
    'Custom Notifications',
    channelDescription: 'Channel for notifications',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
    enableVibration: true,
    icon: '@mipmap/ic_launcher',
  );

  const DarwinNotificationDetails iosDetails =
  DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
    sound: 'default',
  );

  const NotificationDetails notificationDetails =
  NotificationDetails(android: androidDetails, iOS: iosDetails);

  await flutterLocalNotificationsPlugin.show(
    DateTime.now().millisecondsSinceEpoch ~/ 1000,
    message.notification?.title ??
        message.data['title'] ??
        "New Notification",
    message.notification?.body ??
        message.data['body'] ??
        "You have a new message",
    notificationDetails,
    payload:
    message.data.isNotEmpty ? jsonEncode(message.data) : null,
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


