import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/first_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? isCheckedPrivacy = false;

class ScreenFirstPrivacy extends StatelessWidget {
  const ScreenFirstPrivacy({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WelcomeBloc, WelcomeState>(
      listener: (context, state) {
        if (state is PrivacyCheckState) {
          isCheckedPrivacy = state.isChecked;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: appbarColor,
                      borderRadius: BorderRadius.all(Radius.circular(10))),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Privacy Policy for EDU PLAN Mobile App',
                              style: TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right:10.0), 
                              child: Text(
                                'Effective Date: 18-12-2023',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '1. About App:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                            '''This app is designed exclusively for school use and is not intended for general users. Only those with authorized access can log in to the app. If someone downloads the app and signs up, their data will be temporarily stored in the database, but it will be removed permanently by the admin. Initially, the data is stored, but only the school admin has the ability to view and control it. For inquiries or to connect with the school admin, please refer to the contact information provided below.''',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 8.0),
                        Text(
                          '2. Information We Collect:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '2.1 Teachers Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            '''The app only collects the teacher's name, email, password, and contact number during the sign-up process. However, this information is treated as a request, and it is not stored permanently in the database if the individual is not a teacher at that particular school. The data is sent to the admin as a request, and if the admin verifies that the individual is a teacher and accepts the request, only then is the data stored in the database. Otherwise, if the admin rejects the request, the data will be cleared.''',
                            textAlign: TextAlign.justify),
                        Text(
                          '2.2 Students Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            '''Students or any other users do not directly provide any details to the app; they can only log in if they are a student. Personal details and credit information for students are already provided to the school administration, and they have the authority to use this data. The administration, in turn, is responsible for providing the data to teachers. Teachers are tasked with creating accounts for students and generating passwords. As a result, students or any other users cannot log in without the corresponding email and password. Students directly provide their email to teachers, ensuring that teachers are aware of the student and that the school possesses their data. Teachers are responsible for creating and distributing passwords to students to prevent unauthorized access to the app.''',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 8.0),
                        Text(
                          '2.3 School Administration Data:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The app does not collect data related to the school administration, such as the name and contact details of the school principal or head of the school. They only have control over the app, and it is intended solely for educational purposes.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 16.0),
                        Text(
                          '3. Data Control:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '3.1 School Admin Control:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The collected data is under the control of the school administrator, who is typically the principal or head of the school. The administrator has exclusive access to and control over user data.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 8.0),
                        Text(
                          '3.2 Developer Access:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The Developer, FlutterVerseOfficial, does not have access to the user data collected by the App. All data is solely controlled and managed by the school administrator.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 16.0),
                        Text(
                          '4. Data Usage:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '4.1 Educational Purpose:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The collected data is used for educational purposes within the school environment. This includes facilitating communication between teachers and students, managing academic activities, and other educational functionalities.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 8.0),
                        Text(
                          '4.2 No Data Sharing:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The App does not share user data with any external third parties, including the Developer. The data is strictly controlled within the school environment.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 16.0),
                        Text(
                          '5. Data Security:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '5.1 Encryption:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                            'The App employs industry-standard encryption protocols to secure user data during transmission and storage.',
                            textAlign: TextAlign.justify),
                        SizedBox(height: 16.0),
                        Text(
                          '6. Contact Information:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '6.1 Contacting the Admin:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'For any questions or concerns regarding privacy, you can contact School Admin at : amaljvattakkunnel@gmail.com.',
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          '6.2 Contacting the Developer:',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'For any questions or concerns regarding privacy, you can contact FlutterVerseOfficial at :  flutterverseofficial@gmail.com.',
                        ),
                        SizedBox(height: 16.0),
                        Text(
                          '7. Consent:',
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'By using the EDU PLAN App, you consent to the terms outlined in this Privacy Policy.',
                        ),
                        SizedBox(height: 8.0),
                        Row(
                          children: [
                            Checkbox(
                              value: isCheckedPrivacy,
                              onChanged: (value) => context
                                  .read<WelcomeBloc>()
                                  .add(PrivacyCheckEvent(isChecked: value)),
                            ),
                            Text('Accept and continue'),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                                onPressed: () => exit(0),
                                child: Text('Discard')),
                            TextButton(
                                onPressed: () => isCheckedPrivacy == true
                                    ? navigate(context)
                                    : null,
                                child: Text(
                                  'Continue',
                                  style: TextStyle(
                                      color: isCheckedPrivacy == true
                                          ? null
                                          : Colors.grey),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  navigate(BuildContext context) async {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => ScreenFirst(),
        ));
    final sharedPrefs = await SharedPreferences.getInstance();
    await sharedPrefs.setBool('privacy_policy', true);
  }
}
