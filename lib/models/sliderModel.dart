import 'package:flutter/material.dart';
import 'package:drec/constants.dart';

class SliderModel {
  final String imageUrl;
  final String title;
  final String description;

  SliderModel({
    @required this.imageUrl,
    @required this.title,
    @required this.description,
  });
}

final slideList = [
  SliderModel(
    imageUrl: '$imgPath/DRec.png',
    title: 'drec mantap 1',
    description:
        '1. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  SliderModel(
    imageUrl: '$imgPath/DRec.png',
    title: 'drec mantap 2',
    description:
        '2. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  SliderModel(
    imageUrl: '$imgPath/DRec.png',
    title: 'drec mantap 3',
    description:
        '3. Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
];
