import 'package:flutter/material.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/teacher_model/teacher.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';

import 'my_drawer.dart';

class TeachersStaff extends StatelessWidget {

  static final route = 'teacher_staff';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('teachers')) ,
        ),
        body:Container(
          child: teachersStaffFutureBuilder(),
          margin: EdgeInsets.all(Dimes.d_15),
        ),
      ),
    );
  }

  Widget teachersStaffFutureBuilder(){
    return FutureBuilder(
      future: ApiRepository.repository.getDataTeachersFromApi,
      builder: (BuildContext context , AsyncSnapshot<List<Teachers>> snapshot){
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
                return teachersGrid(snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget teachersGrid(List<Teachers> teachers){
      return GridView.count(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        crossAxisCount: 2 ,
        scrollDirection: Axis.vertical,
        crossAxisSpacing: Dimes.d_10,
        mainAxisSpacing: Dimes.d_10,
        children: List.generate(teachers.length , (index) =>
            Container(
              width: 200,
              color: Colors.blue[50],
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    height: 50, width: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(teachers[index].imageProfile),
                        fit: BoxFit.fill,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Text(teachers[index].name),
                ],
              ),
            ),
        ),
      );
  }
}