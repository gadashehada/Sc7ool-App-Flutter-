class Subject {
  int id;
  String name;
  String image;
  int classesId;
  String status;
  String createdAt;

  Subject(
      {this.id,
      this.name,
      this.image,
      this.classesId,
      this.status,
      this.createdAt});

  Subject.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    image = json['image'];
    classesId = json['classes_id'];
    status = json['status'];
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['image'] = this.image;
    data['classes_id'] = this.classesId;
    data['status'] = this.status;
    data['created_at'] = this.createdAt;
    return data;
  }
}