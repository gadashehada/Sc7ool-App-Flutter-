import 'package:flutter/material.dart';
import 'package:school_1/UI/lessons_ui.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/subject_model/subject.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';

class SubjectsUI extends StatefulWidget {

    static final route = 'subjects';
    int id;
    SubjectsUI({this.id});

  @override
  _SubjectsUIState createState() => _SubjectsUIState();
}

class _SubjectsUIState extends State<SubjectsUI> {

  Future<List<Subject>> tmp;

  @override
  void initState() {
    super.initState();

    tmp = ApiRepository.repository.getDataSubjectsFromApi(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    // int id = ModalRoute.of(context).settings.arguments;
    
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title : Text(ArStrings.get('subjects')) ,
        ),
        body:Container(
          margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.right_15),
          child: showSubjectsWithGridView(),
        ),
      ),
    );
  }

    Widget showSubjectsWithGridView(){
    return FutureBuilder(
      future: tmp,
      builder: (BuildContext context , AsyncSnapshot<List<Subject>> snapshot){
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

  Widget listUi(BuildContext context , List<Subject> subjects){
    return subjects.isEmpty? Center(child: Text(ArStrings.get('no_subject_to_class')),):
      ListView.builder(
        itemCount: subjects.length,
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
                  Text('${subjects[index].name}') ,
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
              Navigator.pushNamed(context, LessonsUI.route , arguments: [subjects[index].classesId , subjects[index].id]);
            },
          );
        });
  }
}