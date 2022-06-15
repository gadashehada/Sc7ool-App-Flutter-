import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:school_1/UI/home.dart';
import 'package:school_1/UI/sign_up.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/user_model/user.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_drawer.dart';

class Login extends StatelessWidget {

  static final route = 'login';
  SharedPreferences preferences;
  static User user;
  final formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  String _email , _pass ;
  setEmail(String email){
    this._email = email;
  }
  setPassword(String pass){
    this._pass = pass;
  }

  saveMyForm(BuildContext context) async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    try{
      Map<String , dynamic> userAndMsg =  await ApiRepository.repository.loginFromApi(_email, _pass);
      if(userAndMsg['user'] != null){
        user = userAndMsg['user'];
        user.setIsPreferances(true);
        saveData(user);
        Navigator.pushReplacementNamed(context, Home.route);
      }else{
        globalKey.currentState.showSnackBar(SnackBar(content: Text(userAndMsg['message'],)));
      }
    }catch(e){
      globalKey.currentState.showSnackBar(SnackBar(content:Text(ArStrings.get('error'),),));
    }
  }

  saveData(User user) async {
    preferences = await SharedPreferences.getInstance();
    // print(jsonEncode(user));
    preferences.setString('user', jsonEncode(user));
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('login')) ,
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
                loginForm(context),
                Text(ArStrings.get('havnt_account')) ,
                InkWell(
                  child: Text(ArStrings.get('create_account'),),
                  onTap: (){
                    Navigator.pushNamed(context, SignUp.route);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget loginForm(BuildContext context){
    return Container(
      margin: EdgeInsets.all(Dimes.right_15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('email') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('email_empty');
                  }else if(!RegExp('[A-Za-z0-9._%-]+@[A-Za-z0-9._%-]+\.[A-Za-z]{2,4}').hasMatch(value)){
                    return ArStrings.get('right_email');
                  }
                },
                onSaved: (newValue){
                  setEmail(newValue);
                },
              ),
              SizedBox(height: Dimes.d_10,),
              TextFormField(
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('password') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('pass_empty');
                  }
                },
                onSaved: (newValue){
                  setPassword(newValue);
                },
              ),
              SizedBox(height: Dimes.d_40,),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(ArStrings.get('login') , style: TextStyle(color: Colors.white),),
                onPressed: () {
                    saveMyForm(context);
                }),
            ),
            SizedBox(height: Dimes.d_40,),
          ],
        ),
      ),
    );
  }
}