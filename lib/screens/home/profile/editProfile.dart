import 'dart:convert';

import 'package:drec/constants.dart';
import 'package:drec/providers/auth.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/utils/thousandSeparator.dart';
import 'package:drec/widgets/button.dart';
import 'package:drec/widgets/imagePicker.dart';
import 'package:drec/widgets/radioButton.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditProfile extends StatefulWidget {
  EditProfile();
  static const routeName = '/editProfile';
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  GlobalKey<FormState> form = new GlobalKey<FormState>();
  TextEditingController _email = new TextEditingController();
  TextEditingController _password = new TextEditingController();
  TextEditingController _confirmationPassword = new TextEditingController();
  TextEditingController _name = new TextEditingController();
  TextEditingController _address = new TextEditingController();
  TextEditingController _dob = new TextEditingController();
  TextEditingController _phoneNumber = new TextEditingController();
  TextEditingController _specialization = new TextEditingController();
  TextEditingController _graduate = new TextEditingController();
  TextEditingController _price = new TextEditingController();
  List<TextEditingController> _startTimes = [];
  List<TextEditingController> _endTimes = [];
  bool _isMale = false;
  bool _isFemale = false;
  bool _notActive = false;
  bool _active = false;
  bool _isLoading = false;
  bool _isVisible = false;
  bool _isConfirmationVisible = false;
  bool _activePicked;
  int _roleId;
  int indexDay = 0;
  int indexTimeInDay = 0;
  Map<String, dynamic> _availableTime;
  String _gender = "";
  String _avatar = "";

  @override
  void initState() {
    _avatar = UserPreference.avatar;
    _email.text = UserPreference.email;
    _name.text = UserPreference.name;
    _address.text = UserPreference.address;
    _dob.text = UserPreference.dob;
    _phoneNumber.text = UserPreference.phoneNumber;
    _gender = UserPreference.gender;
    _specialization.text = UserPreference.specialization;
    _graduate.text = UserPreference.graduate;
    _roleId = UserPreference.roleId;
    _activePicked = UserPreference.active ?? false;
    _availableTime = UserPreference.availableTime == null || UserPreference.availableTime == ''
        ? null
        : json.decode(UserPreference.availableTime);
    _price.text = UserPreference.price;
    if (_gender == 'L') {
      _isMale = true;
    } else {
      _isFemale = true;
    }
    if (_activePicked) {
      _active = true;
    } else {
      _notActive = true;
    }
    _isLoading = false;
    if (_gender == 'L') {
      _isMale = true;
    } else {
      _isFemale = true;
    }
    _isLoading = false;
    super.initState();
  }

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

  void _selectActive() {
    setState(() {
      _active = true;
      _notActive = false;
      _activePicked = true;
    });
  }

  void _selectNotActive() {
    setState(() {
      _active = false;
      _notActive = true;
      _activePicked = false;
    });
  }

  Future<void> _selectDate(String type) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      initialDatePickerMode: DatePickerMode.day,
      firstDate: DateTime(1950, 8),
      lastDate: DateTime.now(),
    );
    if (picked != null)
      setState(() {
        if (type == 'dob') _dob.text = DateFormat("yyyy-MM-dd").format(picked);
        if (type == 'graduate') _graduate.text = DateFormat("yyyy-MM-dd").format(picked);
      });
  }

  Future<void> _selectTime({@required int indexDays, @required String day, @required String type}) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    final time = DateFormat.jm().parse(picked.format(context));
    if (picked != null)
      setState(() {
        final formattedTime = DateFormat("HH:mm").format(time);
        if (type == 'start') {
          _startTimes[indexDays].text = formattedTime;
          _availableTime[day]['start'] = formattedTime;
        }
        if (type == 'end') {
          _endTimes[indexDays].text = formattedTime;
          _availableTime[day]['end'] = formattedTime;
        }
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
                              final pattern = new RegExp(r'([\d\w]{1,}@[\w\d]{1,}\.[\w]{1,})');
                              return pattern.hasMatch(val) ? null : 'email is invalid';
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
                                  _isVisible ? Icons.visibility_off : Icons.visibility,
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
                          ),
                          SizedBox(height: 20),
                          new TextFormField(
                            controller: _confirmationPassword,
                            keyboardType: TextInputType.text,
                            obscureText: !_isConfirmationVisible,
                            decoration: InputDecoration(
                              labelText: "Confirmation Password",
                              hintText: 'Your confirmation password',
                              suffixIcon: IconButton(
                                highlightColor: Colors.transparent,
                                focusColor: Colors.transparent,
                                splashColor: Colors.transparent,
                                padding: EdgeInsets.all(0),
                                icon: Icon(
                                  _isConfirmationVisible ? Icons.visibility_off : Icons.visibility,
                                  color: colorPrimary,
                                ),
                                onPressed: () {
                                  setState(() {
                                    _isConfirmationVisible = !_isConfirmationVisible;
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
                              return val != _password.text ? 'confirmation password must same with password' : null;
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
                            onTap: () => _selectDate('dob'),
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
                              return val.isNotEmpty ? null : 'date of birth required';
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
                              return val.isNotEmpty ? null : 'phone number required';
                            },
                          ),
                          CustomImagePicker(
                            onChange: (value) => setState(() => _avatar = value),
                            uploadedImage: _avatar,
                          ),
                          if (_roleId == 2)
                            Column(
                              children: [
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _specialization,
                                  keyboardType: TextInputType.text,
                                  textCapitalization: TextCapitalization.words,
                                  decoration: InputDecoration(
                                    labelText: "Specialization",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    return val.isNotEmpty ? null : 'specialization required';
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  onTap: () => _selectDate('graduate'),
                                  controller: _graduate,
                                  showCursor: false,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    labelText: "Graduate Date",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  validator: (val) {
                                    return val.isNotEmpty ? null : 'graduate date required';
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                SizedBox(height: 20),
                                TextFormField(
                                  controller: _price,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                    labelText: "Price",
                                    border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                        color: Colors.blue,
                                        width: 1.0,
                                      ),
                                    ),
                                  ),
                                  inputFormatters: [ThousandSeparator(decimalDigits: 0)],
                                  validator: (val) {
                                    val = val.isNotEmpty ? val.replaceAll(RegExp('[^0-9\.]'), '') : '';
                                    if (val.isEmpty) {
                                      return 'price required';
                                    } else if (double.parse(val) < 1) {
                                      return 'price must greater than 1';
                                    }
                                    return null;
                                  },
                                  autovalidateMode: AutovalidateMode.onUserInteraction,
                                ),
                                SizedBox(height: 30),
                                Text(
                                  'Available Time',
                                  style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10),
                                generateAvailableTime(),
                                SizedBox(height: 20),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                  children: [
                                    GestureDetector(
                                      onTap: _selectActive,
                                      child: RadioButton(
                                        label: "Active",
                                        selectedType: _active,
                                        select: _selectActive,
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: _selectNotActive,
                                      child: RadioButton(
                                        label: "Not Active",
                                        selectedType: _notActive,
                                        select: _selectNotActive,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              Button(
                label: _isLoading ? 'Please Wait...' : 'Submit',
                select: _isLoading
                    ? () {}
                    : () async {
                        if (validateRegister()) {
                          try {
                            await Provider.of<AuthProvider>(context, listen: false).update(
                              email: _email.text,
                              password: _password.text,
                              confirmationPassword: _confirmationPassword.text,
                              name: _name.text,
                              address: _address.text,
                              gender: _gender,
                              dob: _dob.text,
                              phoneNumber: _phoneNumber.text,
                              avatar: _avatar,
                              specialization: _specialization.text,
                              graduate: _graduate.text,
                              availableTime: _availableTime,
                              active: _active,
                              price: double.parse(_price.text.replaceAll(RegExp('[^0-9\.]'), '')),
                            );
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text('Success update your profile'),
                              backgroundColor: Colors.green,
                              elevation: 6,
                              behavior: SnackBarBehavior.floating,
                              margin: EdgeInsets.all(20),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(13))),
                            ));
                            Navigator.of(context).pop();
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
                            print(err);
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
              ),
              SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }

  Widget generateAvailableTime() {
    List<Widget> widget = [];
    indexDay = 0;
    _availableTime.forEach((key, value) {
      _startTimes.add(new TextEditingController());
      _endTimes.add(new TextEditingController());
      _startTimes[value['key']].text = value['start'];
      _endTimes[value['key']].text = value['end'];
      indexDay++;
      widget.add(
        Padding(
          padding: EdgeInsets.only(top: key != 'sunday' ? 10 : 0),
          child: Row(
            children: [
              Container(width: 100, child: Text(key, style: TextStyle(fontWeight: FontWeight.bold))),
              Expanded(
                child: TextFormField(
                  onTap: () => _selectTime(indexDays: value['key'], day: key, type: 'start'),
                  controller: _startTimes[value['key']],
                  showCursor: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "Start Time",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    errorStyle: TextStyle(height: 0),
                  ),
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text('-'),
              ),
              Expanded(
                child: TextFormField(
                  onTap: () => _selectTime(indexDays: value['key'], day: key, type: 'end'),
                  controller: _endTimes[value['key']],
                  showCursor: false,
                  readOnly: true,
                  decoration: InputDecoration(
                    labelText: "End Time",
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.blue,
                        width: 1.0,
                      ),
                    ),
                    errorStyle: TextStyle(height: 0),
                  ),
                  validator: (val) {
                    if (_startTimes[value['key']].text != '' && val != '') {
                      final start = DateFormat('HH:mm').parse(_startTimes[value['key']].text);
                      final end = DateFormat('HH:mm').parse(val);
                      return end.difference(start).inMinutes > 0 ? null : '';
                    } else if (_startTimes[value['key']].text != '' && val == '') {
                      return '';
                    }
                    return null;
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                ),
              ),
            ],
          ),
        ),
      );
    });

    return Column(
      children: widget,
    );
  }
}
