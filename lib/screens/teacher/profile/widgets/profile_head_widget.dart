import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';

class ProfileHeadWidget extends StatelessWidget {
  const ProfileHeadWidget({
    super.key,
    required this.image,
    required this.name,
  });
  final String image;
  final String name;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 130,
      decoration: BoxDecoration(color: appbarColor),
      child: Row(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: headingColor,
              radius: 60,
              child: CircleAvatar(
                radius: 55,
                backgroundImage: AssetImage(image),
              ),
            ),
          ),
          Text(name.toUpperCase(),
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.teko(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: headingColor)),
        ],
      ),
    );
  }
}
