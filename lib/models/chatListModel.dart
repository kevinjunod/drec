import 'package:flutter/material.dart';

class ChatListModel {
  String name;
  String messageText;
  String imageURL;
  String time;

  ChatListModel({
    @required this.name,
    @required this.messageText,
    @required this.imageURL,
    @required this.time,
  });
}
