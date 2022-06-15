import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_1/UI/about_app.dart';
import 'package:school_1/UI/about_school.dart';
import 'package:school_1/UI/add_lesson.dart';
import 'package:school_1/UI/add_news.dart';
import 'package:school_1/UI/contact_us.dart';
import 'package:school_1/UI/home.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/UI/profile.dart';
import 'package:school_1/UI/teacher_lessons.dart';
import 'package:school_1/UI/teachers_staff.dart';
import 'package:school_1/api/models/user_model/user.dart';
import 'package:school_1/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyDrawer extends StatefulWidget {
  @override
  _MyDrawerState createState() => _MyDrawerState();
}

class _MyDrawerState extends State<MyDrawer> {

  User user;
  SharedPreferences preferances;

  getData() async {
    preferances = await SharedPreferences.getInstance();
    String userString = preferances.getString('user') ?? null;
    if(userString != null){
      Map userMap = jsonDecode(userString);
      setState(() {
        Login.user = User.fromJson(userMap);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    user = Login.user;
    return Drawer(
        child : ListView(
          children: <Widget>[
            InkWell(
              child: user == null ? UserAccountsDrawerHeader(
                currentAccountPicture: Theme.of(context).platform == TargetPlatform.android ?
                 Image.asset('assets/images/subtraction.png') : 
                 Image.asset('assets/images/subtraction_blue.png'),
                accountName: Text('project name'), 
                accountEmail: Text('project@gmail.com'),
                ) : UserAccountsDrawerHeader(
                currentAccountPicture: user.imageProfile == "http://test.hexacit.com/uploads/images/users/defualtUser.jpg" ?
                 Image.asset('assets/images/subtraction.png') :
                 Image.network(user.imageProfile),
                accountName: Text(user.name), 
                accountEmail: Text(user.email),
                ) 
                ,
              onTap: (){
                Navigator.popAndPushNamed(context, Profile.route);
              },
            ),
            ListTile(
              title : Text(ArStrings.get('home')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(Home.route, (route) => false);
              },
            ),
            ListTile(
              title : Text(ArStrings.get('about_school')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(AboutSchool.route, (route) => false);
              },
            ),
            ListTile(
              title : Text(ArStrings.get('teachers')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(TeachersStaff.route, (route) => false);
              },
            ),
            ListTile(
              title : Text(ArStrings.get('contact_us')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(ContactUs.route, (route) => false);
              },
            ),
            user != null && user.type == '2' ?ListTile(
              title : Text(ArStrings.get('add_news')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(AddNews.route, (route) => false);
              },
            ):SizedBox(),
            user != null && user.type != '0' ?ListTile(
              title : Text(ArStrings.get('add_lesson')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(AddLesson.route, (route) => false);
              },
            ):SizedBox(),
            user != null && user.type == '1' ?ListTile(
              title : Text(ArStrings.get('myLessons')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(TeacherLessons.route, (route) => false);
              },
            ):SizedBox(),
            user == null ?ListTile(
              title : Text(ArStrings.get('login')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(Login.route, (route) => false);
              },
            ):SizedBox(),
            ListTile(
              title : Text(ArStrings.get('about_app')),
              onTap: (){
                Navigator.of(context).pushNamedAndRemoveUntil(AboutApp.route, (route) => false);
              },
            ),
            user != null ?ListTile(
              title : Text(ArStrings.get('logout')),
              onTap: (){
                Login.user = null;
                preferances.remove('user');
                Navigator.of(context).pushNamedAndRemoveUntil(Home.route, (route) => false);
              },
            ):SizedBox(),
          ],
        ),
      );
  }
}