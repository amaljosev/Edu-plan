import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';

class ButtonSubmissionWidget extends StatelessWidget {
  const ButtonSubmissionWidget({ 
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
  });
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 18.0),
      child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              fixedSize: const Size(120, 30), 
              elevation: 10),
          onPressed: () => onTap(),
          icon: Icon(icon, color: whiteTextColor),
          label: Text(
            label,
            style: const TextStyle(color: whiteTextColor),
          )),
    );
  }
}
