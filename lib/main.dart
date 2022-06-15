import 'package:flutter/material.dart';
import 'package:school_1/UI/edit_lesson.dart';
import 'package:school_1/UI/lessons_ui.dart';
import 'package:school_1/UI/pdf_reader.dart';
import 'package:school_1/UI/subjects_ui.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/splash_screen.dart';
import 'package:school_1/values/routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: MySplashScreen.route ,
      onGenerateRoute: (settings){
        if(settings.name == PDFReader.route){
          String url = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => PDFReader(url: url),
          );
        }else if(settings.name == EditLesson.route){
          Lesson lesson = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => EditLesson(lesson: lesson,),
          );
        }else if(settings.name == SubjectsUI.route){
          int id = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => SubjectsUI(id: id,),
          );
        }else if(settings.name == LessonsUI.route){
          List arg = settings.arguments;
          return MaterialPageRoute(
            builder: (context) => LessonsUI(classId: arg[0],subjectId: arg[1],),
          );
        }
      },
      routes: Routes.routes ,
      debugShowCheckedModeBanner: false,
      title: "School App",
      theme: ThemeData(
        iconTheme: IconThemeData(color: Colors.lightBlue),
        fontFamily: 'sans' ,
        textTheme: TextTheme(
          headline: TextStyle(color: Colors.lightBlue , fontSize: 18 , fontWeight: FontWeight.w500),
          body1: TextStyle(color: Colors.black , fontSize: 14 , fontWeight: FontWeight.normal),
          title: TextStyle(color: Colors.black , fontSize : 16 , fontWeight: FontWeight.bold),
          button : TextStyle(color: Colors.white , fontSize : 14 , fontWeight: FontWeight.normal),
        ),
      ),
    );
  }
}
