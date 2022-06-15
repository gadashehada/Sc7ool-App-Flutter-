import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/news_model/news.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'dart:io';
import 'my_drawer.dart';

class AddNews extends StatefulWidget {

  static final route = 'add_news';

  @override
  _AddNewsState createState() => _AddNewsState();
}

class _AddNewsState extends State<AddNews> {

  final formKey = GlobalKey<FormState>();
  File _image;
  final picker = ImagePicker();
  final globalKey = GlobalKey<ScaffoldState>();


  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController =  TextEditingController();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('no_image_selected'),)));
    }
  }

  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    try{
      String response = await ApiRepository.repository.addNewsToApiAsync(News(
        title: _titleController.text ,
        description: _descriptionController.text ,
        image: _image.path
      ));
      if(response != null)
        globalKey.currentState.showSnackBar(SnackBar(content: Text('$response',)));
    }catch(e){
      globalKey.currentState.showSnackBar(SnackBar(content:Text(ArStrings.get('error'),),));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('add_news')) ,
        ),
        body:SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: Dimes.d_40,),
                Image(image: AssetImage(ArStrings.get('logo_image')),),
                SizedBox(height: Dimes.d_20,),
                Text(ArStrings.get('project_name')),
                SizedBox(height: Dimes.d_15,),
                addNewsForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addNewsForm(BuildContext context){
    return Container(
      margin: EdgeInsets.all(Dimes.right_15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _titleController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('news_title') ,
                ),
                validator: (value){
                  if(value.isEmpty)
                    return ArStrings.get('title_empty');
                },
              ),
              SizedBox(height: Dimes.d_20,),
              Row(
                children: <Widget>[
                  Text(ArStrings.get('choose_image')),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: (){
                      getImage();
                    },
                  ),
                ],
              ),
              TextFormField(
                controller: _descriptionController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('news_description') ,
                ),
                validator: (value){
                  if(value.isEmpty)
                    return ArStrings.get('description_empty');
                },
              ),
              SizedBox(height: Dimes.d_40,),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(ArStrings.get('add_news') , style: TextStyle(color: Colors.white),),
                onPressed: (){
                  saveMyForm();
                }),
            ),
            SizedBox(height: Dimes.d_40,),
          ],
        ),
      ),
    );
  }
}