import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drec/constants.dart';
import 'package:drec/screens/home/consultation/chatDetail.dart';
import 'package:drec/utils/preference.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// ignore: must_be_immutable
class ChatList extends StatefulWidget {
  String name;
  String messageText;
  String imageURL;
  bool isMessageRead;
  int time;
  int id;

  ChatList({
    @required this.id,
    @required this.name,
    @required this.messageText,
    @required this.imageURL,
    @required this.time,
    @required this.isMessageRead,
  });

  static const routeName = '/chatList';
  @override
  _ChatListState createState() => _ChatListState();
}

class _ChatListState extends State<ChatList> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  Widget build(BuildContext context) {
    String _name = widget.name;
    String _imageURL = widget.imageURL;
    final sender = UserPreference.roleId == 1;
    final collection = sender ? '${UserPreference.id}-${widget.id}' : '${widget.id}-${UserPreference.id}';

    return Padding(
      padding: EdgeInsets.only(bottom: 10),
      child: GestureDetector(
        onTap: () async {
          Map<String, dynamic> update = sender ? {'sender_new_message': false} : {'receiver_new_message': false};
          await firestore.collection('chats').doc(collection).update(update);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatDetail(
                name: _name,
                imageURL: _imageURL,
                sender: sender,
                id: widget.id,
              ),
            ),
          );
        },
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 15),
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isMessageRead ? colorLightGrey : Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 1.5,
                blurRadius: 5,
                offset: Offset(0, 0), // changes position of shadow
              ),
            ],
          ),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CircleAvatar(
                      child: ClipOval(
                        child: Image.network(
                          widget.imageURL,
                          height: 150,
                          width: 150,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // backgroundImage: NetworkImage(widget.imageURL),
                      maxRadius: 30,
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              widget.name,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                              ),
                            ),
                            SizedBox(height: 6),
                            widget.messageText == null
                                ? Text(
                                    'There\'s no chat. Start now',
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      fontStyle: FontStyle.italic,
                                    ),
                                  )
                                : Text(
                                    widget.messageText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade600,
                                      fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.time == 0
                        ? ''
                        : DateFormat('HH:mm').format(DateTime.fromMillisecondsSinceEpoch(widget.time)),
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: widget.isMessageRead ? FontWeight.bold : FontWeight.normal,
                    ),
                  ),
                  widget.isMessageRead
                      ? Container(
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: Colors.green),
                          padding: EdgeInsets.all(5),
                          child: Text(
                            'New',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        )
                      : SizedBox(height: 26),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
