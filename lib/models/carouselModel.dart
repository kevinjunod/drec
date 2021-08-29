import 'package:flutter/material.dart';
import 'package:drec/constants.dart';

class CarouselHomeModel {
  final String image;
  final String title;
  final String distance;
  final String price;

  CarouselHomeModel({
    @required this.image,
    @required this.title,
    @required this.distance,
    @required this.price,
  });
}

final carouselList = [
  CarouselHomeModel(
    image: "$imgPath/ayam.jpg",
    title: "REKOMENDASI 1",
    distance: "0.7",
    price: "50.000",
  ),
  CarouselHomeModel(
    image: "$imgPath/sotos.jpg",
    title: "REKOMENDASI 2",
    distance: "0.7",
    price: "50.000",
  ),
  CarouselHomeModel(
    image: "$imgPath/risoles.jpg",
    title: "REKOMENDASI 3",
    distance: "0.7",
    price: "50.000",
  ),
];
