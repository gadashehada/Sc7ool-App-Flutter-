import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:school_1/UI/my_drawer.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/values/dimes.dart';

import '../values/strings.dart';

class AboutSchool extends StatelessWidget {

  static final route = 'about_school' ;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(title : Text(ArStrings.get('about_school'))),
        drawer: MyDrawer(),
        body: aboutSchoolFutureBuilder(),
      ),
    );
  }

  Widget aboutSchoolFutureBuilder(){
    return FutureBuilder(
      future: ApiRepository.repository.getDataPagesFromApi,
      builder: (BuildContext context , AsyncSnapshot<Map<String , dynamic>> snapshot){
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
                return aboutSchoolContent(snapshot.data['image'] , snapshot.data['description']);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget aboutSchoolContent(String image , String description){
    return Column(
          children: <Widget>[
            Image(
              height: 150,
              fit: BoxFit.fill,
              image : NetworkImage(image),
            ),
            Container(
              margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.d_5),
              child: Html(data: description),
            ),
          ],
        );
  }
}