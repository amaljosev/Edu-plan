import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/widgets/button_widget.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

final totalAmountController = TextEditingController();
final paidAmountController = TextEditingController();

class ScreenFeeUpdateTeacher extends StatefulWidget {
  const ScreenFeeUpdateTeacher(
      {super.key, required this.feeData, required this.studentId});
  final Map<String, dynamic> feeData;
  final String studentId;

  @override
  State<ScreenFeeUpdateTeacher> createState() => _ScreenFeeUpdateTeacherState();
}

int balanceAmount = 0;
String amountPaid = '';
String totalFee = '';

class _ScreenFeeUpdateTeacherState extends State<ScreenFeeUpdateTeacher> {
  @override
  void initState() {
    super.initState();
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
        return Scaffold(
          appBar: myAppbar('Update Student Fee Details'),
          body: Padding(
            padding: const EdgeInsets.all(18.0),
            child: ListView(
              children: [
                TextFormField(
                  decoration: const InputDecoration(labelText: 'Total Amount'),
                  controller: totalAmountController,
                  keyboardType: TextInputType.number,
                ),
                TextFormField(
                  decoration: const InputDecoration(labelText: 'New Payment'),
                  controller: paidAmountController,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                          onPressed: () => onReset(context, widget.studentId),
                          child: const Text(
                            'Reset Fee Details',
                            style: TextStyle(color: Colors.red),
                          )),
                      ButtonSubmissionWidget(
                        label: 'Update',
                        icon: Icons.save,
                        onTap: () => onUpdate(context, widget.studentId),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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
      context.read<TeacherBloc>().add(UpdateStudentFeeEvent(
          feeData: studentFeeObject, studentId: studentId)); 
      totalAmountController.text = '';
      paidAmountController.text = '';
    }else { 
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
