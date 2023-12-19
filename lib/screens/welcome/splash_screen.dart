// ignore_for_file: use_build_context_synchronously
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/screens/admin/admin_screen.dart';
import 'package:eduplanapp/screens/student/student_screen.dart';
import 'package:eduplanapp/screens/teacher/teacher_screen.dart';
import 'package:eduplanapp/screens/welcome/bloc/welcome_bloc.dart';
import 'package:eduplanapp/screens/welcome/first_screen.dart';
import 'package:eduplanapp/screens/welcome/privacy_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:video_player/video_player.dart';

class ScreenSplash extends StatefulWidget {
  const ScreenSplash({super.key});

  @override
  State<ScreenSplash> createState() => _ScreenSplashState();
}

class _ScreenSplashState extends State<ScreenSplash> {
  late VideoPlayerController videoController;
  @override
  void initState() {
    videoController =
        VideoPlayerController.asset('lib/assets/videos/splash-light.mp4')
          ..initialize().then((_) {
            context.read<WelcomeBloc>().add(SplashEvent());
          })
          ..setVolume(0);
    playVideo();
    super.initState();
  }

  @override
  void dispose() {
    videoController.dispose();
    super.dispose();
  }

  Future<void> playVideo() async {
    await videoController.play();
    await Future.delayed(const Duration(seconds: 4)).then(
        (value) => context.read<WelcomeBloc>().add(SplashCompleteEvent()));
    checkUserSignedUp();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<WelcomeBloc, WelcomeState>(
      listenWhen: (previous, current) => current is WelcomeActionState,
      buildWhen: (previous, current) => current is! WelcomeActionState,
      listener: (context, state) {
        if (state is NewUserState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScreenFirst()),
          );
        } else if (state is ToHomeState) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const ScreenFirst()),
          );
        }
      },
      builder: (context, state) {
        if (state is SplashState) {
          return Scaffold(
              backgroundColor: Colors.white,
              body: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  videoController.value.isInitialized
                      ? AspectRatio(
                          aspectRatio: videoController.value.aspectRatio,
                          child: VideoPlayer(videoController),
                        )
                      : Container(),
                  Text('Edu Plan',
                      style: GoogleFonts.acme(
                          fontSize: 35,
                          fontWeight: FontWeight.bold,
                          color: Colors.black))
                ],
              ));
        } else {
          return const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }

  Future<void> checkUserSignedUp() async {
    final sharedPrefsForLogin = await SharedPreferences.getInstance();
    final userSignedUp = sharedPrefsForLogin.getBool('user_login');
    final sharedPrefsIsTeacher = await SharedPreferences.getInstance();
    final isTeacher = sharedPrefsIsTeacher.getBool('is_teacher');
    final sharedPrefsAdmin = await SharedPreferences.getInstance();
    final isAdmin = sharedPrefsAdmin.getBool('admin_login');
    final privacy = sharedPrefsAdmin.getBool('privacy_policy');
    log('$userSignedUp');
    log('$isTeacher');
    log('$isTeacher');
    if (userSignedUp == null || userSignedUp == false) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) {
          if (privacy == null || privacy == false) {
            return const ScreenFirstPrivacy();
          } else {
            return const ScreenFirst();
          }
        }),
      );
    } else {
      if (isAdmin != null && isAdmin) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenAdmin()),
        );
      } else if (isTeacher != null && isTeacher) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenTeacher()),
        );
      } else if (isTeacher == false) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const ScreenStudent()),
        );
      } else {
        Navigator.pushReplacement( 
          context,
          MaterialPageRoute(builder: (context) {
            if (privacy == null || privacy == false) {
              return const ScreenFirstPrivacy();
            } else {
              return const ScreenFirst();
            }
          }),
        );
      }
    }
  }
}
