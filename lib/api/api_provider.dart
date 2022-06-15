import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:school_1/UI/login.dart';
import 'package:school_1/api/models/classes_models/classes_model.dart';
import 'package:school_1/api/models/lessons_model/comment_model/comment.dart';
import 'package:school_1/api/models/lessons_model/kind.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/api/models/lessons_model/lesson_details.dart';
import 'package:school_1/api/models/news_model/news.dart';
import 'package:school_1/api/models/setting_model/setting.dart';
import 'package:school_1/api/models/teacher_model/teacher.dart';
import 'package:school_1/api/models/user_model/user.dart';

import 'models/subject_model/subject.dart';

class ApiProvider {

  String baseUrl = "http://test.hexacit.com/api";
  Dio dio = Dio();

  myheaders(){
    return {
      "Authorization" : "Bearer ${Login.user.access_token}" ,
      "Accept" : "application/json"
    };
  }

  Future<List<News>> getDataNewsFromApiAsync() async {
    Response response = await dio.get('$baseUrl/getNews');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['News']));
      List listNews = rawData.map((f) => News.fromJson(f)).toList();
      return listNews;
    }
    throw DioErrorType;
  }

  Future<List<ClassesModel>> getDataClassesFromApiAsync() async {
    Response response = await dio.get('$baseUrl/getClasses');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['classes']));
      List listClasses = rawData.map((f) => ClassesModel.fromJson(f)).toList();
      return listClasses;
    }
    throw DioErrorType;
  }

  Future<List<Subject>> getDataSubjectsFromApiAsync(int id) async {
    Response response = await dio.get('$baseUrl/getSubjects?class_id=$id');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['subjects']));
      List listSubjects = rawData.map((f) => Subject.fromJson(f)).toList();
      return listSubjects;
    }
    throw DioErrorType;
  }

  Future<List<Lesson>> getDataLessonsFromApiAsync(int classesId , int subjectId) async {
    Response response = await dio.get('$baseUrl/getLessons?classes_id=$classesId&subjects_id=$subjectId');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['lessons']));
      List listLessons = rawData.map((f) => Lesson.fromJson(f)).toList();
      return listLessons;
    }
    throw DioErrorType;
  }

  Future<LessonDetails> getDataLessonsDetailsFromApiAsync(int lessonId) async {
    Response response = await dio.get('$baseUrl/getLessonsDetails?id=$lessonId');
    if(response.statusCode == 200){
      final Map<String , dynamic> rawData = jsonDecode(jsonEncode(response.data['LessonsDetails']));
      LessonDetails lessonDetails =  LessonDetails.fromJson(rawData);
      return lessonDetails;
    }
    throw DioErrorType;
  }

  Future<List<Kind>> getKindsFromApiAsync() async {
    Response response = await dio.get('$baseUrl/getKinds');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['kinds']));
      List listKinds = rawData.map((f) => Kind.fromJson(f)).toList();
      return listKinds;
    }
    throw DioErrorType;
  }

  Future<Map<String , dynamic>> getDataPagesFromApiAsync() async {
    Response response = await dio.get('$baseUrl/pages/1');
    if(response.statusCode == 200){
      String image = response.data['page']['image'];
      String description = response.data['page']['description'];
      return {'image' : image , 'description' : description};
    }
    throw DioErrorType;
  }

  Future<List<Teachers>> getDataTeachersFromApiAsync() async {
    Response response = await dio.get('$baseUrl/getTeachers');
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['teachers']));
      List listTeachers = rawData.map((f) => Teachers.fromJson(f)).toList();
      return listTeachers;
    }
    throw DioErrorType;
  }

  Future<AppSettings> getDataSettingsFromApiAsync() async {
    Response response = await dio.get('$baseUrl/getSetting');
    if(response.statusCode == 200){
      final Map<String , dynamic> rawData = jsonDecode(jsonEncode(response.data['settings']));
      AppSettings appSettings = AppSettings.fromJson(rawData);
      return appSettings;
    }
    throw DioErrorType;
  }

  Future<Map<String , dynamic>> loginFromApiAsync(String email , String password) async {
    Response response = await dio.post('$baseUrl/login' , data: {'email' : email , 'password' : password});
    if(response.statusCode == 200){
      if(response.data['status']){
        final Map<String , dynamic> rawData = jsonDecode(jsonEncode(response.data['user']));
        User user = User.fromJson(rawData);
        return {'message' : response.data['message'] , 'user' : user };
      }
      return {'message' : response.data['message'] , 'user' : null };
    }
    throw DioErrorType;
  }

  Future<Map<String , dynamic>> createAccountFromApiAsync(User user) async {
    Response response = await dio.post('$baseUrl/signUp' , data: user.toJson());
    if(response.statusCode == 200){
      if(response.data['status']){
        return {'message' : response.data['message'] , 'user' : user };
      }
      return {'message' : response.data['message'] , 'user' : null };
    }
    throw DioErrorType;
  }

  Future<String> editProfileImageFromApiAsync(File image) async {
    String fileName = image.path.split('/').last;
    FormData data = FormData.fromMap({
      'image_profile': await MultipartFile.fromFile(
        image.path ,
        filename: fileName
      )
    });
    Response response = await dio.post('$baseUrl/editProfile' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      return response.data['message'];
    }
    throw DioErrorType;
  }

  Future<Map<String , dynamic>> editProfileFromApiAsync(User user) async {
    FormData data = FormData.fromMap(user.toJson());
    Response response = await dio.post('$baseUrl/editProfile' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      if(response.data['status'])
        return {'message' :response.data['message'] , 'user' : User.fromJson(response.data['user']) };
      else
        return {'message' :response.data['message'] , 'user' : null };
    }
    throw DioErrorType;
  }

  Future<String> contactFromApiAsync(Map<String , dynamic> data) async {
    Response response = await dio.post('$baseUrl/contactUs' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      return response.data['message'];
    }
    throw DioErrorType;
  }

  Future<String> addNewsToApiAsync(News news) async {
    FormData data = FormData.fromMap(await news.toJson());
    Response response = await dio.post('$baseUrl/postNews' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      return response.data['message'];
    }
    throw DioErrorType;
  }

  Future<String> addCommentToApiAsync(Comments comment) async {
    Response response = await dio.post('$baseUrl/postComments' , 
                                        data: comment.toJson(),
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      print(response.data);
      return response.data['message'];
    }
    throw DioErrorType;
  }

  Future<String> addLessonsToApiAsync(LessonDetails lesson) async {
    FormData data = FormData.fromMap(await lesson.toJson());
    Response response = await dio.post('$baseUrl/postLessons' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
      return response.data['message'];
    }
    throw DioErrorType;
  }

  Future<List<Lesson>> getTeacherLessonsFromApiAsync() async {
    Response response = await dio.get('$baseUrl/myLessons' , options: Options(headers :myheaders()));
    if(response.statusCode == 200){
      final List rawData = jsonDecode(jsonEncode(response.data['data']));
      List listLessons = rawData.map((f) => Lesson.fromJson(f)).toList();
      return listLessons;
    }
    throw DioErrorType;
  }

  Future<String> editLessonFromApiAsync(LessonDetails lessonDetails) async {
    FormData data = FormData.fromMap(await lessonDetails.toJson());
    Response response = await dio.post('$baseUrl/editLesson' , 
                                        data: data,
                                        options: Options(headers: myheaders()));
    if(response.statusCode == 200){
        return response.data['message'];
    }
    throw DioErrorType;
  }   
}