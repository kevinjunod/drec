import 'package:drec/constants.dart';
import 'package:drec/models/userModel.dart';
import 'package:drec/providers/listUser.dart';
import 'package:drec/screens/home/admin/components/editUser.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserDetail extends StatelessWidget {
  final UserModel user;
  const UserDetail(this.user, {Key key}) : super(key: key);

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
            Provider.of<ListUserProvider>(context, listen: false).deleteUser(user.id).then((_) {
              Provider.of<ListUserProvider>(context, listen: false).getList(token: UserPreference.token).then((_) {
                Navigator.of(context).pop();
                Navigator.of(context).pop();
              });
            }),
          },
        )
      ],
    );

    AlertDialog _alertLogout = AlertDialog(
      content: Text("Are you sure to delete ${user.name} ?"),
      actions: [alert],
    );

    return Scaffold(
      appBar: AppBar(title: Text('Detail User', style: TextStyle(fontWeight: FontWeight.bold))),
      backgroundColor: colorBackground,
      body: ChangeNotifierProvider(
        create: (_) => ListUserProvider(),
        child: Container(
          width: deviceWidth,
          height: deviceHeight - devicePaddingTop - 65,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user.name,
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 5),
                        Text(user.roleName),
                      ],
                    ),
                    SizedBox(height: 24, width: 24),
                    CircleAvatar(
                      radius: 50,
                      child: ClipOval(
                        child: Image.network(
                          user.avatar,
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
                                  user.dob,
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
                                  user.address,
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Gender',
                                  style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  user.gender == 'L' ? 'Male' : 'Female',
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                SizedBox(height: 20),
                                Text(
                                  'Phone Number',
                                  style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                ),
                                SizedBox(height: 10),
                                Text(
                                  user.phoneNumber,
                                  style: TextStyle(fontWeight: FontWeight.w400),
                                ),
                                if (user.roleId == 2)
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      SizedBox(height: 20),
                                      Text(
                                        'Specialization',
                                        style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        user.specialization,
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Graduate Date',
                                        style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        user.graduate,
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Price',
                                        style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        'Rp. ${user.price}',
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                      SizedBox(height: 20),
                                      Text(
                                        'Available Time',
                                        style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      generateAvailableTime(),
                                      SizedBox(height: 20),
                                      Text(
                                        'Active',
                                        style: TextStyle(color: colorText, fontSize: 15, fontWeight: FontWeight.w600),
                                      ),
                                      SizedBox(height: 10),
                                      Text(
                                        user.active ? 'Yes' : 'No',
                                        style: TextStyle(fontWeight: FontWeight.w400),
                                      ),
                                    ],
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
                      label: "Edit User",
                      select: () => Navigator.push(context, MaterialPageRoute(builder: (context) => EditUser(user))),
                    ),
                    SizedBox(height: 10),
                    Button(
                      label: "Delete User",
                      gradient: gradientDanger,
                      select: () => showDialog(context: context, builder: (BuildContext context) => _alertLogout),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget generateAvailableTime() {
    List<Widget> widget = [];

    user.availableTime.forEach(
      (key, value) => widget.add(
        Padding(
          padding: EdgeInsets.only(top: key != 'Sunday' ? 5 : 0),
          child: Row(
            children: [
              Container(
                width: 100,
                child: Text(key, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
              SizedBox(width: 10),
              Text('${value['start']} - ${value['end']} ${value['start'] != '' ? 'WIB' : ''}'),
            ],
          ),
        ),
      ),
    );

    return Column(
      children: widget,
    );
  }
}
