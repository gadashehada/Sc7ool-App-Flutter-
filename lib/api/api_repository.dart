import 'dart:io';
import 'package:school_1/api/api_provider.dart';
import 'package:school_1/api/models/classes_models/classes_model.dart';
import 'package:school_1/api/models/lessons_model/kind.dart';
import 'package:school_1/api/models/lessons_model/lesson.dart';
import 'package:school_1/api/models/lessons_model/lesson_details.dart';
import 'package:school_1/api/models/setting_model/setting.dart';
import 'package:school_1/api/models/subject_model/subject.dart';
import 'package:school_1/api/models/teacher_model/teacher.dart';
import 'models/lessons_model/comment_model/comment.dart';
import 'models/news_model/news.dart';
import 'models/user_model/user.dart';

class ApiRepository {

  ApiRepository._privateConstructor();
  static final ApiRepository repository = ApiRepository._privateConstructor();

  ApiProvider _provider = ApiProvider();

  Future<List<News>> get getDataNewsFromApi => _provider.getDataNewsFromApiAsync();

  Future<List<ClassesModel>> get getDataClassesFromApi => _provider.getDataClassesFromApiAsync();

  Future<List<Subject>>  getDataSubjectsFromApi(int id) => _provider.getDataSubjectsFromApiAsync(id);

  Future<List<Lesson>> getDataLessonsFromApi(int classesId , int subjectId) => _provider.getDataLessonsFromApiAsync(classesId , subjectId);
 
  Future<LessonDetails> getDataLessonsDetailsFromApi(int lessonId) => _provider.getDataLessonsDetailsFromApiAsync(lessonId);

  Future<List<Kind>> get getKindsFromApi => _provider.getKindsFromApiAsync();

  Future<Map<String , dynamic>> get getDataPagesFromApi => _provider.getDataPagesFromApiAsync();

  Future<List<Teachers>> get getDataTeachersFromApi => _provider.getDataTeachersFromApiAsync();

  Future<AppSettings> get getDataSettingsFromApi => _provider.getDataSettingsFromApiAsync();

  Future<Map<String , dynamic>> loginFromApi(String email , String password) => _provider.loginFromApiAsync(email, password);

  Future<Map<String , dynamic>> createAccountFromApi(User user) => _provider.createAccountFromApiAsync(user);

  Future<String> editProfileImageFromApi(File image) => _provider.editProfileImageFromApiAsync(image);

  Future<Map<String , dynamic>> editProfileFromApi(User user) => _provider.editProfileFromApiAsync(user);

  Future<String> contactFromApi(Map<String , dynamic> data) => _provider.contactFromApiAsync(data);

  Future<String> addNewsToApiAsync(News news) => _provider.addNewsToApiAsync(news);

  Future<String> addCommentToApiAsync(Comments comment) => _provider.addCommentToApiAsync(comment);

  Future<String>  addLessonsToApi(LessonDetails lesson) => _provider. addLessonsToApiAsync(lesson);

  Future<List<Lesson>> get getTeacherLessonsFromApi => _provider.getTeacherLessonsFromApiAsync();

  Future<String> editLessonFromApi(LessonDetails lessonDetails) => _provider.editLessonFromApiAsync(lessonDetails);
}