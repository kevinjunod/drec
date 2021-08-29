import 'package:drec/constants.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String label;
  final Function select;
  final LinearGradient gradient;

  Button({
    Key key,
    this.label,
    this.select,
    this.gradient,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        height: deviceHeight * (0.07),
        width: deviceWidth * .9,
        decoration: BoxDecoration(
          gradient: gradient != null ? gradient : gradientPrimary,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
            )
          ],
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: select,
            child: Center(
              child: Text(
                label,
                style: TextStyle(
                  color: colorWhite,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
