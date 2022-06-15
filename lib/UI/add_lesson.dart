import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/api/api_repository.dart';
import 'package:school_1/api/models/classes_models/classes_model.dart';
import 'package:school_1/api/models/lessons_model/kind.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/api/models/lessons_model/lesson_details.dart';
import 'package:school_1/api/models/subject_model/subject.dart';
import 'package:school_1/api/models/teacher_model/teacher.dart';
import 'package:school_1/values/dimes.dart';
import 'package:school_1/values/strings.dart';
import 'my_drawer.dart';

class AddLesson extends StatefulWidget {

    static final route = 'add_lesson';

  @override
  _AddLessonState createState() => _AddLessonState();
}

class _AddLessonState extends State<AddLesson> {

  final formKey = GlobalKey<FormState>();
  final globalKey = GlobalKey<ScaffoldState>();
  File _image;
  final picker = ImagePicker();
  List<String> filesPath;
  List<Kind> kinds;
  List<ClassesModel> classes;
  List<Subject> subjects;
  List<Teachers> teachers;
  Kind selectedKinds;
  ClassesModel selectedClass;
  Teachers selectedTeacher ;
  Subject selectedSubject;
  TextEditingController _controllerTitle , _controllerDesc;
  bool classIsChanged = false;

  @override
  void initState() {
    super.initState();

    _controllerTitle = TextEditingController();
    _controllerDesc = TextEditingController();

    classes = List();
    subjects = List();
    kinds = List();
    teachers = List();
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      _image = File(pickedFile.path);
    } else {
      globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('no_image_selected'),)));
    }
  }

  Future getFilePdf() async {
    FilePickerResult result = await FilePicker.platform.pickFiles(allowMultiple: true , allowedExtensions: ['pdf'] , type: FileType.custom);
    if(result != null){
      filesPath = result.paths.map((path) => path).toList();
    }else{
      globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('no_file_selected'),)));
    }
  }

  saveMyForm() async {
    if(!formKey.currentState.validate()){return;}
    formKey.currentState.save();
    if(selectedClass == null)
      return globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('choose_class'),)));
    else if(selectedSubject == null)
      return globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('choose_subject'),)));
    else if(selectedKinds == null)
      return globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('choose_kind'),)));
    else if(Login.user.type == '2' && selectedTeacher.id == null)
      return globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('choose_teacher'),)));
    else if(_image == null)
      return globalKey.currentState.showSnackBar(SnackBar(content: Text(ArStrings.get('no_image_selected'),)));
    
    try{
      String response = await ApiRepository.repository.addLessonsToApi(LessonDetails(
        lesson: Lesson(
          userId: Login.user.type == '2'?selectedTeacher.id : Login.user.id ,
          classesId: selectedClass.id ,
          subjectsId: selectedSubject.id ,
          kindId: selectedKinds.id ,
          image: _image.path ,
          title: _controllerTitle.text ,
          detail: _controllerDesc.text
        ),
        attachments: filesPath
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
          title : Text(ArStrings.get('add_lesson')) ,
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
                addLessonForm(context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget addLessonForm(BuildContext context){
    return Container(
      margin: EdgeInsets.all(Dimes.right_15),
      child: Form(
        key: formKey,
        child: Column(
          children: <Widget>[
            getClasses(),
            SizedBox(height: Dimes.d_20,),
            selectedClass != null ? getSubjects(selectedClass.id) : SizedBox(),
            SizedBox(height: Dimes.d_20,),
            TextFormField(
              controller: _controllerTitle,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('lesson_title') ,
                ),
                validator: (value){
                  if(value.isEmpty)
                    return ArStrings.get('title_empty');
                },
              ),
              SizedBox(height: Dimes.d_20,),
              Row(
                children: <Widget>[
                  SizedBox(width: Dimes.d_10,),
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
              SizedBox(height: Dimes.d_5,),
              TextFormField(
                controller: _controllerDesc,
                keyboardType: TextInputType.text,
                decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(right: Dimes.d_10),
                  hintText: ArStrings.get('lesson_description') ,
                ),
                validator: (value){
                  if(value.isEmpty)
                    return ArStrings.get('description_empty');
                },
              ),
              SizedBox(height: Dimes.d_20,),
              Row(
                children: <Widget>[
                  SizedBox(width:Dimes.d_10),
                  Text(ArStrings.get('choose_pdf')),
                  Expanded(
                    child: SizedBox(),
                  ),
                  IconButton(
                    icon: Icon(Icons.picture_as_pdf),
                    onPressed: (){
                      getFilePdf();
                    },
                  ),
                ],
              ),
              SizedBox(height: Dimes.d_15,),
              getKinds(),
              SizedBox(height: Dimes.d_20,),
              Login.user.type == '2'? getTeachers() : SizedBox(),
              SizedBox(height: Dimes.d_40,),
              Container(
              height: 50,
              width: MediaQuery.of(context).size.width,
              child: RaisedButton(
                color: Colors.blue,
                child: Text(ArStrings.get('add_lesson') , style: TextStyle(color: Colors.white),),
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

  getClasses(){
    return FutureBuilder(
              future: ApiRepository.repository.getDataClassesFromApi,
              builder: (BuildContext context , AsyncSnapshot<List<ClassesModel>> snapshot){
                if(snapshot.hasData){
                  if(classes.isEmpty)
                    classes = snapshot.data;
                  return DropdownButton(
                    hint: Text(ArStrings.get('class')),
                    isExpanded: true,
                    elevation: 0,
                    items: classes.map((k){
                      return DropdownMenuItem(
                        value: k,
                        child: Padding(
                          padding: const EdgeInsets.only(right:Dimes.d_10),
                          child: Text(k.name),
                        ),
                      );
                    }).toList(),
                    value: selectedClass,
                    onChanged: (value){
                      setState(() {
                        selectedClass = value;
                        classIsChanged = true;
                        // if(value.id != null)
                        //   getSubjects(value.id);
                      });
                    },
                  );
               } 
               return DropdownButton(
                 hint: Text(ArStrings.get('class')),
                    items: null,
                    isExpanded: true,
                    elevation: 0, onChanged: null,);
              });
  }

  getSubjects(int classId) {
    return FutureBuilder(
      future: ApiRepository.repository.getDataSubjectsFromApi(classId),
      builder: (BuildContext context , AsyncSnapshot<List<Subject>> snapshot){
      if(snapshot.hasData){
        if(subjects.isEmpty || classIsChanged){
          classIsChanged = false;
          subjects = snapshot.data;
          selectedSubject = null;
        }
        // selectedSubject = itemS;
        return DropdownButton(
          hint: Text(ArStrings.get('subject')),
          isExpanded: true,
          elevation: 0,
          items: subjects.map((k){
            return DropdownMenuItem(
              value: k,
              child: Padding(
              padding: const EdgeInsets.only(right:Dimes.d_10),
              child: Text(k.name),
            ),
          );
        }).toList(),
        value: selectedSubject,
        onChanged: (value){
          setState(() {
            selectedSubject = value;
            // itemS = value;
          });
        },
       );
    }
    return DropdownButton(
      hint: Text(ArStrings.get('subject')),
      isExpanded: true,
      elevation: 0, items: <DropdownMenuItem>[], onChanged: null,);
    });
  }
  
  getKinds(){
    return FutureBuilder(
              future: ApiRepository.repository.getKindsFromApi,
              builder: (BuildContext context , AsyncSnapshot<List<Kind>> snapshot){
                if(snapshot.hasData){
                  if(kinds.isEmpty)
                    kinds = snapshot.data;
                  return DropdownButton(
                    hint: Text(ArStrings.get('kind')),
                    isExpanded: true,
                    elevation: 0,
                    items: kinds.map((k){
                      return DropdownMenuItem(
                        value: k,
                        child: Padding(
                          padding: const EdgeInsets.only(right:Dimes.d_10),
                          child: Text(k.type),
                        ),
                      );
                    }).toList(),
                    value: selectedKinds,
                    onChanged: (value){
                      setState(() {
                        selectedKinds = value;
                      });
                    },
                  );
               } 
               return DropdownButton(
                 hint: Text(ArStrings.get('kind')),
                    isExpanded: true,
                    elevation: 0, items: <DropdownMenuItem>[], onChanged: null,);
              });
  }

  getTeachers(){
    return FutureBuilder(
              future: ApiRepository.repository.getDataTeachersFromApi,
              builder: (BuildContext context , AsyncSnapshot<List<Teachers>> snapshot){
                if(snapshot.hasData){
                  if(teachers.isEmpty)
                    teachers = snapshot.data;
                  return DropdownButton(
                    hint: Text(ArStrings.get('teacher')),
                    isExpanded: true,
                    elevation: 0,
                    items: teachers.map((k){
                      return DropdownMenuItem(
                        value: k,
                        child: Padding(
                          padding: const EdgeInsets.only(right:Dimes.d_10),
                          child: Text(k.name),
                        ),
                      );
                    }).toList(),
                    value: selectedTeacher,
                    onChanged: (value){
                      setState(() {
                        selectedTeacher = value;
                      });
                    },
                  );
               } 
               return DropdownButton(
                 hint: Text(ArStrings.get('teacher')),
                    isExpanded: true,
                    elevation: 0, items: <DropdownMenuItem>[], onChanged: null,);
              });
  }

}