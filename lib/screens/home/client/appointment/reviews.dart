import 'package:drec/constants.dart';
import 'package:drec/providers/review.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class Reviews extends StatefulWidget {
  final String name;
  final int doctorId;
  const Reviews({@required this.name, @required this.doctorId, Key key}) : super(key: key);

  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  bool _isLoading = true;

  @override
  void initState() {
    Provider.of<ReviewsProvider>(context, listen: false)
        .getList(doctorId: widget.doctorId)
        .then((_) => setState(() => _isLoading = false));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final list = Provider.of<ReviewsProvider>(context).list;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: colorPrimary,
        iconTheme: IconThemeData(color: colorBlack),
        title: Text("Review ${widget.name}"),
      ),
      resizeToAvoidBottomInset: false,
      body: _isLoading
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(child: CircularProgressIndicator(color: colorPrimary)),
                SizedBox(height: 10),
                Text('Loading...'),
              ],
            )
          : list.length < 1
              ? Padding(
                  padding: EdgeInsets.all(15),
                  child: Text('Belum ada review...', style: TextStyle(fontStyle: FontStyle.italic)),
                )
              : ListView.builder(
                  itemBuilder: (ctx, idx) {
                    String name = list[idx].user.name;
                    if (list[idx].anonymous) {
                      name = name[0] + '****' + name[name.length - 1];
                    }
                    return Container(
                      margin: EdgeInsets.only(left: 15, right: 15, top: 15),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: .5,
                            blurRadius: 2,
                            offset: Offset(0, 0), // changes position of shadow
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(name, style: TextStyle(fontSize: 14)),
                              RatingBarIndicator(
                                rating: list[idx].rating,
                                itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                                itemCount: 5,
                                itemSize: 20,
                              )
                            ],
                          ),
                          Text(
                            'On ' + DateFormat('dd MMMM yyyy HH:mm').format(list[idx].createdDate),
                            style: TextStyle(fontSize: 12, color: colorGreyText),
                          ),
                          SizedBox(height: 10),
                          Text(
                            list[idx].note,
                            style: TextStyle(fontSize: 12, color: colorGreyText, fontStyle: FontStyle.italic),
                          ),
                        ],
                      ),
                    );
                  },
                  itemCount: list.length,
                ),
    );
  }
}
