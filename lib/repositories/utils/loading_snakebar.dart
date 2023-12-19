import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';

SnackBar loadingSnakebarWidget() {
    return SnackBar(
      padding: const EdgeInsets.all(8.0),
      behavior: SnackBarBehavior.floating,
      backgroundColor: scaffoldColor,  
      content:  Row(
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child:  CircularProgressIndicator(),
          ),
          const SizedBox(width: 16),
          Text(
            "Loading...",
            style: TextStyle(color: buttonColor),
          ),
        ],
      ),
    );
  }
