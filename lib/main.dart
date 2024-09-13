import 'package:fall_detection_web_admin/src/deletepatient.dart';
import 'package:fall_detection_web_admin/src/loginpage.dart';
import 'package:fall_detection_web_admin/src/page1.dart';
import 'package:fall_detection_web_admin/src/page2.dart';
import 'package:fall_detection_web_admin/src/page4.dart';
import 'package:fall_detection_web_admin/src/page5.dart';
import 'package:fall_detection_web_admin/src/page6.dart';
import 'package:fall_detection_web_admin/src/signuppage.dart';
import 'package:fall_detection_web_admin/src/notification.dart';
import 'package:fall_detection_web_admin/src/deleteUserAccount.dart';
import 'package:fall_detection_web_admin/src/registrationExistingUser.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'NotoSansJP',
      ),
      home: const LoginPage(),
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/signup':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const SignUpPage(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/page1':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Page1(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/page2':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Page2(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/page4':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Page4(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/registrationExistingUser':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Registrationexistinguser(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/page5':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Page5(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/deleteUserAccount':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const deleteUserAccount(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/deletepatient':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const DeletePatient(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/page6':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Page6(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          case '/notification':
            return PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) =>
                  const Noti(),
              transitionsBuilder:
                  (context, animation, secondaryAnimation, child) {
                return FadeThroughTransition(
                  animation: animation,
                  secondaryAnimation: secondaryAnimation,
                  child: child,
                );
              },
            );
          default:
            return null;
        }
      },
    );
  }
}

class FadeThroughTransition extends StatelessWidget {
  final Animation<double> animation;
  final Animation<double> secondaryAnimation;
  final Widget child;

  const FadeThroughTransition({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: animation,
      child: child,
    );
  }
}

