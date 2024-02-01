import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/new_payment_model.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/loading_snakebar.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:intl/intl.dart';

final totalAmountController = TextEditingController();
final paidAmountController = TextEditingController();
final feeNoteController = TextEditingController();

class ScreenFeeUpdateTeacher extends StatefulWidget {
  const ScreenFeeUpdateTeacher(
      {super.key,
      required this.feeData,
      required this.studentId,
      required this.isOfflinePaymet});
  final Map<String, dynamic> feeData;
  final String studentId;
  final bool isOfflinePaymet;

  @override
  State<ScreenFeeUpdateTeacher> createState() => _ScreenFeeUpdateTeacherState();
}

int balanceAmount = 0;
String amountPaid = '';
String totalFee = '';

class _ScreenFeeUpdateTeacherState extends State<ScreenFeeUpdateTeacher> {
  final Payment_Form_Key = GlobalKey<FormState>();
  Stream<QuerySnapshot<Object?>> paymentStream = const Stream.empty();
  Stream<QuerySnapshot<Object?>> offlineStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    context.read<TeacherSecondBloc>().add(widget.isOfflinePaymet
        ? FetchOfflineFeeEvent(studentId: widget.studentId)
        : FetchNewPaymentDataEvent(studentId: widget.studentId));
    totalFee = widget.feeData['total_amount'].toString();
    amountPaid = widget.feeData['amount_paid'].toString();
    balanceAmount = widget.feeData['amount_pending'];
    totalAmountController.text = totalFee;
    paidAmountController.text = '';
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is UpdateStudentFeeState) {
          context.read<TeacherBloc>().add(FetchStudentDatasEvent());
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
          listener: (context, state) {
            if (state is FetchNewPaymentDataSuccessState) {
              paymentStream = state.paymentData;
            }
            if (state is PaymentAddedLoadingState) {
              ScaffoldMessenger.of(context).showSnackBar(
                loadingSnakebarWidget(),
              );
            }
            if (state is PaymentAddedSuccessState) {
              AlertMessages().alertMessageSnakebar(
                  context, 'Added Successfully', Colors.green);
              feeNoteController.text = '';
              Navigator.pop(context);
            } else if (state is PaymentAddedErrorState) {
              AlertMessages()
                  .alertMessageSnakebar(context, 'Try Again', Colors.red);
            }
            if (state is FetchOfflineFeeSuccessState) {
              offlineStream = state.OfflineFeeData;
            }
          },
          builder: (context, state) {
            return Scaffold(
              appBar: myAppbar(widget.isOfflinePaymet
                  ? 'Offline Payments'
                  : 'Online Payments'),
              body: Form(
                key: Payment_Form_Key,
                child: ListView(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * 0.5,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            widget.isOfflinePaymet
                                ? TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Total Tution Fee'),
                                    controller: totalAmountController,
                                    keyboardType: TextInputType.number,
                                    validator: (value) =>
                                        totalAmountController.text.isEmpty
                                            ? 'Please enter Total Amount'
                                            : null,
                                  )
                                : Row(),
                            kHeight,
                            widget.isOfflinePaymet
                                ? Text('Total Paid amount : $amountPaid')
                                : Row(),
                            kHeight,
                            widget.isOfflinePaymet
                                ? Text('Pending Amount : $balanceAmount')
                                : Row(),
                            TextFormField(
                              decoration: const InputDecoration(
                                  labelText: 'New Payment'),
                              controller: paidAmountController,
                              keyboardType: TextInputType.number,
                              validator: (value) =>
                                  paidAmountController.text.isEmpty
                                      ? 'Please enter the Amount'
                                      : null,
                            ),
                            widget.isOfflinePaymet
                                ? Row()
                                : TextFormField(
                                    decoration: const InputDecoration(
                                        labelText: 'Purpose'),
                                    controller: feeNoteController,
                                    validator: (value) =>
                                        feeNoteController.text.isEmpty
                                            ? 'Please enter the purpose'
                                            : null,
                                  ),
                            const SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                widget.isOfflinePaymet
                                    ? Row()
                                    : ElevatedButton.icon(
                                        onPressed: () {
                                          if (Payment_Form_Key.currentState!
                                              .validate()) {
                                            addNewPayment(
                                                context, widget.studentId);
                                          }
                                        },
                                        icon: Icon(Icons.warning),
                                        label: Text('Add New Payment')),
                                widget.isOfflinePaymet
                                    ? ElevatedButton.icon(
                                        onPressed: () {
                                          if (Payment_Form_Key.currentState!
                                              .validate()) {
                                            onUpdate(context, widget.studentId);
                                          }
                                        },
                                        icon: Icon(Icons.save),
                                        label: Text('Save Offline Payment'))
                                    : Row(),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    StreamBuilder<QuerySnapshot>(
                        stream: widget.isOfflinePaymet
                            ? offlineStream
                            : paymentStream,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                                child:
                                    Center(child: CircularProgressIndicator()));
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else if (snapshot.hasData) {
                            List<DocumentSnapshot> paymentDatas =
                                snapshot.data!.docs;
                            return SizedBox(
                              height: MediaQuery.of(context).size.height * 0.4,
                              child: ListView.separated(
                                padding: EdgeInsets.all(10),
                                separatorBuilder: (context, index) => kHeight,
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = paymentDatas[index];
                                  bool isPayed = false;
                                  String formattedDate = '';
                                  if (!widget.isOfflinePaymet) {
                                    isPayed = data['isPayed'];
                                    final timestamp = data['date'];
                                    DateTime date = timestamp.toDate();
                                    formattedDate =
                                        DateFormat('dd MM yyy').format(date);
                                  }

                                  return Card(
                                    child: ListTile(
                                      title: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            widget.isOfflinePaymet
                                                ? 'Date'
                                                : 'Fee Details',
                                            style: listViewTextStyle,
                                          ),
                                          Text(
                                            widget.isOfflinePaymet
                                                ? ' : $formattedDate'
                                                : ' : ${data['note']}',
                                            style: listViewTextStyle,
                                          ),
                                        ],
                                      ),
                                      subtitle: Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Amount',
                                                style: listViewTextStyle,
                                              ),
                                              Text(
                                                ' : ${data['new-payment']}',
                                                style: listViewTextStyle,
                                              ),
                                            ],
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: [
                                              Text(
                                                'Date',
                                                style: listViewTextStyle,
                                              ),
                                              Text(
                                                ' : $formattedDate',
                                                style: listViewTextStyle,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                      trailing: Text(
                                        widget.isOfflinePaymet
                                            ? ''
                                            : isPayed
                                                ? 'Payed'
                                                : 'Not Payed',
                                        style: TextStyle(
                                            color: isPayed
                                                ? Colors.green
                                                : Colors.red),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: paymentDatas.length,
                              ),
                            );
                          } else {
                            return SizedBox(
                              child: Center(
                                child: Text(
                                    'Please check your internet connection'),
                              ),
                            );
                          }
                        })
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  void addNewPayment(BuildContext context, String studentId) {
    final String note = feeNoteController.text;
    final int newPayment = int.parse(paidAmountController.text);

    final payData =
        NewPaymentModel(newPayment: newPayment, note: note, isPayed: false);
    context.read<TeacherSecondBloc>().add(AddANewPaymentEvent(
        paymentModel: payData, studentId: widget.studentId));
  }
}

void onUpdate(BuildContext context, String studentId) {
  paidAmountController.text == ''
      ? paidAmountController.text = '0'
      : paidAmountController.text;
  int total = int.parse(totalAmountController.text);
  int newPayment = int.parse(paidAmountController.text);
  int oldPaid = int.parse(amountPaid);
  if (newPayment < total && total > oldPaid) {
    int totalPaid = oldPaid + newPayment;
    balanceAmount = total - totalPaid;

    if (totalPaid <= total) {
      final studentFeeObject = FeeModel(
          totalAmount: total,
          amountPayed: totalPaid,
          amountPending: balanceAmount);
      context.read<TeacherSecondBloc>().add(
          OfflineFeeEvent(studentId: studentId, amount: newPayment.toString()));
      context.read<TeacherBloc>().add(UpdateStudentFeeEvent(
          feeData: studentFeeObject, studentId: studentId));
      totalAmountController.text = '';
      paidAmountController.text = '';
    } else {
      AlertMessages().alertMessageSnakebar(
          context, 'Amount is larger than Total Amount', Colors.red);
    }
  } else {
    AlertMessages().alertMessageSnakebar(
        context, 'Amount is larger than Total Amount', Colors.red);
  }
}

void onReset(BuildContext context, String studentId) {
  final studentFeeObject =
      FeeModel(totalAmount: 0, amountPayed: 0, amountPending: 0);
  context.read<TeacherBloc>().add(
      UpdateStudentFeeEvent(feeData: studentFeeObject, studentId: studentId));
}
