import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:watchmovie/constant/Constantcolors.dart';
import 'package:watchmovie/ui/control_screen.dart';
import 'package:watchmovie/ui/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  ConstantColors constantColors=ConstantColors();
  @override
  void initState() {
    Timer(const Duration(seconds: 3), ()=>Navigator.pushReplacement(context, PageTransition(child:  const ControllScreen(), type: PageTransitionType.leftToRight)));
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D1D28),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(child: Image.asset('images/logo.png'),),
          RichText(
              text: const TextSpan(
                  text: 'Watch',
                  style: TextStyle(
                    fontFamily: 'muli',
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 25,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: 'Movie',
                      style: TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 25,
                      ),
                    )
                  ])),
        ],
      ),

    );
  }
}
