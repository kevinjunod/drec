import 'package:drec/constants.dart';
import 'package:drec/models/listAppointmentModel.dart';
import 'package:drec/providers/review.dart';
import 'package:drec/utils/httpException.dart';
import 'package:drec/utils/preference.dart';
import 'package:drec/widgets/button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:html_unescape/html_unescape.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class HistoryDetail extends StatefulWidget {
  final ListAppointmentModel appointment;
  const HistoryDetail(this.appointment, {Key key}) : super(key: key);

  @override
  _HistoryDetailState createState() => _HistoryDetailState();
}

class _HistoryDetailState extends State<HistoryDetail> {
  final unescape = HtmlUnescape();
  TextEditingController feedback = new TextEditingController(text: ' ');
  double _rating = 3;
  bool _anonymous = false;
  bool _hasReview = false;
  bool _isLoading = true;
  int idReview;

  @override
  void initState() {
    if (widget.appointment.reviews != null && widget.appointment.reviews.length > 0) {
      final reviews = widget.appointment.reviews;
      print(widget.appointment.reviews);
      for (int i = 0; i < reviews.length; i++) {
        if (reviews[i].user.id == UserPreference.id) {
          _rating = reviews[i].rating;
          _anonymous = reviews[i].anonymous;
          feedback.text = reviews[i].note;
          _hasReview = true;
        }

        if (i == reviews.length - 1) {
          setState(() => _isLoading = false);
        }
      }
    } else {
      setState(() => _isLoading = false);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final date = DateFormat('yyyy-MM-dd').parse(widget.appointment.appointmentDate);
    final startTime = DateFormat('HH:mm:ss').parse(widget.appointment.appointmentStartTime);
    final endTime = DateFormat('HH:mm:ss').parse(widget.appointment.appointmentEndTime);

    return Scaffold(
      appBar: AppBar(title: Text('Appointment Detail')),
      body: Container(
        width: deviceWidth,
        height: deviceHeight,
        child: _isLoading
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Center(child: CircularProgressIndicator(color: colorPrimary)),
                  SizedBox(height: 10),
                  Text('Loading...'),
                ],
              )
            : SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 40,
                            child: ClipOval(
                              child: Image.network(
                                widget.appointment.doctor.avatar,
                                height: 150,
                                width: 150,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                          SizedBox(width: 15),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${widget.appointment.doctor.name}",
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                                ),
                                Row(
                                  children: [
                                    Text('Rp. ${widget.appointment.doctor.price}'),
                                    SizedBox(width: 4),
                                    Text(' ● ', style: TextStyle(color: colorGreyText)),
                                    Icon(Icons.star, color: colorPrimary, size: 24),
                                    Text('${widget.appointment.doctor.rating}'),
                                    Text('(${widget.appointment.doctor.reviewCount})',
                                        style: TextStyle(color: colorGreyText))
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      Table(
                        columnWidths: {
                          0: FlexColumnWidth(1.5),
                          1: FlexColumnWidth(3),
                        },
                        children: [
                          TableRow(
                            children: [
                              TableCell(
                                child: Text(
                                  'Date',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              TableCell(
                                child: Text(DateFormat('dd MMMM yyyy').format(date)),
                              )
                            ],
                          ),
                          TableRow(
                            children: [
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    'Time',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                              TableCell(
                                child: Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: Text(
                                    '${DateFormat('HH:mm').format(startTime)} - ${DateFormat('HH:mm').format(endTime)} WIB',
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 20),
                      Text(
                        'Doctor Note',
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 5),
                      widget.appointment.doctorNote != null
                          ? Text(unescape.convert(widget.appointment.doctorNote))
                          : Text(
                              'You haven\'t consulted with doctor',
                              style: TextStyle(fontStyle: FontStyle.italic),
                            ),
                      SizedBox(height: 50),
                      Visibility(
                        visible: widget.appointment.isDone,
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Give your feedback', style: TextStyle(fontWeight: FontWeight.bold)),
                                _hasReview
                                    ? RatingBarIndicator(
                                        rating: _rating,
                                        itemBuilder: (context, index) => Icon(Icons.star, color: Colors.amber),
                                        itemCount: 5,
                                        itemSize: 30,
                                      )
                                    : RatingBar.builder(
                                        initialRating: _rating,
                                        minRating: 1,
                                        direction: Axis.horizontal,
                                        allowHalfRating: true,
                                        glow: false,
                                        itemSize: 30,
                                        itemCount: 5,
                                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                                        itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
                                        onRatingUpdate: (rating) => _rating = rating,
                                      ),
                              ],
                            ),
                            CheckboxListTile(
                              title: Text('Send with anonymous'),
                              controlAffinity: ListTileControlAffinity.leading,
                              contentPadding: EdgeInsets.zero,
                              value: _anonymous,
                              onChanged: (val) {
                                if (!_hasReview) {
                                  setState(() => _anonymous = !_anonymous);
                                }
                              },
                            ),
                            SizedBox(height: 5),
                            TextField(
                              maxLines: 4,
                              controller: feedback,
                              readOnly: _hasReview,
                              decoration: InputDecoration(
                                labelText: 'Feedback',
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.blue,
                                    width: 1.0,
                                  ),
                                ),
                              ),
                            ),
                            SizedBox(height: 10),
                            Button(
                              label: 'Submit',
                              gradient: _hasReview ? gradientDefault : gradientPrimary,
                              select: _hasReview
                                  ? () {}
                                  : () async {
                                      setState(() => _isLoading = true);
                                      try {
                                        await Provider.of<ReviewsProvider>(context, listen: false).createReview(
                                          appointmentId: widget.appointment.id,
                                          rating: _rating,
                                          anonymous: _anonymous,
                                          note: feedback.text,
                                          doctorId: widget.appointment.doctor.id,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text('Success submit review'),
                                          backgroundColor: Colors.green,
                                          elevation: 6,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(13))),
                                        ));
                                        setState(() => _isLoading = false);
                                      } on HttpException catch (err) {
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text(err.message),
                                          backgroundColor: colorPrimary,
                                          elevation: 6,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(13))),
                                        ));
                                        setState(() => _isLoading = false);
                                      } catch (err) {
                                        print(err);
                                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                          content: Text("Internal Server Error. Silahkan coba kembali"),
                                          backgroundColor: Colors.red,
                                          elevation: 6,
                                          behavior: SnackBarBehavior.floating,
                                          margin: EdgeInsets.all(20),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(Radius.circular(13))),
                                        ));
                                        setState(() => _isLoading = false);
                                      }
                                    },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
