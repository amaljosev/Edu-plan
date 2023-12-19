import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/widgets/dropdown_widget.dart';
import 'package:eduplanapp/screens/welcome/widgets/title_widget.dart';
import 'package:eduplanapp/screens/widgets/text_field_widget.dart';

final nameController = TextEditingController();
final emailController = TextEditingController();
final contactController = TextEditingController();
final passwordController = TextEditingController();
final divisionController = TextEditingController();
String? value;
int index = 0;

class ScreenSignUp extends StatefulWidget {
  const ScreenSignUp(
      {super.key, required this.isUpdate, required this.teacherData});
  final bool isUpdate;
  final TeacherModel? teacherData;
  @override
  State<ScreenSignUp> createState() => _ScreenSignUpState();
}

class _ScreenSignUpState extends State<ScreenSignUp> {
  @override
  void initState() {
    super.initState();
    if (widget.isUpdate && widget.teacherData != null) {
      nameController.text = widget.teacherData!.name;
      emailController.text = widget.teacherData!.email;
      contactController.text = widget.teacherData!.contact.toString();
      passwordController.text = widget.teacherData!.password;
      divisionController.text = widget.teacherData!.division;
      value = widget.teacherData!.className;
    } else {
      nameController.text = "";
      emailController.text = "";
      contactController.text = "";
      passwordController.text = "";
      divisionController.text = "";
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isLoading = false;
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: BlocConsumer<WelcomeBloc, WelcomeState>(
            listenWhen: (previous, current) => current is WelcomeActionState,
            buildWhen: (previous, current) => current is! WelcomeActionState,
            listener: (context, state) {
              if (state is SignUpLoadingState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  loadingSnakebarWidget(),
                );
                isLoading = true;
              } else if (state is SignUpSuccessState) {
                AlertMessages().alertMessageSnakebar(
                    context,
                    'Successfully Registered, Please wait for conform',
                    Colors.green);
                isLoading = false;
                Navigator.pop(context);
              } else if (state is SignUpClassErrorState) {
                AlertMessages().alertMessageSnakebar(context,
                    'Enterd Class or Email already Registered', Colors.red);
                isLoading = false;
              } else if (state is SignUpErrorState) {
                AlertMessages().alertMessageSnakebar(
                    context, 'Not registerd Please contact admin', Colors.red);
                isLoading = false;
              } else if (state is DropdownMenuTapState) {
                value = state.dropdownValue;
                index = state.index;
              }
              if (state is TeacherUpdatedLoadingState) {
                ScaffoldMessenger.of(context).showSnackBar(
                  loadingSnakebarWidget(),
                );
                isLoading = true;
              } else if (state is TeacherUpdatedSuccessState) {
                AlertMessages().alertMessageSnakebar(
                    context, 'Successfully Updated', Colors.green);
                isLoading = false;
                Navigator.pop(context);
              } else if (state is TeacherUpdatedClassExistState) {
                AlertMessages().alertMessageSnakebar(
                    context, 'Class already exist', Colors.red);
                isLoading = false;
                Navigator.pop(context);
              }
            },
            builder: (context, state) {
              return SafeArea(
                  child: Form(
                key: formKey,
                child: ListView(
                  padding: const EdgeInsets.all(18),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  children: [
                    TitleCardWidget(isUpdate: widget.isUpdate),
                    SignUpTextFieldWidget(
                      icon: const Icon(Icons.person),
                      fillColor: loginTextfieldColor, 
                      hintText: 'Teacher Name',
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      length: null,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SignUpTextFieldWidget(
                      icon: const Icon(Icons.email),
                      fillColor: loginTextfieldColor,
                      hintText: 'Email',
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      length: null,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    SignUpTextFieldWidget(
                      icon: const Icon(Icons.phone),
                      fillColor: loginTextfieldColor,
                      hintText: 'Contact Number',
                      controller: contactController,
                      keyboardType: TextInputType.phone,
                      length: 10,
                      obscureText: false,
                    ),
                    SignUpTextFieldWidget(
                      icon: const Icon(Icons.lock_outline_rounded),
                      fillColor: loginTextfieldColor,
                      hintText: 'Password',
                      obscureText: widget.isUpdate ? false : true,
                      controller: passwordController,
                      keyboardType: TextInputType.emailAddress,
                      length: null,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    DropDownWidget(index: index),
                    const SizedBox(
                      height: 15,
                    ),
                    SignUpTextFieldWidget(
                      icon: const Icon(Icons.diversity_1),
                      fillColor: loginTextfieldColor,
                      hintText: 'Division',
                      controller: divisionController,
                      keyboardType: TextInputType.name,
                      length: 1,
                      obscureText: false,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (isLoading) {
                          null;
                        } else {
                          if (formKey.currentState!.validate()) {
                            if (!isValidEmail(emailController.text)) {
                              AlertMessages().alertMessageSnakebar(
                                  context,
                                  'Please check your email is correct', 
                                  Colors.red);    
                              return;
                            }
                            if (contactController.text.length < 10) {
                              AlertMessages().alertMessageSnakebar(
                                  context,
                                  'Enter minimum 10 numbers in contact',
                                  Colors.red);
                              return;
                            }
                            if (passwordController.text.length < 8) {
                              AlertMessages().alertMessageSnakebar(
                                  context,
                                  'Enter minimum 8 charecters in password',
                                  Colors.red);
                              return;
                            }
                            if (!RegExp(r'^[a-zA-Z]+$')
                                .hasMatch(divisionController.text)) {
                              AlertMessages().alertMessageSnakebar(
                                  context,
                                  'Division can only contain letters',
                                  Colors.red);
                              return;
                            } else {
                              onSignUp(context, widget.isUpdate);
                            }
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          backgroundColor: buttonColor,
                          shape: const ContinuousRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                          ),
                          fixedSize: const Size(150, 50),
                          elevation: 10),
                      child: Text(
                        widget.isUpdate ? 'Update' : 'Sign Up',
                        style: const TextStyle(color: whiteTextColor),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    widget.isUpdate
                        ? const SizedBox()
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Already have an account',
                                  style: GoogleFonts.aBeeZee(
                                      fontSize: 12,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black)),
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Sign In',
                                    style: GoogleFonts.farro(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w900,
                                        color: Colors.black)),
                              ),
                            ],
                          ),
                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ));
            }));
  }
}

onSignUp(BuildContext context, bool isUpdate) async {
  final teacherObject = TeacherModel(
      name: nameController.text.trim(),
      className: value as String,
      email: emailController.text.trim(),
      contact: int.parse(contactController.text.trim()),
      password: passwordController.text.trim().toString(),
      division: divisionController.text.toUpperCase());
  isUpdate
      ? context.read<WelcomeBloc>().add(
            UpdateButtonEvent(teacherData: teacherObject),
          )
      : context.read<WelcomeBloc>().add(
            SignUpButtonEvent(teacherData: teacherObject),
          );

  nameController.text = "";
  emailController.text = "";
  contactController.text = "";
  passwordController.text = "";
  divisionController.text = "";
}

bool isValidEmail(String email) {
  RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}
