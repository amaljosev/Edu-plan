import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/admin/bloc/admin_bloc.dart';
import 'package:eduplanapp/screens/requests/bloc/admin_request_bloc.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); 
  await Firebase.initializeApp(); 
  runApp(const MyApp());
}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => WelcomeBloc(),
        ),
        BlocProvider(
          create: (context) => AdminBloc(),
        ),
        BlocProvider(
          create: (context) => AdminRequestBloc(),
        ),
        BlocProvider(
          create: (context) => TeacherBloc(),
        ),
        BlocProvider(
          create: (context) => TeacherSecondBloc(),
        ),
        BlocProvider(
          create: (context) => StudentBloc(),
        ),
      ],
      child: MaterialApp( 
        title: 'School App',
        theme: ThemeData(
          scaffoldBackgroundColor: scaffoldColor,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        debugShowCheckedModeBanner: false, 
        home: const ScreenSplash(), 
      ),
    );
  }
}
