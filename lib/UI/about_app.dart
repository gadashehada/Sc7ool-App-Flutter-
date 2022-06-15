import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/setting_model/setting.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'package:url_launcher/url_launcher.dart';
import 'my_drawer.dart';

class AboutApp extends StatelessWidget {

  static final route = 'about_app';
  final formKey = GlobalKey<FormState>();
  final globalkey = GlobalKey<ScaffoldState>();

  _launchURL(String url) async {
    if(await canLaunch(url)){
      await launch(url);
    }else{
      throw ArStrings.get('error_launch');
    }
  }

  _launchSocial(String url , String fallbackUrl) async {
    try{
      bool launched = await launch(url , forceSafariVC: false , forceWebView: false);
      if(!launched){
        await launch(fallbackUrl , forceSafariVC: false , forceWebView: false);await launch(fallbackUrl , forceSafariVC: false , forceWebView: false);
      }
    }catch(e){
      await launch(fallbackUrl , forceSafariVC: false , forceWebView: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalkey,
        drawer: MyDrawer(),
        appBar: AppBar(
          title : Text(ArStrings.get('about_app')) ,
        ),
        body: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top:Dimes.d_5 , right:Dimes.right_15),
                margin: EdgeInsets.only(top:Dimes.d_20,),
                width: MediaQuery.of(context).size.width,
                height: 40,
                color: Colors.blue[50],
                child: Text('${ArStrings.get('contact_info')} :'),
              ),
              contactInfoFutureBuilder(),
            ],
          ),
        ),
      ),
    );
  }

  Widget contactInfoFutureBuilder(){
    return FutureBuilder(
      future: ApiRepository.repository.getDataSettingsFromApi,
      builder: (BuildContext context , AsyncSnapshot<AppSettings> snapshot){
        switch(snapshot.connectionState){
          
          case ConnectionState.none:
            return Center(heightFactor: 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.waiting:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.active:
            return Center(heightFactor : 4 ,child: CircularProgressIndicator());
            break;
          case ConnectionState.done:
            if(snapshot.hasError){
              return Center(heightFactor : 4 ,child: Text(ArStrings.get('error')));
            }else{
              return contactUsInfoUi(context , snapshot.data);
            }
            break;
        }
        return Container();
      },
    );
  }

  Widget contactUsInfoUi(BuildContext context , AppSettings appSettings){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        FlatButton.icon(
          onPressed: (){
            try{
              _launchURL('mailto:${appSettings.infoEmail}');
            }catch(error){
              globalkey.currentState.showSnackBar(SnackBar(content: Text('$error'),));
            }
          }, 
          icon: Icon(Icons.email , color: Colors.lightBlue,), 
          label: Text(appSettings.infoEmail),
        ),
        FlatButton.icon(
          onPressed: (){
            try{
              _launchURL('tel:${appSettings.phone}');
            }catch(error){
              globalkey.currentState.showSnackBar(SnackBar(content: Text('$error'),));
            }
          }, 
          icon: Icon(Icons.call , color: Colors.lightBlue), 
          label: Text(appSettings.phone),
        ),
        Row(
          children: <Widget>[
            FlatButton.icon(
              onPressed: (){
                try{
                  _launchURL('tel:${appSettings.mobile}');
                }catch(error){
                  globalkey.currentState.showSnackBar(SnackBar(content: Text('$error'),));
                }
              }, 
              icon: Icon(Icons.phone_android , color: Colors.lightBlue), 
              label: Text(appSettings.mobile),
            ),
            Expanded(
              child: SizedBox(),
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.facebook),
              onPressed: (){
                _launchSocial('' , appSettings.facebook);
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.instagram),
              onPressed: (){
                _launchSocial('' , appSettings.instagram);
              },
            ),
            IconButton(
              icon: FaIcon(FontAwesomeIcons.twitter),
              onPressed: (){
                _launchSocial('' , appSettings.twitter);
              },
            ),
          ],
        ),
      ],
    );
  }
}