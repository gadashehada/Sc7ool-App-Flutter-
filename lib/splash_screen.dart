import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:school_1/values/dimes.dart';
import 'package:splashscreen/splashscreen.dart';
import 'UI/home.dart';

class MySplashScreen extends StatefulWidget {

  static final route = 'splash_screen';

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<MySplashScreen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue,
      body: SplashScreen(
        seconds: 3,
        navigateAfterSeconds: Home.route,
        title : Text('project name' , style:TextStyle(color: Colors.white , fontSize: 18 , fontWeight: FontWeight.w500)) ,
        image : Image.asset('assets/images/subtraction.png') ,
        backgroundColor:Colors.lightBlue,
        styleTextUnderTheLoader: TextStyle(),
        photoSize: Dimes.d_70,
        loaderColor: Colors.white,
      ),
    );
  }
}