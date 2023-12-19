import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/admin/admin_screen.dart';
import 'package:eduplanapp/screens/student/student_screen.dart';
import 'package:eduplanapp/screens/teacher/teacher_screen.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/signup_screen.dart';
import 'package:eduplanapp/screens/widgets/text_field_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';

final emailController = TextEditingController();
final passwordController = TextEditingController();

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key, required this.isTeacher});
  final bool isTeacher;

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
      body: BlocConsumer<WelcomeBloc, WelcomeState>(
        listenWhen: (previous, current) => current is WelcomeActionState,
        buildWhen: (previous, current) => current is! WelcomeActionState,
        listener: (context, state) {
          if (state is NavigateToSignUpState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      const ScreenSignUp(isUpdate: false, teacherData: null),
                ));
          } else if (state is TeacherSignInSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenTeacher(),
              ),
              (route) => false,
            );
          } else if (state is TeacherSignInLoadingState) {
            ScaffoldMessenger.of(context).showSnackBar(
              loadingSnakebarWidget(),
            );
            isLoading = true;
          } else if (state is TeacherSignInErrorState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Teacher not found', Colors.red);
            isLoading = false;
          } else if (state is StudentSignInSuccessState) {
            Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenStudent(),
              ),
              (route) => false,
            );
            isLoading = false;
          } else if (state is StudentSignInErrorState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Student not found', Colors.red);
          }
        },
        builder: (context, state) {
          return SafeArea(
            child: Form(
              key: formKey,
              child: ListView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                children: [
                  const SizedBox(
                    height: 40,
                  ),
                  Column(
                    children: [
                      Text(
                        'Welcome Back',
                        style: GoogleFonts.macondo(
                            fontSize: 20,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                            color: headingColor),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        'EDU PLAN',
                        style: GoogleFonts.macondo(
                            fontSize: 35,
                            letterSpacing: 3,
                            fontWeight: FontWeight.bold,
                            color: titleColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 200,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(18.0),
                    child: Container(
                      decoration: BoxDecoration(
                          color: loginTextfieldColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10))),
                      child: Padding(
                        padding: const EdgeInsets.all(18.0),
                        child: Column(
                          children: [
                            const Padding(
                              padding: EdgeInsets.only(bottom: 10),
                              child: Text('Sign In for continue',
                                  style: TextStyle(
                                      color: headingColor,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w300)),
                            ),
                            SignUpTextFieldWidget(
                                icon: const Icon(Icons.email),
                                fillColor: scaffoldColor,
                                hintText: 'Email',
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                length: null,
                                obscureText: false),
                            const SizedBox(
                              height: 20,
                            ),
                            SignUpTextFieldWidget(
                                icon: const Icon(Icons.lock),
                                fillColor: scaffoldColor,
                                hintText: 'Password',
                                controller: passwordController,
                                keyboardType: TextInputType.name,
                                length: null,
                                obscureText: true),
                            const SizedBox(
                              height: 20,
                            ),
                            ElevatedButton(
                              onPressed: () {
                                if (isLoading) {
                                  null;
                                } else {
                                  if (formKey.currentState!.validate()) {
                                    onSignIn(isTeacher, context);
                                  }
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: buttonColor,
                                  shape: const ContinuousRectangleBorder(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15)),
                                  ),
                                  fixedSize: const Size(150, 50),
                                  elevation: 10),
                              child: const Text(
                                'Sign In',
                                style: TextStyle(color: whiteTextColor),
                              ),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            isTeacher
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Don't have an account",
                                          style: GoogleFonts.aBeeZee(
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black)),
                                      TextButton(
                                        onPressed: () => context
                                            .read<WelcomeBloc>()
                                            .add(NavigateEvent()),
                                        child: Text('Sign Up',
                                            style: GoogleFonts.farro(
                                                fontSize: 13,
                                                fontWeight: FontWeight.w900,
                                                color: Colors.black)),
                                      ),
                                    ],
                                  )
                                : const Row(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

Future<void> onSignIn(bool isTeacher, BuildContext context) async {
  if (emailController.text == 'admin' && passwordController.text == 'eduplan') {
    Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const ScreenAdmin(),
        ));
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('admin_login', true);
    await sharedPrefs.setBool('user_login', true);
  } else {
    context.read<WelcomeBloc>().add(isTeacher
        ? TeacherSignInEvent(
            email: emailController.text, password: passwordController.text)
        : StudentSignInEvent(
            email: emailController.text, password: passwordController.text));
  }
  emailController.text = '';
  passwordController.text = '';
}
