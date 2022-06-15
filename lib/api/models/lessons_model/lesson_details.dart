import 'package:dio/dio.dart';
import 'package:school_1/api/models/user_model/user.dart';
import 'comment_model/comment.dart';
import 'kind.dart';
import 'lesson.dart';

class LessonDetails {
  Lesson lesson = Lesson();
  List<String> attachments;
  List<Comments> comments;
  User user;

  LessonDetails(
      {this.lesson,
      this.attachments,
      });

  LessonDetails.fromJson(Map<String, dynamic> json) {
    lesson.id = json['id'];
    lesson.title = json['title'];
    lesson.detail = json['detail'];
    lesson.image = json['image'];
    lesson.subjectsId = json['subjects_id'];
    lesson.classesId = json['classes_id'];
    lesson.userId = json['user_id'];
    lesson.kindId = json['kind_id'];
    if (json['attachments'] != null) {
      attachments = new List<String>();
      json['attachments'].forEach((v) {
        attachments.add(v['image']);
      });
    }
    if (json['comments'] != null) {
      comments = new List<Comments>();
      json['comments'].forEach((v) {
        comments.add(new Comments.fromJson(v));
      });
    }
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
    lesson.kind = json['kind'] != null ? new Kind.fromJson(json['kind']) : null;
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if(this.lesson.id != null)
      data['lesson_id'] = this.lesson.id;
    data['title'] = this.lesson.title;
    data['detail'] = this.lesson.detail;
    if(this.lesson.image != null){
      data['image'] = await MultipartFile.fromFile(
      this.lesson.image ,
      filename: this.lesson.image.split('/').last
    );
    }
    data['subjects_id'] = this.lesson.subjectsId;
    data['classes_id'] = this.lesson.classesId;
    data['user_id'] = this.lesson.userId;
    data['kind_id'] = this.lesson.kindId;
    if (this.attachments != null) {
      data['attachments'] = this.attachments.map((v) => 
        MultipartFile.fromFileSync(v)
      ).toList();
    }
    return data;
  }
}


