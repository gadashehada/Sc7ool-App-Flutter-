import 'package:flutter/cupertino.dart';
import 'package:school_1/UI/about_app.dart';
import 'package:school_1/UI/about_school.dart';
import 'package:school_1/UI/add_lesson.dart';
import 'package:school_1/UI/add_news.dart';
import 'package:school_1/UI/contact_us.dart';
import 'package:school_1/UI/lessons_details.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/UI/news_details.dart';
import 'package:school_1/UI/profile.dart';
import 'package:school_1/UI/sign_up.dart';
import 'package:school_1/UI/teacher_lessons.dart';
import 'package:school_1/UI/teachers_staff.dart';
import 'package:school_1/splash_screen.dart';
import '../UI/home.dart';

class Routes {
  static Map<String , WidgetBuilder> routes =
  {
    MySplashScreen.route : (context) => MySplashScreen() ,
    Home.route : (context) => Home() ,
    AboutSchool.route : (context) => AboutSchool() ,
    TeachersStaff.route : (context) => TeachersStaff() ,
    ContactUs.route : (context) => ContactUs() ,
    AboutApp.route : (context) => AboutApp() ,
    Login.route : (context) => Login() ,
    SignUp.route : (context) => SignUp() ,
    LessonsDetails.route : (context) => LessonsDetails() ,
    NewsDetails.route : (context) => NewsDetails() ,
    AddNews.route : (context) => AddNews() ,
    AddLesson.route : (context) => AddLesson() ,
    Profile.route : (context) => Profile() ,
    TeacherLessons.route : (context) => TeacherLessons()
  };
}