import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/requests/bloc/admin_request_bloc.dart';
import 'package:eduplanapp/screens/admin/widgets/teacher_profile_screen.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenAdminResquest extends StatelessWidget {
  const ScreenAdminResquest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Requests'),
      body: BlocConsumer<AdminRequestBloc, AdminRequestState>(
        listenWhen: (previous, current) => current is AdminRequestActionState,
        buildWhen: (previous, current) => current is! AdminRequestActionState,
        listener: (context, state) {
          if (state is ViewTeacherState) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ScreenTeacherProfileAdmin(
                    isRequest: true,
                    teacherId: null,
                    teacherData: state.teacherData,
                  ),
                ));
          } else if (state is AcceptRequestState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Successfully Registered Teacher', Colors.green);
          } else if (state is RejectRequestState) {
            AlertMessages().alertMessageSnakebar(
                context, 'Rejected and deleted data', Colors.red);
          }
        },
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
            stream: signUpRequest.getTeacherDatas(),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List teachersList = snapshot.data!.docs;
                if (teachersList.isNotEmpty) {
                  return SizedBox(
                    child: ListView.separated(
                        padding: const EdgeInsets.all(8),
                        itemBuilder: (context, index) {
                          DocumentSnapshot document = teachersList[index];
                          String docId = document.id;
                          Map<String, dynamic> data =
                              document.data() as Map<String, dynamic>;
                          String teacherName = data['name'];
                          return ExpansionTile(
                            collapsedBackgroundColor: appbarColor,
                            backgroundColor: appbarColor,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(16)),
                            title: Text(teacherName),
                            childrenPadding: const EdgeInsets.all(8),
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  OutlinedButton(
                                    onPressed: () => context
                                        .read<AdminRequestBloc>()
                                        .add(ViewTeacherEvent(
                                            teacherData: data)),
                                    style: ButtonStyle(
                                      side:
                                          MaterialStateProperty.all<BorderSide>(
                                        const BorderSide(
                                            width: 2.0, color: titleColor),
                                      ),
                                    ),
                                    child: const Text(
                                      'View Profile',
                                      style: TextStyle(color: titleColor),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<AdminRequestBloc>()
                                        .add(AcceptButtonEvent(id: docId)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.green)),
                                    child: const Text(
                                      'Accept',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  ElevatedButton(
                                    onPressed: () => context
                                        .read<AdminRequestBloc>()
                                        .add(RejectButtonEvent(id: docId)),
                                    style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStateProperty.all(
                                                Colors.red)),
                                    child: const Text(
                                      'Reject',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          );
                        },
                        separatorBuilder: (context, index) => const SizedBox(
                              height: 10,
                            ),
                        itemCount: teachersList.length),
                  );
                } else {
                  return const Center(child: Text('no request exist'));
                }
              } else {
                return const Center(child: Text('no request exist'));
              }
            },
          );
        },
      ),
    );
  }
}
