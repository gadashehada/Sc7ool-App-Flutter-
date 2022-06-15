import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:school_1/UI/my_drawer.dart';
import 'package:school_1/UI/news_details.dart';
import 'package:school_1/UI/subjects_ui.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/classes_models/classes_model.dart';
import 'package:school_1/api/models/news_model/news.dart';
import 'package:school_1/values/dimes.dart';
import '../values/strings.dart';

class Home extends StatelessWidget {

static final route = 'Home';

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('home')) ,
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[

              showNewsWithCarouselImage(),

              Container(
                child: Text('${ArStrings.get('classes')} :' , style: Theme.of(context).textTheme.headline,),
                margin: EdgeInsets.only(top:Dimes.d_20 , right: Dimes.right_15 , bottom: Dimes.d_5),) ,

              Container(
                child: showClassesWithGridView(),
                margin: EdgeInsets.all(Dimes.d_15),) ,

            ],
          ),
        ),
      ),
    );
  }

  Widget showNewsWithCarouselImage(){
    return FutureBuilder(
      future: ApiRepository.repository.getDataNewsFromApi,
      builder: (BuildContext context , AsyncSnapshot<List<News>> snapshot){
        switch(snapshot.connectionState){
          
          case ConnectionState.none:
            return circularIndicator(context , CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return circularIndicator(context , CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return circularIndicator(context , CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              return Container(child: circularIndicator(context ,Text(ArStrings.get('error')),));
            }else{
              return carouselImage(context , snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget circularIndicator(BuildContext context , Widget w){
    return Container(
      height: MediaQuery.of(context).size.height / 2.85,
      width: MediaQuery.of(context).size.width,
      child: Card(
        margin: EdgeInsets.only(top: Dimes.d_20 , right: Dimes.d_40 , left: Dimes.d_40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Center(child: w),
      ),
    );
  }

  Widget carouselImage(BuildContext context , List<News> news){
    return CarouselSlider.builder(
              itemCount: news.length, 
              options: CarouselOptions(
                height: MediaQuery.of(context).size.height / 2.85,
                initialPage: 0,
                autoPlay: true ,
                autoPlayInterval: Duration(seconds: 3), 
              ),
              itemBuilder: (BuildContext context , int index) =>
                InkWell( 
                    child:Card(
                    margin: EdgeInsets.only(top: Dimes.d_20 , right: Dimes.right_15 , left: Dimes.d_5),
                    clipBehavior: Clip.hardEdge,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Stack(
                      fit: StackFit.expand,
                      children: <Widget>[
                        news[index].image != 'http://test.hexacit.com/uploads/images/news'?
                        // Image.network(news[index].image , fit: BoxFit.fill,)
                        // : Center(child: Text('no image')),
                        CachedNetworkImage(
                          fit: BoxFit.fill,
                          placeholder: (index , url) =>Center(child: CircularProgressIndicator()),
                          imageUrl: news[index].image,
                          errorWidget: (context , url , error) =>Center(child: Text(ArStrings.get('no_image'))),
                        )
                        : Center(child: Text(ArStrings.get('no_image'))),
                        Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(top : Dimes.d_8 , right : Dimes.right_15),
                            height: 40,
                            color: Colors.black45,
                            child: Text(news[index].title , style: TextStyle(color: Colors.white)),
                          ),
                        ),
                      ],
                    ),
                  ),
                  onTap: (){
                    Navigator.pushNamed(context, NewsDetails.route , arguments: news[index]);
                  },
                ), 
      );
  }

  Widget classesGrid(BuildContext context , List<ClassesModel> classes){
    return GridView.count(
      shrinkWrap: true,
      physics: BouncingScrollPhysics(),
      crossAxisCount: 2 ,
      scrollDirection: Axis.vertical,
      crossAxisSpacing: Dimes.d_10,
      mainAxisSpacing: Dimes.d_10,
      children: List.generate(classes.length,(index) =>
        InkWell(
            child: Container(
            height: 80 ,
            color: Colors.blue[50],
            child: Stack(
              children: <Widget>[
                Positioned(
                  top: Dimes.d_15,
                  left: Dimes.d_15,
                  child: Icon(Icons.school , color: Colors.blue,size: 45,)),
                Positioned(
                  bottom:Dimes.d_50,
                  right: Dimes.right_15,
                  child: Text('${index+1}'),),
                Positioned(
                  bottom: Dimes.d_10,
                  right: Dimes.right_15,
                  child: Text('${classes[index].name}')),
              ],
            ),
          ),
          onTap: (){
            Navigator.pushNamed(context, SubjectsUI.route , arguments: classes[index].id);
          },
        )
      ),
    );
  }

  Widget showClassesWithGridView(){
    return FutureBuilder(
      future: ApiRepository.repository.getDataClassesFromApi,
      builder: (BuildContext context , AsyncSnapshot<List<ClassesModel>> snapshot){
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
              return classesGrid(context , snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }
}