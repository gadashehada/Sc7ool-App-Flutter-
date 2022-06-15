import 'kind.dart';

class Lesson {
  int id;
  String title;
  String detail;
  String image;
  int subjectsId;
  int classesId;
  int userId;
  int kindId;
  Kind kind;

  Lesson(
      {this.id ,
      this.title,
      this.detail,
      this.image,
      this.subjectsId,
      this.classesId,
      this.userId,
      this.kindId});

  Lesson.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    detail = json['detail'];
    image = json['image'];
    subjectsId = json['subjects_id'];
    classesId = json['classes_id'];
    userId = json['user_id'];
    kindId = json['kind_id'];
    kind = json['kind'] != null ? new Kind.fromJson(json['kind']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['title'] = this.title;
    data['detail'] = this.detail;
    data['image'] = this.image;
    data['subjects_id'] = this.subjectsId;
    data['classes_id'] = this.classesId;
    data['user_id'] = this.userId;
    data['kind_id'] = this.kindId;
    return data;
  }
}
