import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/login_screen.dart';

class ScreenFirst extends StatelessWidget {
  const ScreenFirst({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<WelcomeBloc, WelcomeState>(
      listener: (context, state) {
        if (state is TeacherLoginState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenLogin(isTeacher: state.isTeacher),
              ));
        } else if (state is StudentLoginState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenLogin(isTeacher: state.isTeacher),
              ));
        }
      },
      builder: (context, state) {
        return Scaffold(
            body: SafeArea(
                child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: size.width,
              height: 400,
              child: Image.asset('lib/assets/images/appIcon.png'),
            ),
            Text('Edu Plan',
                style: GoogleFonts.acme(
                    fontSize: 35,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
            const SizedBox(
              height: 40,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () => context
                        .read<WelcomeBloc>()
                        .add(TeacherLoginEvent(isTeacher: true)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: buttonColor,
                        shape: const ContinuousRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                        ),
                        fixedSize: Size(size.width * 0.90, 50),
                        elevation: 10),
                    child: const Text(
                      'Teacher',
                      style: TextStyle(color: Colors.white),
                    )),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                      onPressed: () => context
                          .read<WelcomeBloc>()
                          .add(StudentLoginEvent(isTeacher: false)),
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          fixedSize: Size(size.width * 0.90, 50),
                          elevation: 10),
                      child: const Text(
                        'Student',
                        style: TextStyle(color: Colors.white),
                      )),
                ],
              ),
            ),
          ],
        )));
      },
    );
  }
}
