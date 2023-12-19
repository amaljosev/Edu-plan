import 'package:flutter/material.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenPrivacyPolicyStudent extends StatelessWidget {
  const ScreenPrivacyPolicyStudent({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Privacy Policy'),
      body: const Padding(
        padding: EdgeInsets.all(16.0),
        child: SingleChildScrollView(
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
              Text(
                'Effective Date: 18-12-2023',
                style: TextStyle(
                  color: Colors.grey, 
                ),
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
                '''This is not an app for common users. This is only for a school not for everyone so If you don’t have access you cant login the app. So if anyone downloads the app and signs up the data not stored on the database permanently it will be removed by the admin but it stores first but the data can view and control the school admin only. If you want to connect the school admin it's given below the contact section.''',
              ),
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
                '''The app only collects the teacher's name, email, password and contact number on sign up, it's just a request but the data is not stored permanently on the database if you are not a teacher in that school. The data goes as a request to the admin and if the admin verifies this is a teacher and accepts the request then only the data stored on the database else admin rejects the request means the data will clear.''',
              ),
              Text(
                '2.2 Students Data:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                '''Students or any other users are not providing any details directly to the app,they can only login if you are a student. Students personal details and credit details are already then given to the school administration and they have the authority to use the data. The authority is giving the data to teachers. They create the accounts for students and the password also ,so students or any other user can't login without the email and password. Students give email directly to teachers so they know the teacher and the school have their data. Teachers create and give the password to students so others can't use the app.''',
              ),
              SizedBox(height: 8.0),
              Text(
                '2.3 School Administration Data:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The App does not collect data related to the school administration, such as the name and contact details of the school principal or head of the school.They have only the control of the app. This is only for educational purposes.',
              ),
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
              ),
              SizedBox(height: 8.0),
              Text(
                '3.2 Developer Access:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The Developer, FlutterVerseOfficial, does not have access to the user data collected by the App. All data is solely controlled and managed by the school administrator.',
              ),
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
              ),
              SizedBox(height: 8.0),
              Text(
                '4.2 No Data Sharing:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'The App does not share user data with any external third parties, including the Developer. The data is strictly controlled within the school environment.',
              ),
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
              ),
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
                'For any questions or concerns regarding privacy, you can contact School Admin at amaljvattakkunnel@gmail.com.',
              ),
              SizedBox(height: 8.0),
              Text(
                '6.2 Contacting the Developer:',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                'For any questions or concerns regarding privacy, you can contact FlutterVerseOfficial at flutterverseofficial@gmail.com.',
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
            ],
          ),
        ),
      ),
    );
  }
}
