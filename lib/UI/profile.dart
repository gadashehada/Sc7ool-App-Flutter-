import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/user_model/user.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'dart:io';

class Profile extends StatefulWidget {

  static final route = 'profile';

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {

  final formKey = GlobalKey<FormState>();
  User user ;
  File _image;
  final picker = ImagePicker();
  final globalKey = GlobalKey<ScaffoldState>();

  TextEditingController _nameController;
  TextEditingController _emailController;
  TextEditingController _mobileController;

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        ApiRepository.repository.editProfileImageFromApi(_image).then((message){
        globalKey.currentState.showSnackBar(SnackBar(content: Text('$message!!',)));
        });
      } else {
        globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('no_image_selected'),)));
      }
    });
  }

  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    try{
      Map<String , dynamic> response = await ApiRepository.repository.editProfileFromApi(User(email: _emailController.text , name: _nameController.text , mobile: _mobileController.text));
      if(response['user'] != null)
        Login.user = response['user'];
      globalKey.currentState.showSnackBar(SnackBar(content: Text('${response['message']}!!',)));
    }catch(e){
      globalKey.currentState.showSnackBar(SnackBar(content:Text(ArStrings.get('error'),),));
    }
  }

  @override
  void initState() {
    super.initState();

    user = Login.user;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _mobileController = TextEditingController(text: user.mobile);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title : Text(ArStrings.get('profile')) ,
        ),
        body:SingleChildScrollView(
          child: Center(
            child: Column(
              children: <Widget>[
                SizedBox(height: Dimes.d_40,),
                InkWell(
                  onTap: (){
                    getImage();
                  },
                  child: Container(
                      height: 100, width: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: _image == null?
                          user.imageProfile != 'http://test.hexacit.com/uploads/images/users/defualtUser.jpg'?
                          NetworkImage(user.imageProfile) : AssetImage(ArStrings.get('logo_image')) : FileImage(_image),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                ),
                SizedBox(height: Dimes.d_20,),
                profileForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget profileForm(BuildContext context){
    return Container(
      margin: EdgeInsets.all(Dimes.right_15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('name') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('name_empty');
                  }
                }
              ),
              SizedBox(height: Dimes.d_10,),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('email') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('email_empty');
                  }
                },
              ),
              SizedBox(height: Dimes.d_10,),
              TextFormField(
                controller: _mobileController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('phone') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('phone_empty');
                  }
                }
              ),
              SizedBox(height: Dimes.d_40,),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(ArStrings.get('update') , style: TextStyle(color: Colors.white),),
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