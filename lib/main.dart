import 'package:big_cart/app/app.router.dart';
import 'package:big_cart/app/locator.dart';
import 'package:big_cart/constants/asset_constants.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:stacked_services/stacked_services.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel' ,
    'High importance notifications',
    importance: Importance.high,
    playSound: true
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('A bg message just shows up : ${message.messageId}');
}


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // this code used when you want to show/do something when notification comes while the app is in background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await flutterLocalNotificationsPlugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true
  );
  await FirebaseMessaging.instance.subscribeToTopic('allUsers');

  setupLocator();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    precacheImage(AssetImage(AssetConstants.splashScreenBackground), context);
    return MaterialApp(
      title: 'Big Cart',
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      // home: CheckoutView(),
      navigatorKey: StackedService.navigatorKey,
      onGenerateRoute: StackedRouter().onGenerateRoute,
    );
  }
}
