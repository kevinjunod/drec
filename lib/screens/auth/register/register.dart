import 'package:drec/constants.dart';
import 'package:drec/providers/auth.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/widgets/button.dart';
import 'package:drec/widgets/imagePicker.dart';
import 'package:drec/widgets/radioButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Register extends StatefulWidget {
  Register();
  static const routeName = '/register';
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  GlobalKey<FormState> form = new GlobalKey<FormState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmationPassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  bool _isMale = false;
  bool _isFemale = false;
  bool _isVisible = false;
  bool _isConfirmationVisible = false;
  bool _isLoading = false;
  String _gender = "";
  String _avatar = "";

  bool validateRegister() {
    final validForm = form.currentState;
    if (validForm.validate()) {
      validForm.save();
      return true;
    } else {
      return false;
    }
  }

  void _selectGenderMale() {
    setState(() {
      _isMale = true;
      _isFemale = false;
      _gender = "L";
    });
  }

  void _selectGenderFemale() {
    setState(() {
      _isMale = false;
      _isFemale = true;
      _gender = "P";
    });
  }

  Future<Null> _selectDate() async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        _dob.text = DateFormat("yyyy-MM-dd").format(picked);
      });
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
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              final pattern = new RegExp(
                                  r'([\d\w]{1,}@[\w\d]{1,}\.[\w]{1,})');
                              return pattern.hasMatch(val)
                                  ? null
                                  : 'email is invalid';
                            },
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _password,
                            keyboardType: TextInputType.text,
                            obscureText: !_isVisible,
                            decoration: InputDecoration(
                              labelText: "Password",
                              hintText: 'Your password',
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  _isVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: colorPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isVisible = !_isVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val.length >= 8
                                  ? null
                                  : 'password must have at least 8 characters';
                            },
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _confirmationPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !_isConfirmationVisible,
                            decoration: InputDecoration(
                              labelText: "Confirmation Password",
                              hintText: 'Your confimation password',
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  _isConfirmationVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility,
                                  color: colorPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmationVisible =
                                        !_isConfirmationVisible;
                                  });
                                },
                              ),
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              print(val.length);
                              if (val.length < 8) {
                                return 'confirmation password required';
                              }
                              if (val != _password.text) {
                                return 'confirmation password must same with password';
                              }
                              return null;
                            },
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _name,
                            keyboardType: TextInputType.text,
                            textCapitalization: TextCapitalization.words,
                            decoration: InputDecoration(
                              labelText: "Name",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val.isNotEmpty ? null : 'name required';
                            },
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _address,
                            keyboardType: TextInputType.text,
                            maxLines: 3,
                            decoration: InputDecoration(
                              labelText: "Your Address",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val.isNotEmpty ? null : 'address required';
                            },
                          ),
                          SizedBox(height: 30),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              GestureDetector(
                                onTap: _selectGenderMale,
                                child: RadioButton(
                                  label: "Male",
                                  selectedType: _isMale,
                                  select: _selectGenderMale,
                                ),
                              ),
                              GestureDetector(
                                onTap: _selectGenderFemale,
                                child: RadioButton(
                                  label: "Female",
                                  selectedType: _isFemale,
                                  select: _selectGenderFemale,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 20),
                          TextFormField(
                            onTap: _selectDate,
                            controller: _dob,
                            showCursor: false,
                            readOnly: true,
                            decoration: InputDecoration(
                              labelText: "Date of Birth",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val.isNotEmpty
                                  ? null
                                  : 'date of birth required';
                            },
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _phoneNumber,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              labelText: "Phone Number",
                              border: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.blue,
                                  width: 1.0,
                                ),
                              ),
                            ),
                            validator: (val) {
                              return val.isNotEmpty
                                  ? null
                                  : 'phone number required';
                            },
                          ),
                          SizedBox(height: 25),
                          Container(
                            width: double.infinity,
                            child: Text(
                              'Avatar',
                              style: TextStyle(fontWeight: FontWeight.bold),
                              textAlign: TextAlign.left,
                            ),
                          ),
                          CustomImagePicker(
                            onChange: (value) =>
                                setState(() => _avatar = value),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Button(
                label: _isLoading ? 'Please Wait...' : 'REGISTER',
                select: _isLoading
                    ? () {}
                    : () async {
                        if (validateRegister()) {
                          try {
                            await Provider.of<AuthProvider>(context,
                                    listen: false)
                                .register(
                              roleId: 1,
                              email: _email.text,
                              password: _password.text,
                              confirmationPassword: _confirmationPassword.text,
                              name: _name.text,
                              address: _address.text,
                              gender: _gender,
                              dob: _dob.text,
                              phoneNumber: _phoneNumber.text,
                              avatar: _avatar,
                            );
                            Navigator.of(context).pop();
                          } on HttpException catch (err) {
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(err.message),
                              backgroundColor: colorPrimary,
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                            ));
                          } catch (err) {
                            print(err);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(
                                "Internal Server Error. Silahkan coba kembali",
                              ),
                              backgroundColor: Colors.red,
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(13))),
                            ));
                          }
                        }
                      },
              )
            ],
          ),
        ),
      ),
    );
  }
}
