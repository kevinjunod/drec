import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:drec/constants.dart';
import 'package:drec/models/carouselModel.dart';

class Carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        for (int i = 0; i < carouselList.length; i++)
          CarouselSlider(
            height: 10.0,
            enlargeCenterPage: true,
            autoPlay: true,
            aspectRatio: 16 / 9,
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: false,
            autoPlayAnimationDuration: Duration(
              milliseconds: 800,
            ),
            viewportFraction: 0.8,
            items: [
              Container(
                margin: EdgeInsets.all(7),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  image: DecorationImage(
                    image: AssetImage(carouselList[i].image),
                    // image: AssetImage("$imgPath/download.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            ],
          )
      ],
    );
  }
}
