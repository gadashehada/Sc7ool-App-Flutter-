import 'package:dio/dio.dart';

class News {
  int id;
  String title;
  String description;
  String image;
  String status;
  int newsAttachmentsId;
  String createdAt;

  News(
      {this.title,
      this.description,
      this.image,
      this.newsAttachmentsId});

  News.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    description = json['description'];
    image = json['image'];
    status = json['status'];
    newsAttachmentsId = json['news_attachments_id'];
    createdAt = json['created_at'];
  }

  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    // data['id'] = this.id;
    data['title'] = this.title;
    data['description'] = this.description;
    String fileName = this.image.split('/').last;
    data['image'] = await MultipartFile.fromFile(
      this.image ,
      filename: fileName
    );
    // data['status'] = this.status;
    data['news_attachments_id'] = this.newsAttachmentsId;
    // data['created_at'] = this.createdAt;
    return data;
  }
}