import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:watermel/app/Views/Home%20Feed/controllers/feed_home_controller.dart';
import 'package:watermel/app/Views/Notification_Follow/notificationList.dart';
import 'package:watermel/app/Views/auth/login_controller.dart';
import 'package:watermel/app/core/helpers/api_manager.dart';
import 'package:watermel/app/core/theme/theme.dart';
import 'package:watermel/app/Views/splash/splash_page.dart';
import 'package:watermel/app/utils/preference.dart';
import 'app/utils/theme/colors.dart';
import 'app/utils/theme/print.dart';
import 'app/widgets/common_methods.dart';

final storage = GetStorage();
List<CameraDescription>? cameras;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  /* get storage initization */
  await GetStorage.init();

  cameras = await availableCameras();
  final SharedPreferences prefs = await SharedPreferences.getInstance();

  await storage.read(MyStorage.refreshToken) == null ||
          await storage.read(MyStorage.refreshToken) == ""
      ? null
      : await ApiManager().setRefreshTokenAPI(fromMain: true);

  prefs.setStringList("viewedPosts", []);

  if (prefs.getBool('first_run') ?? true) {
    prefs.setBool('first_run', false);
    CommonMethod().clearData();
  }
  CommonMethod().loadermethod();
  runApp(MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatelessWidget {
  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    firebaseSetting();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      theme: themeData,
      builder: (context, myWidget) {
        myWidget = EasyLoading.init()(context, myWidget);
        final double shortesSide = MediaQuery.of(context).size.shortestSide;
        final bool useMobileLayout = shortesSide <= 600.0;
        myWidget = MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaleFactor:
                  useMobileLayout.toString() == "true" ? 1.0 : 2.0),
          child: myWidget,
        );
        return myWidget;
      },
      home: Scaffold(
          backgroundColor: MyColors.whiteColor, body: const SplashPage()),
    );
  }
}

//---------------------------------------Firebase setup -------------------------------------//
notificationRediraction({var message}) async {
  var token = await MyStorage.read(MyStorage.token);
  var userId = await MyStorage.read(MyStorage.userId);

  if (token != null && userId != null && token != "" && userId != "") {
    final ct = Get.put(LoginController());
    ct.isNotification = true;
    ct.update();
    if (message.data["request_type"] == "request") {
      Get.offAll(() => NotificationListScreen(
            fromMain: true,
          ));
    } else if (message.data["request_type"] == "simple") {
      await ct.getUserPotDetailsAPI(message.data["notif_seed_id"], true,
          message.data["notif_type"] == "comment" ? true : false);
    }
  }
}

Future<void> firebaseMessagingBackgroundHandler(message) async {
  if (message != null) {
    notificationRediraction(message: message);
  }
}

/// Create a [AndroidNotificationChannel] for heads up notifications
AndroidNotificationChannel? channel;

/// Initialize the [FlutterLocalNotificationsPlugin] package.
FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;
firebaseSetting() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  requestPermissions();
  initNotificationmethod();
  var initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var initializationSettingsIOS = const DarwinInitializationSettings();
  var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid, iOS: initializationSettingsIOS);
  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  flutterLocalNotificationsPlugin!.initialize(initializationSettings);
}

//when allow Permission
requestPermissions() async {
  NotificationSettings settings =
      await FirebaseMessaging.instance.requestPermission(
    alert: true,
    announcement: false,
    badge: true,
    carPlay: false,
    criticalAlert: false,
    provisional: false,
    sound: true,
  );

  MyPrint(value: settings.authorizationStatus.toString(), tag: 'check');

  if (Platform.isIOS) {
    await FirebaseMessaging.instance
        .setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
  }
}

//Push Notification setup
Future<void> initNotificationmethod() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  String? deviceToken = await FirebaseMessaging.instance.getToken();
  MyPrint(tag: "deviceToken..............", value: "${deviceToken.toString()}");

  //when app in background
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

  if (!kIsWeb) {
    channel = const AndroidNotificationChannel(
        'high_importance_channel', // id
        'High Importance Notifications', // title
        importance: Importance.high,
        playSound: true);
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

    await flutterLocalNotificationsPlugin!
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(channel!);
  }

  //when app is [closed | killed | terminated]
  FirebaseMessaging.instance.getInitialMessage().then((RemoteMessage? message) {
    MyPrint(tag: "!41...............", value: "demo");
    if (message != null) {
      RemoteNotification? notification = message.notification;
      if (message.notification != null) {
        // homeCtrl.SeenNotificationCountAPI();

        notificationRediraction(message: message);
      }
    }
  });

  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    final homefeedController = Get.put(HomeFeedController());
    homefeedController.getNotificationCountAPI(4);
    RemoteNotification? notification = message.notification;
    // homeCtrl.SeenNotificationCountAPI();
    if (!kIsWeb && notification != null) {
      String? channelId;
      channelId = message.notification!.android?.channelId;
      String? currentRoute = Get.currentRoute;
      if (currentRoute != null && currentRoute.contains('messenger')) {
      } else {
        if (Platform.isAndroid) {
          flutterLocalNotificationsPlugin!.show(
            notification.hashCode,
            notification.title,
            notification.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channelId ?? channel!.id,
                channel!.name,
                //  channel!.description,
                //  icon: "ic_notification",
              ),
              iOS: const DarwinNotificationDetails(),
            ),
            payload: jsonEncode(message.data),
          );
        }
      }
    }
  });

  //when app in background
  FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
    if (message.messageId != null) {
      notificationRediraction(message: message);
    }
  });
}
