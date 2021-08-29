import 'package:drec/constants.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/screens/home/doctor/appointment/listAppointment.dart';
import 'package:drec/utils/preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class AppointmentDoctor extends StatefulWidget {
  AppointmentDoctor();
  static const routeName = '/appointmentDoctor';
  @override
  _AppointmentDoctorState createState() => _AppointmentDoctorState();
}

class _AppointmentDoctorState extends State<AppointmentDoctor> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
  );

  @override
  void initState() {
    FirebaseMessaging.instance.getInitialMessage().then((_) {});
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      RemoteNotification notification = message.notification;
      AndroidNotification android = message.notification?.android;
      if (notification != null && android != null) {
        flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
              channel.description,
              icon: '@mipmap/ic_launcher',
            ),
          ),
        );
      }
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BottomNav(
            userRole: UserPreference.roleId,
            navIndex: 1,
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorBackground,
        title: Text("List of Appointments"),
        automaticallyImplyLeading: false,
      ),
      resizeToAvoidBottomInset: false,
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        color: colorPrimary,
        padding: EdgeInsets.only(top: 15),
        child: ListAppointment(),
      ),
    );
  }
}
