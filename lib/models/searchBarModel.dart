import 'package:flutter/material.dart';

class SearchBarModel {
  final String title;
  final String description;

  SearchBarModel({
    @required this.title,
    @required this.description,
  });
}

final searchList = [
  SearchBarModel(
    title: 'HOME 1',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  SearchBarModel(
    title: 'HOME 2',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  ),
  SearchBarModel(
    title: 'HOME 3',
    description:
        'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
  )
];
