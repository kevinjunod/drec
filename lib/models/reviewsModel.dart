import 'package:drec/models/userModel.dart';

class ReviewModel {
  UserModel user;
  String note;
  double rating;
  bool anonymous;
  DateTime createdDate;

  ReviewModel({
    this.rating,
    this.user,
    this.anonymous,
    this.note,
    this.createdDate,
  });
}
