import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/functions.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/student/settings/privacy_screen.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/welcome/signup_screen.dart';

class TeacherProfileWidget extends StatefulWidget {
  const TeacherProfileWidget({super.key, required this.size});
  final Size size;

  @override
  State<TeacherProfileWidget> createState() => _TeacherPrfileWidgetState();
}

class _TeacherPrfileWidgetState extends State<TeacherProfileWidget> {
  late Stream<DocumentSnapshot<Object?>> teacherDatas = const Stream.empty();

  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(FetchTeacherDatasEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listenWhen: (previous, current) => current is TeacherActionState,
      buildWhen: (previous, current) => current is! TeacherActionState,
      listener: (context, state) {
        if (state is FetchTeacherDataState) {
          teacherDatas = state.teacherDatas ?? const Stream.empty();
          context
              .read<TeacherBloc>()
              .add(BottomNavigationEvent(currentPageIndex: 0));
        }
      },
      builder: (context, state) {
        return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
          listener: (context, state) {
            if (state is LogoutState) {
              teacherLogOut(context);
            }
            if (state is EditTeacherSuccessState) {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenSignUp(
                        isUpdate: true, teacherData: state.teacherData),
                  ));
            }
          },
          builder: (context, state) {
            return StreamBuilder<DocumentSnapshot>(
                stream: teacherDatas,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData) {
                    Map<String, dynamic>? data =
                        snapshot.data!.data() as Map<String, dynamic>?;
                    return Column(
                      children: [
                        Container(
                          height: 130,
                          decoration: BoxDecoration(color: appbarColor),
                          child: Row(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: CircleAvatar(
                                  backgroundColor: headingColor,
                                  radius: 60,
                                  child: CircleAvatar(
                                    radius: 55,
                                    backgroundImage: AssetImage(
                                        'lib/assets/images/teacher.jpg'),
                                  ),
                                ),
                              ),
                              Flexible(
                                child: Text(
                                    '${data!["name"]}'.toString().toUpperCase(),
                                    overflow: TextOverflow.ellipsis,
                                    style: GoogleFonts.teko(
                                        fontSize: 30,
                                        fontWeight: FontWeight.bold,
                                        color: headingColor)),
                              )
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: widget.size.width,
                            height: 100,
                            decoration: BoxDecoration(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(5)),
                                color: appbarColor),
                            child: Padding(
                              padding: const EdgeInsets.all(7.0),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Class Teacher of",
                                          style: contentTextStyle),
                                      Text('Mobile No',
                                          style: contentTextStyle),
                                      Text('Email', style: contentTextStyle),
                                    ],
                                  ),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                                " : ${data["class"]}-${data["division"]}",
                                                overflow: TextOverflow.ellipsis,
                                                style: contentTextStyle),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 8.0),
                                              child: GestureDetector(
                                                onTap: () {
                                                  final teacherData =
                                                      TeacherModel(
                                                          name: data["name"],
                                                          className:
                                                              data["class"],
                                                          email: data["email"],
                                                          contact:
                                                              data["contact"],
                                                          password:
                                                              data["password"],
                                                          division:
                                                              data["division"]);
                                                  context
                                                      .read<TeacherSecondBloc>() 
                                                      .add(EditTeacherEvent(
                                                          teacherData:
                                                              teacherData));
                                                },
                                                  child:
                                                      const Icon(Icons.edit)),
                                            )
                                          ],
                                        ),
                                        Text(' : ${data["contact"]}',
                                            overflow: TextOverflow.ellipsis,
                                            style: contentTextStyle),
                                        Text(' : ${data["email"]}',
                                            overflow: TextOverflow.ellipsis,
                                            style: contentTextStyle),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                        
                        ListTile(
                          title: Text(
                            'Privacy Policy',
                            style: contentTextStyle,
                          ),
                          onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const ScreenPrivacyPolicyStudent(),
                              )),
                        ),
                        ListTile(
                          title: Text(
                            'Sign Out',
                            style: contentTextStyle,
                          ),
                          onTap: () => context
                              .read<TeacherSecondBloc>()
                              .add(LogoutEvent()),
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox(
                      child: Text('Error'),
                    );
                  }
                });
          },
        );
      },
    );
  }
}
