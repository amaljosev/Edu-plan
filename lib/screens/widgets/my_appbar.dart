import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';

AppBar myAppbar(String title) {
  return AppBar(
    title: Text(
      title,
      style: appbarTextStyle,
    ),
    backgroundColor: appbarColor,
    
  );
}
