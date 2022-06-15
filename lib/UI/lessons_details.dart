import 'package:flutter/material.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/UI/pdf_reader.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/lessons_model/comment_model/comment.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/api/models/lessons_model/lesson_details.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'package:transparent_image/transparent_image.dart';

class LessonsDetails extends StatelessWidget {

  static final route = 'lessons_details';
  int lessonId;
  final formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  TextEditingController _commentController = TextEditingController();

  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    String message =  await ApiRepository.repository.addCommentToApiAsync(Comments(
      comment: _commentController.text ,
      userId: Login.user.id ,
      lessonId: lessonId
    ));
    if(message!= null)
      globalKey.currentState.showSnackBar(SnackBar(content: Text('$message')));
  }

  @override
  Widget build(BuildContext context) {
    lessonId = ModalRoute.of(context).settings.arguments;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        key: globalKey,
        appBar: AppBar(
          title : Text(ArStrings.get('lessons')) ,
        ),
        body: showLessonsDetailsWithListView(lessonId),
      ),
    );
  }

 Widget showLessonsDetailsWithListView(int lessonId){
    return FutureBuilder(
      future: ApiRepository.repository.getDataLessonsDetailsFromApi(lessonId),
      builder: (BuildContext context , AsyncSnapshot<LessonDetails> snapshot){
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
                return screenContent(snapshot.data , context);
            }
            break;
        }
        return Container();
      },
    );
  } 

  Widget screenContent(LessonDetails lessonDetails , BuildContext context){
    Lesson lesson = lessonDetails.lesson;
    return SingleChildScrollView(
            child: Container(
            margin: EdgeInsets.only(top:Dimes.d_20 , right:Dimes.right_15 , left: Dimes.right_15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('${lesson.title}' , style: Theme.of(context).textTheme.title) ,
                SizedBox(height: Dimes.d_10,),
                Card(
                  clipBehavior: Clip.hardEdge,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: lesson.image == null || lesson.image == 'http://test.hexacit.com/uploads/images/lessons'?
                  Container():
                  Stack(
                    alignment: AlignmentDirectional.center,
                    children: <Widget>[
                      Center(child: CircularProgressIndicator(),) ,
                        FadeInImage.memoryNetwork(
                          width: MediaQuery.of(context).size.width /1.0,
                          height: MediaQuery.of(context).size.height / 3.0,
                          fit: BoxFit.fill ,
                          image:'${lesson.image}',
                          placeholder: kTransparentImage,
                        ),
                    ],
                  )
                ),
                SizedBox(height: Dimes.d_10,),
                Text(ArStrings.get('lesson_description') , style: Theme.of(context).textTheme.headline),
                SizedBox(height: Dimes.d_5,),
                Text('${lesson.detail}'),
                pdfListView(context , lessonDetails.attachments),
                SizedBox(height: Dimes.d_20,),
                Text(ArStrings.get('comments') , style: Theme.of(context).textTheme.headline),
                SizedBox(height: Dimes.d_5,),
                addCommentUI(),
                SizedBox(height: Dimes.d_20,),
                commentsListView(lessonDetails.comments),
              ],
            ),
          ),
        );
  }

  Widget pdfListView(BuildContext context , List<String> pdfs){
    return  Wrap(
      spacing: Dimes.d_5,
      children: List.generate(pdfs.length, (int index){
        return IconButton(
          iconSize: Dimes.d_35,
          icon: Icon(Icons.picture_as_pdf),
          onPressed: (){
            Navigator.pushNamed(context, PDFReader.route , arguments: pdfs[index]);
          },
        );
      }),
    );
  }

  Widget commentsListView(List<Comments> comments){
    return comments.length == 0? Text(ArStrings.get('no_comments')):
    ListView.builder(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      itemCount: comments.length ,
      itemBuilder: (context , index){
        return Container(
          margin: EdgeInsets.only(bottom:Dimes.d_15),
          child: Row(
            children: <Widget>[
              Container(
                height: Dimes.d_35, width: Dimes.d_35,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: comments[index].user.imageProfile  != 'http://test.hexacit.com/uploads/images/users/defualtUser.jpg'?
                    NetworkImage(comments[index].user.imageProfile) :
                    AssetImage(ArStrings.get('logo_image')),
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              SizedBox(width: Dimes.d_20,),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('${comments[index].user.name}') ,
                  SizedBox(height: Dimes.d_5,),
                  Text('${comments[index].comment}')
                ],
              ),
            ],
          ),
        );
      });
  }

  Widget addCommentUI(){
    return Login.user != null ?
    Form(
      key: formKey,
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextFormField(
              controller: _commentController,
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                hintText: ArStrings.get('add_comment'),
              ),
              validator: (value){
                if(value.isEmpty){
                  return ArStrings.get('add_comment');
                }
                return null;
              },
            ),
          ),
          SizedBox(width: Dimes.d_10,),
          InkWell(
            child: Container(
              alignment: Alignment.bottomCenter,
              height: Dimes.d_50,
              child: Text(ArStrings.get('send'),
              style: TextStyle(color: Colors.lightBlue),)),
            onTap: (){
              saveMyForm();
            },  
          )
        ],
      ),
    ) : Text(ArStrings.get('login_to_add_comment'));
  }
}