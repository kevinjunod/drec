import 'package:flutter/material.dart';
import 'package:drec/constants.dart';

class RadioButton extends StatelessWidget {
  final bool selectedType;
  final String label;
  final Function select;

  RadioButton({
    Key key,
    this.selectedType,
    this.label,
    this.select,
  }) : super(key: key);

  @override
  build(BuildContext context) {
    return Row(
      children: <Widget>[
        GestureDetector(
          onTap: select,
          child: Container(
            width: 15,
            height: 15,
            padding: EdgeInsets.all(2),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                width: 2,
                color: colorBlack,
              ),
            ),
            child: selectedType
                ? Container(
                    width: double.infinity,
                    height: double.infinity,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: colorBlack,
                    ),
                  )
                : Container(),
          ),
        ),
        SizedBox(
          width: 8,
        ),
        Text(
          label,
          style: TextStyle(
            fontFamily: 'Montserrat',
            fontSize: 14.0,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
