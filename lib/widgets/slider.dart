import 'package:flutter/material.dart';
import 'package:drec/constants.dart';
import 'package:drec/models/sliderModel.dart';

class SliderItem extends StatelessWidget {
  final int index;
  SliderItem(this.index);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 200,
          height: 200,
          decoration: BoxDecoration(
            // shape: BoxShape.circle,
            image: DecorationImage(
              image: AssetImage(slideList[index].imageUrl),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          slideList[index].title,
          style: TextStyle(
            fontSize: 23,
            color: colorDarkPrimary,
          ),
        ),
        SizedBox(
          height: 10,
        ),
        Text(
          slideList[index].description,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12,
            color: colorBlack,
          ),
        ),
      ],
    );
  }
}
