import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/admin/bloc/admin_bloc.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenAllTeachers extends StatelessWidget {
  const ScreenAllTeachers({super.key, required this.teachersList});
  final List<dynamic> teachersList;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('All Teachers'),
      body: Column(
        children: [
          Container(
            color: appbarColor,
            height: 30,
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 38.0),
                  child: Text(
                    'Class',
                    style: titleTextStyle,
                  ),
                ),
                Text(
                  'Name',
                  style: titleTextStyle,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
                itemCount: teachersList.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot document = teachersList[index];
                  final String teacherId = document.id;
                  Map<String, dynamic> data =
                      document.data() as Map<String, dynamic>;
                  final standard = data["class"];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Card(
                      child: ListTile(
                        leading: CircleAvatar(
                          radius: 30,
                          child: Text(
                            standard,
                            style: GoogleFonts.teko(
                                fontSize: 45,
                                letterSpacing: 3,
                                fontWeight: FontWeight.bold,
                                color: headingColor),
                          ),
                        ),
                        title: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 15.0),
                          child:
                              Text('${data["name"]}', style: contentTextStyle),
                        ),
                        onTap: () => context.read<AdminBloc>().add(
                            TeacherCardTapEvent(
                                teacherData: data, teacherId: teacherId)),
                      ),
                    ),
                  );
                }),
          ),
        ],
      ),
    );
  }
}
