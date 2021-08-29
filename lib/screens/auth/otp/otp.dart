import 'package:flutter/material.dart';
import 'package:drec/constants.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/widgets/button.dart';
import 'package:intl/intl.dart';

class OTP extends StatefulWidget {
  final String email;
  OTP({this.email});
  static const routeName = '/register';
  @override
  _OTPState createState() => _OTPState();
}

class _OTPState extends State<OTP> {
  String _otp1 = "";
  String _otp2 = "";
  String _otp3 = "";
  String _otp4 = "";
  String _otp5 = "";
  String _otp6 = "";
  int _minutes;
  int _seconds;
  int _countdown;
  // String _otp = "$_otp1 + $_otp2 + $_otp3 + $_otp4 + $_otp5 + $_otp6";

  int minutesOTP() {
    _minutes = _countdown % 60;
    _seconds;
  }

  final digitFormat = new NumberFormat("00");

  @override
  Widget build(BuildContext context) {
    final nextNode = FocusScope.of(context);

    Widget alert = TextButton(
      child: Text("Ok"),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog _alertOTP = AlertDialog(
      content: Text("Your new OTP has been expired."),
      actions: [
        alert,
      ],
    );

    final otpDecoration = InputDecoration(
      contentPadding: EdgeInsets.symmetric(vertical: deviceWidth / 35),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorDarkPrimary),
      ),
      counter: Offstage(),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide(color: colorGreyText),
      ),
    );

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorWhite,
        elevation: 0,
        iconTheme: IconThemeData(
          color: colorBlack,
        ),
      ),
      body: Container(
        color: colorWhite,
        child: SizedBox(
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 100.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Enter your 6-Digit OTP Verification code",
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: colorGreyText),
                ),
                SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("We sent your code to "),
                    Text(
                      "${widget.email}",
                      style: TextStyle(
                        color: colorPrimary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text("Resend OTP in "),
                    TweenAnimationBuilder(
                      tween: Tween(begin: 60.0, end: 0),
                      duration: Duration(seconds: 60),
                      builder: (context, value, child) => Text(
                        "00:${digitFormat.format(value.toInt())}",
                        style: TextStyle(
                          color: colorPrimary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      onEnd: () {},
                    )
                  ],
                ),
                SizedBox(
                  height: 30,
                ),
                Form(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      for (int i = 0; i < 6; i++)
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 5,
                            right: 5,
                          ),
                          child: SizedBox(
                            width: deviceWidth / 8,
                            child: TextFormField(
                              textAlign: TextAlign.center,
                              onChanged: (_) => nextNode.nextFocus(),
                              maxLength: 1,
                              keyboardType: TextInputType.number,
                              textInputAction: TextInputAction.next,
                              style: TextStyle(fontSize: 24),
                              decoration: otpDecoration,
                            ),
                          ),
                        )
                    ],
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Button(
                  label: 'SUBMIT',
                  select: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BottomNav(),
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
