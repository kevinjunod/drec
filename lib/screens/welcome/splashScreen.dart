import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drec/constants.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/screens/welcome/welcome.dart';
import 'package:drec/utils/preference.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:splashscreen/splashscreen.dart';

class Splash extends StatefulWidget {
  final bool isLoggedIn;
  final int roleId;
  Splash(this.isLoggedIn, {this.roleId});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<Splash> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  Future<Widget> loadFromFuture() async {
    return Future.value(
      new WelcomePage(),
    );
  }

  @override
  void initState() {
    if (widget.isLoggedIn) {
      firebaseMessaging.getToken().then((token) {
        FirebaseFirestore.instance.collection('users').doc(UserPreference.id.toString()).set({
          "id": UserPreference.id,
          "name": UserPreference.name,
          "avatar": UserPreference.avatar,
          "fcm": token,
        });
      }).catchError((err) {
        print(err);
      });
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    devicePaddingTop = MediaQuery.of(context).padding.top;
    devicePaddingBottom = MediaQuery.of(context).padding.bottom;
    return new SplashScreen(
      seconds: 2,
      navigateAfterSeconds: widget.isLoggedIn
          ? BottomNav(
              userRole: widget.roleId,
            )
          : new WelcomePage(),
      image: new Image.asset(
        '$imgPath/DRec.png',
      ),
      backgroundColor: colorBackground,
      styleTextUnderTheLoader: new TextStyle(),
      photoSize: 100.0,
      useLoader: false,
    );
  }
}
