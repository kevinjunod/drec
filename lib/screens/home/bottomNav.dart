import 'package:drec/constants.dart';
//* Pages home sebagai Admin
import 'package:drec/screens/home/admin/manageUser.dart';
//* Pages home sebagai Client/Pasien
import 'package:drec/screens/home/client/appointment/appointment.dart';
import 'package:drec/screens/home/client/history/history.dart';
import 'package:drec/screens/home/consultation/consultation.dart';
//* Pages home sebagai Doctor
import 'package:drec/screens/home/doctor/appointment/appointment.dart';
import 'package:drec/screens/home/profile/profile.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  final int userRole;
  final int navIndex;
  BottomNav({
    this.userRole,
    this.navIndex,
  });
  static const routeName = '/navigation';
  @override
  _BottomNavState createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final clientMenus = [
    AppointmentClient(),
    HistoryAppointmentClient(),
    Consultation(),
    Profile(),
  ];

  final doctorMenus = [
    AppointmentDoctor(),
    Consultation(),
    Profile(),
  ];

  final adminMenus = [
    ManageUser(),
    Profile(),
  ];

  int _currentIndex;

  @override
  void initState() {
    setState(() => _currentIndex = widget.navIndex ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.userRole == 1) {
      return Scaffold(
        body: clientMenus[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorWhite,
          selectedItemColor: colorDarkPrimary,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: "Appointment",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.history),
              label: "History",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "Consultation",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
              backgroundColor: colorPrimary,
            ),
          ],
          onTap: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      );
    } else if (widget.userRole == 2) {
      return Scaffold(
        body: doctorMenus[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorWhite,
          selectedItemColor: colorDarkPrimary,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.calendar_today_rounded),
              label: "Appointment",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.chat_rounded),
              label: "Consultation",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
              backgroundColor: colorPrimary,
            ),
          ],
          onTap: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      );
    } else if (widget.userRole == 3) {
      return Scaffold(
        body: adminMenus[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          type: BottomNavigationBarType.fixed,
          backgroundColor: colorWhite,
          selectedItemColor: colorDarkPrimary,
          currentIndex: _currentIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.supervised_user_circle),
              label: "Manage",
              backgroundColor: colorPrimary,
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.account_circle),
              label: "Profile",
              backgroundColor: colorPrimary,
            ),
          ],
          onTap: (index) {
            setState(
              () {
                _currentIndex = index;
              },
            );
          },
        ),
      );
    }
    return Container(
      width: 0,
      height: 0,
    );
  }
}
