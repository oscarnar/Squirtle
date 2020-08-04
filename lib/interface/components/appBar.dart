import 'package:flutter/material.dart';

AppBar buildAppBar(Size size) {
  return AppBar(
    title: Image.asset(
      'assets/images/name.png',
      fit: BoxFit.fitHeight,
      height: size.width * 0.1,
    ),
    centerTitle: true,
  );
}
