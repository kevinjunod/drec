import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:drec/constants.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/chatList.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class Consultation extends StatefulWidget {
  Consultation();
  static const routeName = '/consultation';
  @override
  _ConsultationState createState() => _ConsultationState();
}

class _ConsultationState extends State<Consultation> {
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging.instance;
  final userId = UserPreference.id;

  @override
  Widget build(BuildContext context) {
    final sender = UserPreference.roleId == 1;
    final chatWhere = sender ? 'sender_id' : 'receiver_id';
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        color: colorPrimary,
        height: deviceHeight,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SafeArea(
                child: Padding(
                  padding: EdgeInsets.only(left: 16, right: 16, top: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Chats",
                        style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .orderBy('last_message_time', descending: true)
                    .where(chatWhere, isEqualTo: UserPreference.id)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    final data = snapshot.data.docs.toList();
                    final length = snapshot.data.docs.length;
                    return length == 0
                        ? Padding(
                            padding: const EdgeInsets.all(20),
                            child: Text(
                              'You\'d never had a live consultation',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                          )
                        : ListView.builder(
                            padding: EdgeInsets.only(top: 16),
                            itemBuilder: (_, index) {
                              return ChatList(
                                name: sender ? data[index].get('receiver_name') : data[index].get('sender_name'),
                                messageText: data[index].get('last_message'),
                                imageURL:
                                    sender ? data[index].get('receiver_avatar') : data[index].get('sender_avatar'),
                                time: data[index].get('last_message_time'),
                                id: sender ? data[index].get('receiver_id') : data[index].get('sender_id'),
                                isMessageRead: sender
                                    ? data[index].get('sender_new_message')
                                    : data[index].get('receiver_new_message'),
                              );
                            },
                            itemCount: length,
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                          );
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(colorPrimary),
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
