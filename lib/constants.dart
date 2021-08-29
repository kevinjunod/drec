import 'package:flutter/material.dart';

double deviceHeight;
double deviceWidth;
double devicePaddingTop;
double devicePaddingBottom;

const imgPath = 'assets/img';
const baseUrl = 'http://178.128.63.183:3802/api/'; //URI API
const serverKeyFirebase =
    'AAAAIv8ZP2o:APA91bE4kUlhf9k7zBvPJgCEWMXWn0Id_ugYDeVuVXSLfh8GN3JtouGm-CAH-GC7ghBx-ckZ-dJlCWlxacNAESxyaPHjlMpLakujfjJPbweqw58kDl6X21RevGShImSp0nk54Kk6nAiS';

const colorPrimary = Color(0xffFFC107);
const colorLightPrimary = Color(0xffffecb3);
const colorDarkPrimary = Color(0xffffa000);
const colorSecondary = Color(0xff00BCD4);
const colorText = Color(0xff080808);
const colorGreyText = Color(0xff696969);
const colorBackground = Color(0xfff5f5f5);
const colorLightGrey = Color(0xffFBFAFA);
const colorBlack = Color(0xff000000);
const colorWhite = Color(0xffFFFFFF);

final Shader gradient = LinearGradient(
  colors: <Color>[
    colorPrimary,
    colorWhite,
  ],
).createShader(
  Rect.fromLTRB(0, 100, 0, 70),
);

final gradientPrimary = LinearGradient(
  colors: <Color>[colorPrimary, colorDarkPrimary],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final gradientDanger = LinearGradient(
  colors: <Color>[Colors.red[300], Colors.red[500]],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final gradientSuccess = LinearGradient(
  colors: <Color>[Colors.green[300], Colors.green[500]],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);

final gradientDefault = LinearGradient(
  colors: <Color>[Colors.grey[300], Colors.grey[500]],
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
);
