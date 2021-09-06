import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huwamaruwa/screen/forgotPassword.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/screen/menu_screen.dart';
import 'package:huwamaruwa/screen/profile_screen.dart';
import 'package:huwamaruwa/screen/signup.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runZonedGuarded(() {
      runApp(
          GetMaterialApp(
            debugShowCheckedModeBanner: false,
            initialRoute: "/home_screen",
            getPages: [
              GetPage(
                name: '/login',
                page: () => LoginScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/home_screen',
                page: () => HomeScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/forgot-password',
                page: () => ForgotPassword(),
               transition: Transition.native,
               transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/signup',
                page: () => SignUp(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/Profile',
                page: () => ProfileScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
            ],
          )
      );
    }, (error, stackTrace) {

    });
  });
}