import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:huwamaruwa/screen/ad_shearch_screen.dart';
import 'package:huwamaruwa/screen/add_new_post_screen.dart';
import 'package:huwamaruwa/screen/add_new_post_screen2.dart';
import 'package:huwamaruwa/screen/add_new_post_screen3.dart';
import 'package:huwamaruwa/screen/complain_screen.dart';
import 'package:huwamaruwa/screen/description_screen.dart';
import 'package:huwamaruwa/screen/forgotPassword.dart';
import 'package:huwamaruwa/screen/login_screen.dart';
import 'package:huwamaruwa/screen/menu_screen.dart';
import 'package:huwamaruwa/screen/profile_screen.dart';
import 'package:huwamaruwa/screen/request_book_screen.dart';
import 'package:huwamaruwa/screen/seller_profile_screen.dart';
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
            initialRoute: "/login",
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
              GetPage(
                name: '/SellerProfile',
                page: () => SellerProfileScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/add_new_screen',
                page: () => AddNewScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/add_new_screen2',
                page: () => AddNewScreen2(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/add_new_screen3',
                page: () => AddNewScreen3(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/des',
                page: () => Description(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/complain_screen',
                page: () => ComplainScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/request_screen',
                page: () => RequestScreen(),
                transition: Transition.native,
                transitionDuration: Duration(milliseconds: 1000),
              ),
              GetPage(
                name: '/ad_search_screen',
                page: () => AdSearchScreen(),
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