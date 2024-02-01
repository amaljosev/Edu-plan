import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentHistoryWidget extends StatefulWidget {
  const PaymentHistoryWidget({
    super.key,
    required this.paymentStream,
  });

  final Stream<QuerySnapshot<Object?>> paymentStream;

  @override
  State<PaymentHistoryWidget> createState() => _PaymentHistoryWidgetState();
}

class _PaymentHistoryWidgetState extends State<PaymentHistoryWidget> {
  late Razorpay _razorpay;

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  @override
  void initState() {
    super.initState();
    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, handleExternalWallet);
  }

  String docId = '';
  String note = '';
  int amt = 0;
  bool isPayed = false;
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is PaymentSuccessState) {
          AlertMessages().alertMessageSnakebar(
              context,
              'Payment Successfull \nPayment Id : ${state.response.paymentId}',
              Colors.green);
          isPayed = true;
        } else if (state is PaymentErrorState) {
          AlertMessages().alertMessageSnakebar(context,
              'Payment Failed \nNote : ${state.response.message}', Colors.red);
        } else if (state is PaymentWalletState) {
          AlertMessages().alertMessageSnakebar(
              context,
              'External Wallet \nNote : ${state.response.walletName}',
              Colors.indigo);
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
            stream: widget.paymentStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> paymentDatas = snapshot.data!.docs;

                return Expanded(
                  child: ListView.separated(
                    padding: EdgeInsets.all(10),
                    separatorBuilder: (context, index) => kHeight,
                    itemBuilder: (context, index) {
                      DocumentSnapshot data = paymentDatas[index];
                      int amount = data['new-payment'];
                      amt = data['new-payment'];
                      note = data['note'];
                      docId = data.id;
                      return Card(
                        elevation: 8,
                        child: ListTile(
                          title: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'Fee Details',
                                style: listViewTextStyle,
                              ),
                              Text(
                                ' : ${data['note']}',
                                style: listViewTextStyle,
                              ),
                            ],
                          ),
                          subtitle: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                          trailing: ElevatedButton(
                            onPressed:
                                isPayed ? () {} : () => openCheckout(amount),
                            child: Text(
                              isPayed ? 'Paied' : 'Pay Now',
                              style: listViewTextStyle,
                            ),
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
                    child: Text('Retry please'),
                  ),
                );
              }
            });
      },
    );
  }

  void openCheckout(int amount) {
    amount = amount * 100;
    var options = {
      'key': 'rzp_test_1DP5mmOlF5G5ag',
      'amount': amount,
      'name': 'student',
      'prefil': {'contact': '1234567812', 'email': 'student@gmail.com'},
      'external': {
        'wallets': ['paytm']
      }
    };
    try {
      _razorpay.open(options);
    } catch (e) {
      debugPrint('Error : $e');
    }
  }

  void handlePaymentSuccess(PaymentSuccessResponse response) {
    context.read<StudentBloc>().add(RazorPaySuccessEvent(
        response: response, paymentId: docId, amount: amt, note: note));
  }

  void handlePaymentError(PaymentFailureResponse response) {
    context.read<StudentBloc>().add(RazorPayErrorEvent(response: response));
  }

  void handleExternalWallet(ExternalWalletResponse response) {
    context.read<StudentBloc>().add(RazorPayWalletEvent(response: response));
  }
}
