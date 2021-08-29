import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drec/constants.dart';
import 'package:drec/providers/auth.dart';
import 'package:drec/screens/auth/forgot-password/forgotPassword.dart';
import 'package:drec/screens/home/bottomNav.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/button.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Login extends StatefulWidget {
  Login();
  static const routeName = '/register';
  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  bool _isVisible = false;
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  GlobalKey<FormState> form = new GlobalKey<FormState>();

  bool validateLogin() {
    final validForm = form.currentState;
    if (validForm.validate()) {
      validForm.save();
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget alert = TextButton(
      child: Text("OK"),
      onPressed: () => Navigator.of(context).pop(),
    );

    AlertDialog _alertLogin = AlertDialog(
      content: Text("Either your email or password is invalid, please check again."),
      actions: [alert],
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
        padding: const EdgeInsets.only(bottom: 5),
        color: colorWhite,
        width: double.infinity,
        height: deviceHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Padding(
                padding: EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Image.asset(
                      '$imgPath/DRec.png',
                      height: 200,
                      width: 200,
                    ),
                    Form(
                      key: form,
                      child: Column(
                        children: [
                          new TextFormField(
                            controller: _email,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                              labelText: "Email",
                              hintText: 'Example@123.com',
                            ),
                            validator: (val) {
                              final pattern = new RegExp(r'([\d\w]{1,}@[\w\d]{1,}\.[\w]{1,})');
                              return pattern.hasMatch(val) ? null : 'email is invalid';
                            },
                          ),
                          SizedBox(height: 10),
                          new TextFormField(
                            controller: _password,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: "Password",
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  _isVisible ? Icons.visibility_off : Icons.visibility,
                                  color: colorPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                              ),
                            ),
                            obscureText: !_isVisible,
                            validator: (val) {
                              return val.isNotEmpty ? null : 'password required';
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              RichText(
                text: TextSpan(
                  text: 'Lupa Password ?',
                  style: TextStyle(
                    color: colorGreyText,
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  recognizer: TapGestureRecognizer()
                    ..onTap = () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (ctx) => ForgotPassword()),
                      );
                    },
                ),
              ),
              SizedBox(height: 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                    label: 'LOGIN',
                    select: () async {
                      if (validateLogin()) {
                        try {
                          final roleId = await Provider.of<AuthProvider>(context, listen: false).login(
                            email: _email.text,
                            password: _password.text,
                          );
                          firebaseMessaging.getToken().then((token) {
                            FirebaseFirestore.instance.collection('users').doc(UserPreference.id.toString()).set({
                              "id": UserPreference.id,
                              "name": UserPreference.name,
                              "avatar": UserPreference.avatar,
                              "fcm": token,
                            });
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (context) => BottomNav(userRole: roleId)),
                            );
                          }).catchError((err) {
                            print(err);
                          });
                          print("login sukses");
                        } on HttpException catch (err) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(err.message),
                            backgroundColor: colorPrimary,
                            elevation: 6,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                          ));
                        } catch (err) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Internal Server Error. Silahkan coba kembali",
                            ),
                            backgroundColor: Colors.red,
                            elevation: 6,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                          ));
                        }
                      } else {
                        print("login gagal");
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return _alertLogin;
                          },
                        );
                      }
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
