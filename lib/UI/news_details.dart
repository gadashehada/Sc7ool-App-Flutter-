import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:school_1/api/models/news_model/news.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';

class NewsDetails extends StatelessWidget {

  static final route = 'news_details';

  @override
  Widget build(BuildContext context) {
    News news = ModalRoute.of(context).settings.arguments;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title : Text(ArStrings.get('news')) ,
        ),
        body:SingleChildScrollView(
            child: Container(
            margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.right_15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${news.title}' , style: Theme.of(context).textTheme.title) ,
                SizedBox(height: Dimes.d_10,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:news.image != 'http://test.hexacit.com/uploads/images/news'?
                    CachedNetworkImage(
                      width: MediaQuery.of(context).size.width /1.0,
                      height: MediaQuery.of(context).size.height / 3.0,
                      fit: BoxFit.fill,
                      placeholder: (index , url) =>Center(child: CircularProgressIndicator()),
                      imageUrl: news.image,
                      errorWidget: (context , url , error) =>Container(),
                    )
                    : Container(),
                ),
                SizedBox(height: Dimes.d_10,),
                Text('${news.description}'),
                SizedBox(height: Dimes.d_5,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}