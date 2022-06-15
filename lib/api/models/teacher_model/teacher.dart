class Teachers {
  int id;
  String name;
  String email;
  String mobile;
  String imageProfile;
  String type;

  Teachers(
      {this.id,
      this.name,
      this.email,
      this.mobile,
      this.imageProfile,
      this.type});

  Teachers.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    imageProfile = json['image_profile'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    data['image_profile'] = this.imageProfile;
    data['type'] = this.type;
    return data;
  }
}
