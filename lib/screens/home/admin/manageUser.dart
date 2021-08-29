import 'package:drec/constants.dart';
import 'package:drec/providers/listUser.dart';
import 'package:drec/screens/home/admin/components/addUser.dart';
import 'package:drec/screens/home/admin/components/userList.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ManageUser extends StatefulWidget {
  ManageUser();
  static const routeName = '/manageUser';
  @override
  _ManageUserState createState() => _ManageUserState();
}

class _ManageUserState extends State<ManageUser> {
  bool _isLoading = true;
  String _name = '';
  int _role = -1;
  List<Map<String, dynamic>> role = [
    {'text': 'Semua', 'value': -1},
    {'text': 'Client', 'value': 1},
    {'text': 'Doctor', 'value': 2},
    {'text': 'Admin', 'value': 3}
  ];

  @override
  void initState() {
    Provider.of<ListUserProvider>(context, listen: false)
        .getList(token: UserPreference.token)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<ListUserProvider>(context).list;
    return Scaffold(
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        padding: EdgeInsets.only(top: 10),
        color: colorPrimary,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 30, left: 16, right: 16),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Search...",
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
                  setState(() {
                    _isLoading = true;
                    _name = val;
                  });
                  Provider.of<ListUserProvider>(context, listen: false)
                      .getList(token: UserPreference.token, name: val, roleId: _role)
                      .then((_) => setState(() => _isLoading = false));
                },
              ),
            ),
            SizedBox(height: 10),
            Container(
              height: 60,
              width: deviceWidth,
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      'Role :',
                      softWrap: true,
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
                    ),
                  ),
                  Container(
                    height: 60,
                    width: (deviceWidth - 32) * 0.8,
                    child: DropdownButtonFormField(
                        items: [
                          for (var item in role) DropdownMenuItem(child: Text(item['text']), value: item['value'])
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: colorLightPrimary,
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: colorLightGrey),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(7),
                            borderSide: BorderSide(color: colorLightGrey),
                          ),
                        ),
                        value: -1,
                        onChanged: (val) {
                          setState(() {
                            _isLoading = true;
                            _role = val;
                          });
                          Provider.of<ListUserProvider>(context, listen: false)
                              .getList(token: UserPreference.token, name: _name, roleId: _role)
                              .then((_) => setState(() => _isLoading = false));
                        }),
                  ),
                ],
              ),
            ),
            _isLoading
                ? Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(child: CircularProgressIndicator(color: Colors.white)),
                        SizedBox(height: 10),
                        Text(
                          'Loading...',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : users.length < 1
                    ? Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 16),
                          child: Text('There\'s no user with your filter'),
                        ),
                      )
                    : Expanded(
                        child: Padding(
                          padding: EdgeInsets.only(top: 10),
                          child: ListView.builder(
                            padding: EdgeInsets.only(top: 8),
                            itemBuilder: (_, index) => UserList(
                              users[index],
                              first: index == 0,
                              last: index == users.length - 1,
                            ),
                            itemCount: users.length,
                            shrinkWrap: true,
                          ),
                        ),
                      ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          PageRouteBuilder(opaque: false, pageBuilder: (ctx, _, __) => AddUser()),
        ),
        child: Icon(Icons.add),
        backgroundColor: Colors.green,
      ),
    );
  }
}
