import 'package:drec/constants.dart';
import 'package:drec/providers/listDoctor.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/screens/home/client/appointment/listDoctor.dart';
import 'package:drec/utils/preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';

class AppointmentClient extends StatefulWidget {
  AppointmentClient();
  static const routeName = '/appointmentClient';
  @override
  _AppointmentClientState createState() => _AppointmentClientState();
}

class _AppointmentClientState extends State<AppointmentClient> {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  bool _isLoading = true;
  AndroidNotificationChannel channel = const AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    'This channel is used for important notifications.',
    importance: Importance.high,
  );

  @override
  void initState() {
    Provider.of<ListDoctorProvider>(context, listen: false)
        .getList(UserPreference.token)
        .then((_) => setState(() => _isLoading = false));

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
            navIndex: 2,
          ),
        ),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final doctor = Provider.of<ListDoctorProvider>(context).list;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: ChangeNotifierProvider(
        create: (_) => ListDoctorProvider(),
        child: Container(
          width: deviceWidth,
          height: deviceHeight,
          color: colorPrimary,
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: devicePaddingTop + 15, left: 16, right: 16),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: "Search Doctor Name...",
                    //* belum ada function search nya
                    hintStyle: TextStyle(color: colorGreyText),
                    prefixIcon: Icon(
                      Icons.search,
                      color: Colors.grey.shade600,
                      size: 20,
                    ),
                    filled: true,
                    fillColor: colorLightPrimary,
                    contentPadding: EdgeInsets.all(8),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: colorLightGrey,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: colorLightGrey,
                      ),
                    ),
                  ),
                  onChanged: (val) {
                    setState(() => _isLoading = true);
                    Provider.of<ListDoctorProvider>(context, listen: false)
                        .getList(UserPreference.token, name: val)
                        .then((_) => setState(() => _isLoading = false));
                  },
                ),
              ),
              _isLoading
                  ? Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          SizedBox(height: 5),
                          Text('Loading...'),
                        ],
                      ),
                    )
                  : Expanded(child: ListDoctor(doctor)),
            ],
          ),
        ),
      ),
    );
  }
}
