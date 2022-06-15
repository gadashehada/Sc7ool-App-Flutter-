import 'package:flutter/material.dart';
import 'package:school_1/UI/lessons_details.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';

class LessonsUI extends StatefulWidget {

  static final route = 'lessons';
  int classId , subjectId ;
  LessonsUI({this.classId , this.subjectId});

  @override
  _LessonsUIState createState() => _LessonsUIState();
}

class _LessonsUIState extends State<LessonsUI> {

  Future<List<Lesson>> tmp;

  @override
  void initState() {
    super.initState();
    tmp = ApiRepository.repository.getDataLessonsFromApi(widget.classId, widget.subjectId);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title : Text(ArStrings.get('lessons')) ,
        ),
        body:Container(
          margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.right_15),
          child: showLessonsWithListView(),
        ),
      ),
    );
  }

  Widget showLessonsWithListView(){
    return FutureBuilder(
      future: tmp,
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
    return lessons.isEmpty? Center(child: Text(ArStrings.get('no_subject_to_class')),):
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
                Container(
                  height: Dimes.d_60,
                  width: Dimes.d_70,
                  color: Colors.blue,
                  child: Center(child: Text(lessons[index].kind.type , style: TextStyle(color: Colors.white),),),
                ),
                SizedBox(width: Dimes.d_10,),
                Text(lessons[index].title) ,
              ],
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, LessonsDetails.route , arguments:lessons[index].id );
          },
        );
      }
      );
  }
}