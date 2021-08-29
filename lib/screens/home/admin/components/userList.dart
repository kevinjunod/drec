import 'package:drec/models/userModel.dart';
import 'package:drec/providers/listUser.dart';
import 'package:drec/screens/home/admin/components/userDetail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserList extends StatelessWidget {
  final UserModel user;
  final bool first;
  final bool last;
  const UserList(this.user, {@required this.first, @required this.last, Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ListUserProvider(),
      child: Container(
        margin: EdgeInsets.only(
          top: first ? 0 : 10,
          bottom: last ? 10 : 0,
          left: 16,
          right: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.5,
              blurRadius: 5,
              offset: Offset(0, 0), // changes position of shadow
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            splashColor: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) {
                    return UserDetail(user);
                  },
                ),
              );
            },
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Row(
                      children: <Widget>[
                        CircleAvatar(
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
                          // backgroundImage: NetworkImage(widget.imageURL),
                          maxRadius: 30,
                        ),
                        SizedBox(
                          width: 16,
                        ),
                        Expanded(
                          child: Container(
                            color: Colors.transparent,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  user.name,
                                  style: TextStyle(fontSize: 16),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  user.email,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                                SizedBox(
                                  height: 6,
                                ),
                                Text(
                                  user.roleName,
                                  style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
