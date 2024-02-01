import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:eduplanapp/screens/student/fee/payment_history_widget.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScreenFeeStudent extends StatefulWidget {
  const ScreenFeeStudent({super.key});

  @override
  State<ScreenFeeStudent> createState() => _ScreenFeeStudentState();
}

class _ScreenFeeStudentState extends State<ScreenFeeStudent> {
  Stream<QuerySnapshot<Object?>> feeStream = const Stream.empty();
  Stream<QuerySnapshot<Object?>> paymentStream = const Stream.empty();
  @override
  void initState() {
    super.initState();
    context.read<StudentBloc>().add(FetchPaymentDataEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Payment Details'),
      body: BlocConsumer<StudentBloc, StudentState>(
        listener: (context, state) {
          if (state is FetchPaymentDataLoadingState) {
            const CircularProgressIndicator();
          } else if (state is FetchPaymentDataSuccessState) {
            paymentStream = state.PaymentData;

            feeStream = state.feeData;
          } else if (state is FetchPaymentDataErrorState) {
            AlertMessages()
                .alertMessageSnakebar(context, 'Please try again', Colors.red);
          }
        },
        builder: (context, state) {
          return StreamBuilder<QuerySnapshot>(
              stream: feeStream,
              builder: (context, feeSnapshot) {
                if (feeSnapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      child: Center(child: CircularProgressIndicator()));
                } else if (feeSnapshot.hasError) {
                  return Text('Error: ${feeSnapshot.error}');
                } else if (feeSnapshot.hasData) {
                  List<DocumentSnapshot> feeDatas = feeSnapshot.data!.docs;
                  return SafeArea(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Card(
                            color: appbarColor,
                            child: SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2,
                                width: double.infinity,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Text(
                                        'Tution Fee Details',
                                        style: titleTextStyle,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Total Amount',
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' : ₹${feeDatas[0]['total_amount']}',
                                              style: contentTextStyle,
                                            ),
                                            kHeight,
                                            Text(
                                              ' : ₹${feeDatas[0]['amount_paid']}',
                                              style: contentTextStyle,
                                            ),
                                            kHeight,
                                            Text(
                                              ' : ₹${feeDatas[0]['amount_pending']}',
                                              style: contentTextStyle,
                                            ),
                                          ],
                                        )
                                      ],
                                    ),
                                  ],
                                )),
                          ),
                        ),
                        PaymentHistoryWidget(paymentStream: paymentStream),
                      ],
                    ),
                  );
                } else {
                  return SizedBox(
                    child: Center(
                      child: Text('Retry'),
                    ),
                  );
                }
              });
        },
      ),
    );
  }
}
