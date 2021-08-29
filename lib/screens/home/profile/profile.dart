import 'package:drec/constants.dart';
import 'package:drec/screens/home/profile/editProfile.dart';
import 'package:drec/screens/welcome/welcome.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  Profile();
  static const routeName = '/profile';
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  String _name = UserPreference.name;
  String _dob = UserPreference.dob;
  String _gender = UserPreference.gender;
  String _phoneNumber = UserPreference.phoneNumber;
  String _address = UserPreference.address;
  String _profilePicture = UserPreference.avatar;

  @override
  Widget build(BuildContext context) {
    Widget alert = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () => Navigator.of(context).pop(),
        ),
        TextButton(
          child: Text('Ok'),
          onPressed: () => {
            UserPreference.reset(),
            Navigator.of(context).pop(),
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            )
          },
        )
      ],
    );

    AlertDialog _alertLogout = AlertDialog(
      content: Text("Do you wish to logout?"),
      actions: [alert],
    );

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: colorBackground,
      body: SingleChildScrollView(
        child: Container(
          width: deviceWidth,
          height: deviceHeight - devicePaddingTop - 35,
          padding: EdgeInsets.only(top: devicePaddingTop + 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    _name,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  Container(height: 24, width: 24),
                  Stack(
                    children: <Widget>[
                      CircleAvatar(
                        radius: 50,
                        child: ClipOval(
                          child: Image.network(
                            _profilePicture,
                            height: 150,
                            width: 150,
                            fit: BoxFit.cover,
                            loadingBuilder: (BuildContext context, Widget child, ImageChunkEvent loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: loadingProgress.expectedTotalBytes != null
                                      ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes
                                      : null,
                                ),
                              );
                            },
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 1,
                        right: 1,
                        child: InkWell(
                          onTap: () => print("CHANGE PROFILE PICTURE"),
                          child: Container(
                            height: 30,
                            width: 30,
                            child: Icon(
                              Icons.enhance_photo_translate_outlined,
                              color: Colors.white,
                              size: 20,
                            ),
                            decoration: BoxDecoration(
                              color: colorPrimary,
                              borderRadius: BorderRadius.all(Radius.circular(20)),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Container(
                      child: Align(
                        alignment: Alignment.center,
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Date of Birth',
                                style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _dob,
                                style: TextStyle(
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Address',
                                style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _address,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Gender',
                                style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _gender == 'L' ? 'Male' : 'Female',
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 20),
                              Text(
                                'Phone Number',
                                style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                              ),
                              SizedBox(height: 10),
                              Text(
                                _phoneNumber,
                                style: TextStyle(fontWeight: FontWeight.w400),
                              ),
                              SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                        border: Border.all(width: 1.0, color: colorPrimary),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Button(
                    label: "Edit Profile",
                    select: () {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => EditProfile())).then((_) {
                        setState(() {
                          _name = UserPreference.name;
                          _dob = UserPreference.dob;
                          _gender = UserPreference.gender;
                          _phoneNumber = UserPreference.phoneNumber;
                          _address = UserPreference.address;
                          _profilePicture = UserPreference.avatar;
                        });
                      });
                    },
                  ),
                  SizedBox(height: 10),
                  Button(
                    label: "Log Out",
                    gradient: gradientDanger,
                    select: () => showDialog(context: context, builder: (BuildContext context) => _alertLogout),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
