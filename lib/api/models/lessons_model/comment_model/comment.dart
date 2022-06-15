import 'package:school_1/api/models/user_model/user.dart';

class Comments {
  int id;
  int userId;
  int lessonId;
  String comment;
  String status;
  String createdAt;
  User user;

  Comments(
      {this.userId,
      this.lessonId,
      this.comment});

  Comments.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    lessonId = json['lesson_id'];
    comment = json['comment'];
    status = json['status'];
    createdAt = json['created_at'];
    user = json['user'] != null ? new User.fromJson(json['user']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['lesson_id'] = this.lessonId;
    data['comment'] = this.comment;
    return data;
  }
}