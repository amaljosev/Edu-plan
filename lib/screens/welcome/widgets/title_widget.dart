import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';

class TitleCardWidget extends StatelessWidget {
  const TitleCardWidget({super.key, required this.isUpdate});
  final bool isUpdate;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(
          height: 40,
        ),
       isUpdate ? const Center(
            child: Text(
                 "Update Teacher's data ",
                style: TextStyle(
                    color: headingColor,
                    fontSize: 20,
                    fontWeight: FontWeight.w300))):const SizedBox(), 
        isUpdate
            ? const SizedBox()
            : Center(
                child: Text(
                'Welcome To ',
                style: GoogleFonts.macondo(
                    fontSize: 20,
                    letterSpacing: 3,
                    fontWeight: FontWeight.bold,
                    color: headingColor),
              )),
        const SizedBox(
          height: 10,
        ),
        isUpdate
            ? const SizedBox()
            : Center(
                child: Text(
                  'Edu Plan',
                  style: GoogleFonts.macondo(
                      fontSize: 35,
                      letterSpacing: 3,
                      fontWeight: FontWeight.bold,
                      color: titleColor),
                ),
              ),
        const SizedBox(
          height: 40,
        ),
        isUpdate
            ? const SizedBox()
            : const Center(
                child: Text('Sign Up to continue', 
                    style: TextStyle(
                        color: headingColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w300))),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}
