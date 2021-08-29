import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dio/dio.dart';
import 'package:drec/constants.dart';
import 'package:drec/screens/home/consultation/viewImage.dart';
import 'package:drec/utils/preference.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';

class ChatDetail extends StatefulWidget {
  int id;
  String name;
  String imageURL;
  bool sender;

  ChatDetail({@required this.id, @required this.name, @required this.imageURL, @required this.sender});

  static const routeName = '/chatDetail';
  @override
  _ChatDetailState createState() => _ChatDetailState();
}

class _ChatDetailState extends State<ChatDetail> {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  TextEditingController _controller = new TextEditingController();
  ScrollController _scrollController = new ScrollController();
  String selectedId;
  String lastMessage = '';
  bool isLast = false;
  int lastTimestamp = 0;

  _scrollToEnd() async {
    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
      final collection = widget.sender ? '${UserPreference.id}-${widget.id}' : '${widget.id}-${UserPreference.id}';
      Map<String, dynamic> update = widget.sender ? {'sender_new_message': false} : {'receiver_new_message': false};

      await firestore.collection('chats').doc(collection).update(update);
    }
  }

  void sendMessage(String message, String type) async {
    FocusScope.of(context).unfocus();
    final collection = widget.sender ? '${UserPreference.id}-${widget.id}' : '${widget.id}-${UserPreference.id}';
    final msgInstance = firestore.collection('chats/$collection/messages');
    final msg = {
      'message_type': type,
      'type': widget.sender ? 'sender' : 'receiver',
      'message': message,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
    };
    await msgInstance.add(msg);
    Map<String, dynamic> update = widget.sender
        ? {'receiver_new_message': true, 'sender_new_message': false}
        : {'sender_new_message': true, 'receiver_new_message': false};
    update = {
      ...update,
      'last_message': type == 'image' ? 'Image uploaded' : msg['message'],
      'last_message_time': msg['timestamp']
    };
    await firestore.collection('chats').doc(collection).update(update);
    final target = await firestore.collection('users').where('id', isEqualTo: widget.id).get();
    String payload = json.encode({
      'registration_ids': [target.docs[0]['fcm']],
      'notification': {
        'title': 'You have a message from "${UserPreference.name}"',
        'body': message,
        'badge': '1',
        'sound': 'default'
      },
      'data': {'click_action': 'consultation'}
    });

    final dio = Dio();
    final Map<String, dynamic> headers = {
      "Content-type": "application/json; charset=UTF-8",
      "Authorization": "key=$serverKeyFirebase",
    };
    print(headers);
    dio.options.baseUrl = 'https://fcm.googleapis.com/';
    dio.options.headers = headers;
    dio
        .post('fcm/send', data: payload)
        .then((_) => print('success send push notif'))
        .catchError((err) => print('failed send push notif with error $err'));
    _controller.clear();
    _scrollToEnd();
  }

  @override
  Widget build(BuildContext context) {
    final collection = widget.sender ? '${UserPreference.id}-${widget.id}' : '${widget.id}-${UserPreference.id}';
    final type = widget.sender ? 'receiver' : 'sender';

    Widget alert = Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        TextButton(
          child: Text('Cancel'),
          onPressed: () {
            setState(() => selectedId = '');
            Navigator.of(context).pop();
          },
        ),
        TextButton(
          child: Text('Ok'),
          onPressed: () {
            firestore.collection('chats/$collection/messages').doc(selectedId).delete();
            if (isLast)
              firestore
                  .collection('chats')
                  .doc(collection)
                  .update({'last_message': lastMessage, 'last_message_time': lastTimestamp});
            setState(() => selectedId = '');
            Navigator.of(context).pop();
          },
        )
      ],
    );

    AlertDialog _alertDelete = AlertDialog(
      content: Text("Are you sure want to delete this message?"),
      actions: [alert],
    );

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        flexibleSpace: SafeArea(
          child: Container(
            padding: EdgeInsets.only(right: 16),
            child: Row(
              children: <Widget>[
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: Icon(Icons.arrow_back, color: Colors.black),
                ),
                SizedBox(width: 2),
                CircleAvatar(
                  child: ClipOval(
                    child: Image.network(
                      widget.imageURL,
                      height: 150,
                      width: 150,
                      fit: BoxFit.cover,
                    ),
                  ),
                  maxRadius: 20,
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        widget.name,
                        style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 14),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('chats')
                    .doc(collection)
                    .collection('messages')
                    .orderBy('timestamp', descending: false)
                    .snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  if (snapshot.hasData) {
                    WidgetsBinding.instance.addPostFrameCallback((_) => _scrollToEnd());
                    return snapshot.data.docs.length < 1
                        ? Container(
                            child: Center(
                              child: Text(
                                'Let\'s Start Chat Doctor',
                                style: TextStyle(fontSize: 20),
                              ),
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: EdgeInsets.symmetric(vertical: 10),
                            itemBuilder: (context, index) {
                              final data = snapshot.data?.docs[index];
                              final time = DateFormat('hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(data.get('timestamp')),
                              );
                              final timestamp = DateFormat('dd-MM-yyyy hh:mm a').format(
                                DateTime.fromMillisecondsSinceEpoch(data.get('timestamp')),
                              );
                              return GestureDetector(
                                onLongPress: () {
                                  if (data.get('type') != type) {
                                    setState(() => selectedId = data.id);
                                    isLast = (index + 1) == snapshot.data.docs.length;
                                    if (snapshot.data.docs.length > 1) {
                                      final lastData = snapshot.data.docs[index - 1];
                                      lastMessage = lastData.get('message_type') == 'image'
                                          ? 'Image uploaded'
                                          : lastData.get('message');
                                      lastTimestamp = lastData.get('timestamp');
                                    }
                                    return showDialog(
                                        context: context, builder: (BuildContext context) => _alertDelete);
                                  }
                                },
                                child: Container(
                                  color: selectedId == data.id ? Colors.grey.withOpacity(.5) : Colors.transparent,
                                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                                  child: Align(
                                    alignment: data.get('type') == type ? Alignment.topLeft : Alignment.topRight,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.only(
                                          bottomLeft: Radius.circular(20),
                                          bottomRight: Radius.circular(20),
                                          topRight: data.get('type') == type ? Radius.circular(20) : Radius.zero,
                                          topLeft: data.get('type') == type ? Radius.zero : Radius.circular(20),
                                        ),
                                        color: data.get('type') == type ? Colors.grey.shade200 : colorLightPrimary,
                                      ),
                                      padding: EdgeInsets.all(15),
                                      child: data.get('message_type') == 'image'
                                          ? GestureDetector(
                                              onTap: () => Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                  builder: (_) => ViewImage(
                                                    data.get('message'),
                                                    data.get('type') == type ? widget.name : 'You',
                                                    time,
                                                  ),
                                                ),
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Image.network(
                                                    data.get('message'),
                                                    height: 150,
                                                    width: 150,
                                                    fit: BoxFit.cover,
                                                  ),
                                                  SizedBox(height: 5),
                                                  Text(time, style: TextStyle(fontSize: 10, color: colorGreyText)),
                                                ],
                                              ),
                                            )
                                          : Row(
                                              mainAxisSize: MainAxisSize.min,
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(data.get('message'), style: TextStyle(fontSize: 15)),
                                                SizedBox(width: 10),
                                                Text(timestamp, style: TextStyle(fontSize: 10, color: colorGreyText)),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            itemCount: snapshot.data.docs.length,
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
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: Container(
              padding: EdgeInsets.only(left: 10, bottom: 10, top: 10),
              height: 60,
              width: double.infinity,
              color: Colors.white,
              child: Row(
                children: <Widget>[
                  GestureDetector(
                    onTap: () async {
                      var image = await ImagePicker().getImage(source: ImageSource.gallery);
                      int timestamp = new DateTime.now().millisecondsSinceEpoch;
                      Reference storageReference = FirebaseStorage.instance.ref().child(timestamp.toString());
                      UploadTask uploadTask = storageReference.putFile(File(image.path));
                      TaskSnapshot snapshot = await uploadTask;
                      String fileUrl = await snapshot.ref.getDownloadURL();
                      sendMessage(fileUrl, 'image');
                    },
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                        color: colorPrimary,
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: Icon(Icons.photo, color: Colors.white, size: 20),
                    ),
                  ),
                  SizedBox(width: 15),
                  Expanded(
                    child: TextField(
                      textInputAction: TextInputAction.send,
                      onSubmitted: (val) => sendMessage(val, 'message'),
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Write message...",
                        hintStyle: TextStyle(color: Colors.black54),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  SizedBox(width: 15),
                  FloatingActionButton(
                    onPressed: () => sendMessage(_controller.text, 'message'),
                    child: Icon(Icons.send, color: Colors.white, size: 18),
                    backgroundColor: colorPrimary,
                    elevation: 0,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
