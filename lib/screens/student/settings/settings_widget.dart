import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:eduplanapp/screens/student/settings/privacy_screen.dart';

class SettingsWidgetStudent extends StatelessWidget {
  const SettingsWidgetStudent({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      ListTile(
        title: Text(
          'Sign Out',
          style: contentTextStyle,
        ),
        onTap: () => context.read<StudentBloc>().add(LogOutEvent()),
      ),
      const Divider(),
     
      ListTile(
        title: Text(
          'Privacy Policy',
          style: contentTextStyle,
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ScreenPrivacyPolicyStudent(),
            )),
      ),
    ]);
  }
}
