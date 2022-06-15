import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/user_model/user.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'home.dart';
import 'login.dart';

class SignUp extends StatelessWidget {

  static final route = 'sign_up';
  final formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();

  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  SharedPreferences preferences;
  String _name , _email , _mobile , _pass;
  setEmail(String email){
    this._email = email;
  }
  setPassword(String pass){
    this._pass = pass;
  }
  setMobile(String mobile){
    this._mobile = mobile;
  }
  setName(String name){
    this._name = name;
  }

  saveMyForm(BuildContext context) async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    try{
      Map<String , dynamic> userAndMsg =  await ApiRepository.repository.createAccountFromApi(
        User(email: _email , pass: _pass , mobile: _mobile , name: _name , isAddUser: true));

      if(userAndMsg['user'] != null){
        myDialog(context , userAndMsg['user']);
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

  myDialog(BuildContext context , User user){
    return showDialog(
      barrierDismissible: false,
      context: context ,
      builder: (BuildContext context){
        return Directionality(
          textDirection: TextDirection.rtl,
          child : AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(Dimes.d_10),
            ),
            title: Text(ArStrings.get('login')),
            content: Text(ArStrings.get('create_account_success')),
            actions: <Widget>[
              FlatButton(
                child: Text(ArStrings.get('login')),
                onPressed: (){
                  Login.user = user ;
                  saveData(user);
                  Navigator.pushReplacementNamed(context, Home.route);
                },
              ),
              FlatButton(
                child: Text(ArStrings.get('no')),
                onPressed: (){
                  Navigator.pop(context);
                },
              ),
          ],
        ));
      }  
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title : Text(ArStrings.get('create_account')) ,
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
                signUpForm(context),
                Text(ArStrings.get('have_account')) ,
                Text(ArStrings.get('login')),
                SizedBox(height: Dimes.d_20,),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget signUpForm(BuildContext context){
    return Container(
      margin: EdgeInsets.all(Dimes.right_15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('name') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('name_empty');
                  }
                },
                onSaved: (newValue){
                  setName(newValue);
                },
              ),
              SizedBox(height: Dimes.d_10,),
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
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('phone') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('phone_empty');
                  }
                },
                onSaved: (newValue){
                  setMobile(newValue);
                },
              ),
              SizedBox(height: Dimes.d_10,),
              TextFormField(
                controller: _passController,
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
              SizedBox(height: Dimes.d_10,),
              TextFormField(
                controller: _confirmPassController,
                keyboardType: TextInputType.visiblePassword,
                obscureText: true,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('confirm_password') ,
                ),
                validator: (value){
                  if(value.isEmpty){
                    return ArStrings.get('confirm_pass_empty');
                  }else if(value != _passController.text){
                    return 'not equal password';
                  }
                },
                onSaved: (newValue){},
              ),
              SizedBox(height: Dimes.d_40,),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(ArStrings.get('create_account') , style: TextStyle(color: Colors.white),),
                onPressed: (){
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