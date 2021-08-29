import 'package:drec/constants.dart';
import 'package:drec/providers/auth.dart';
import 'package:drec/providers/listAppointment.dart';
import 'package:drec/providers/listDoctor.dart';
import 'package:drec/providers/listUser.dart';
import 'package:drec/providers/review.dart';
import 'package:drec/providers/schedule.dart';
import 'package:drec/screens/auth/login/login.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/screens/home/consultation/consultation.dart';
import 'package:drec/screens/welcome/splashScreen.dart';
import 'package:drec/utils/preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/data/latest.dart' as tz;

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  await UserPreference.init();
  tz.initializeTimeZones();
  bool isLoggedIn = UserPreference.isLogin;
  int roleId = UserPreference.roleId;
  AndroidNotificationChannel channel;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  final startApp = Splash(isLoggedIn, roleId: roleId);
  runApp(MyApp(startApp));
}

class MyApp extends StatelessWidget {
  final Widget startApp;
  MyApp(this.startApp);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => ListUserProvider()),
        ChangeNotifierProvider(create: (_) => ListDoctorProvider()),
        ChangeNotifierProvider(create: (_) => ScheduleProvider()),
        ChangeNotifierProvider(create: (_) => ListAppointmentProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'D-Rec Appointment Application',
        theme: ThemeData(
          fontFamily: 'Montserrat',
          primaryColor: colorPrimary,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: startApp,
        routes: {
          '/login': (context) => Login(),
          '/home': (context) => BottomNav(),
          '/consultation': (context) => Consultation(),
        },
      ),
    );
  }
}
