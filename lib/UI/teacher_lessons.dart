import 'package:flutter/material.dart';
import 'package:school_1/UI/edit_lesson.dart';
import 'package:school_1/UI/my_drawer.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/api/models/subject_model/subject.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';

class TeacherLessons extends StatelessWidget {

  static final route = 'teacher_lessons';

  @override
  Widget build(BuildContext context) {    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('lessons')) ,
        ),
        body:Container(
          margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.right_15),
          child: showlessonsWithListView(),
        ),
      ),
    );
  }

    Widget showlessonsWithListView(){
    return FutureBuilder(
      future: ApiRepository.repository.getTeacherLessonsFromApi ,
      builder: (BuildContext context , AsyncSnapshot<List<Lesson>> snapshot){
        switch(snapshot.connectionState){
          
          case ConnectionState.none:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              return Center(heightFactor : 4 ,child: Text(ArStrings.get('error')));
            }else{
                return listUi(context , snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget listUi(BuildContext context , List<Lesson> lessons){
    return lessons.isEmpty? Center(child: Text('لا يوجد مواد  '),):
      ListView.builder(
        itemCount: lessons.length,
        itemBuilder: (context , index){
          return InkWell(
              child: Container(
              margin: EdgeInsets.only(bottom:Dimes.d_10),
              color: Colors.blue[50],
              height: Dimes.d_60,
              width: MediaQuery.of(context).size.width,
              child: Row(
                children: <Widget>[
                  SizedBox(width: Dimes.d_10,),
                  CircleAvatar(
                    backgroundColor: Colors.blue,
                    child: Text('${index+1}' , style: TextStyle(color: Colors.white),),
                  ),
                  SizedBox(width: Dimes.d_10,),
                  Text('${lessons[index].title}') ,
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    icon: Icon(Icons.keyboard_arrow_left),
                    onPressed: (){},
                  ),
                ],
              ),
            ),
            onTap: (){
              Navigator.pushNamed(context, EditLesson.route , arguments: lessons[index]);
            },
          );
        });
  }
}