import 'package:drec/constants.dart';
import 'package:drec/providers/auth.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  TextEditingController _email = new TextEditingController();
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
                        ],
                      ),
                    ),
                    SizedBox(height: 10),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Button(
                    label: 'RESET',
                    select: () async {
                      if (validateLogin()) {
                        try {
                          await Provider.of<AuthProvider>(context, listen: false).resetPassword(_email.text);
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text('Success resetting password. Check your email.'),
                            backgroundColor: Colors.green,
                            elevation: 6,
                            behavior: SnackBarBehavior.floating,
                            margin: EdgeInsets.all(20),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                          ));
                          Navigator.pop(context);
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
