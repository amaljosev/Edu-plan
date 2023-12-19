import 'package:flutter/material.dart';

class AlertMessages {
  ScaffoldFeatureController<SnackBar, SnackBarClosedReason>
      alertMessageSnakebar(
          BuildContext context, String message, Color alertColor) {
    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      
      behavior: SnackBarBehavior.floating,
      padding: const EdgeInsets.all(10),
      duration: const Duration(seconds: 1), 
      content: Text( 
        message, 
        style: const TextStyle(color: Colors.white),
      ),
      backgroundColor: alertColor,
      
    ));
  }
}
