import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/profile/fee/fee_edit_screen.dart';
import 'package:eduplanapp/screens/teacher/profile/widgets/shimmerloading_student_fee.dart';

class StudentFeeDetailsWidget extends StatelessWidget {
  const StudentFeeDetailsWidget({
    Key? key,
    required this.isTeacher,
    required this.studentFee,
    required this.studentId,
  }) : super(key: key);
  final String studentId;
  final bool isTeacher;
  final CollectionReference<Map<String, dynamic>> studentFee;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listenWhen: (previous, current) => current is TeacherActionState,
      buildWhen: (previous, current) => current is! TeacherActionState,
      listener: (context, state) {
        if (state is UpdateFeeScreenState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenFeeUpdateTeacher(
                  isOfflinePaymet: state.isOfflinePaymet,
                  studentId: state.studentId,
                  feeData: state.feeData,
                ),
              ));
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: studentFee.snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return isTeacher
                  ? const SizedBox(
                      child: Center(child: CircularProgressIndicator()))
                  : const ShimmerLoadingForStudentFee();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              final feeData = snapshot.data!.docs.first.data();
              return Column(
                children: [
                  Container(
                    height: isTeacher
                        ? MediaQuery.of(context).orientation ==
                                Orientation.landscape
                            ? 0.9 * MediaQuery.of(context).size.height
                            : 0.5 * MediaQuery.of(context).size.height
                        : 0.24 * MediaQuery.of(context).size.height,
                    width: MediaQuery.of(context).orientation ==
                            Orientation.landscape
                        ? 0.5 * MediaQuery.of(context).size.width
                        : 0.4 * MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        color: isTeacher ? appbarColor : null,
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5))),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          Text(
                            'Fee Details',
                            style: titleTextStyle,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Total Fee',
                                      style: contentTextStyle,
                                    ),
                                    kHeight,
                                    Text(
                                      'Amount Paid',
                                      style: contentTextStyle,
                                    ),
                                    kHeight,
                                    Text(
                                      'Amount Pending',
                                      style: contentTextStyle,
                                    ),
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      ' : ₹${feeData['total_amount']}',
                                      style: contentTextStyle,
                                    ),
                                    kHeight,
                                    Text(
                                      ' : ₹${feeData['amount_paid']}',
                                      style: contentTextStyle,
                                    ),
                                    kHeight,
                                    Text(
                                      ' : ₹${feeData['amount_pending']}',
                                      style: contentTextStyle,
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                          ElevatedButton.icon(
                              onPressed: () => context.read<TeacherBloc>().add(
                                  UpdateFeeScreenEvent(
                                      isOfflinePaymet: false,
                                      feeData: feeData,
                                      studentId: studentId)),
                              style: ElevatedButton.styleFrom(),
                              icon: Icon(Icons.payment), 
                              label: Text('Create new Payment')),
                          ElevatedButton.icon(
                              onPressed: () => context.read<TeacherBloc>().add(
                                  UpdateFeeScreenEvent(
                                      isOfflinePaymet: true,
                                      feeData: feeData,
                                      studentId: studentId)),
                              icon: Icon(Icons.update),
                              label: Text('Update Payments')), 
                        ],
                      ),
                    ),
                  ),
                ],
              );
            } else {
              return const SizedBox(
                child: Center(child: Text('Something went wrong')),
              );
            }
          },
        );
      },
    );
  }
}
