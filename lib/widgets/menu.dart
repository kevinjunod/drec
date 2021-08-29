import 'package:flutter/material.dart';
import 'package:drec/constants.dart';

class MenuWidget extends StatelessWidget {
  final String title;
  final Function function;
  final String image;

  MenuWidget({
    Key key,
    this.title,
    this.function,
    this.image,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: deviceHeight / 10,
      width: deviceHeight / 10,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        color: colorLightGrey,
        boxShadow: [
          BoxShadow(
            color: colorGreyText.withOpacity(.2),
            spreadRadius: .3,
            blurRadius: 3,
            offset: Offset(1, 1),
          ),
        ],
      ),
      child: Material(
        child: InkWell(
          borderRadius: BorderRadius.circular(15),
          onTap: function,
          splashColor: colorLightPrimary,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Image.asset(
                "$image",
                height: 45,
                width: 45,
              ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: colorPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
