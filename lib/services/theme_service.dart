import 'package:flutter/material.dart';

class ThemeService{
// Fonts
static const String fontHeader = "Billabong";


//Font size
static const double fontHeaderSize = 30;

// Style
static final TextStyle appBarStyle = TextStyle(color: Colors.black,fontFamily: fontHeader,fontSize: fontHeaderSize);

//BoxDecoration LinearGraident

static BoxDecoration backgroundGradient = const BoxDecoration(
  gradient: LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    colors: [
      Color.fromRGBO(231, 177, 43, 1.0),
      Color.fromRGBO(224, 117, 60, 1.0),
    ]
  )
);

}