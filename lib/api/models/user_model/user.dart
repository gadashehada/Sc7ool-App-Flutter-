class User {
  int id;
  String name;
  String email;
  String mobile;
  String imageProfile;
  String type;
  String access_token;
  String pass;
  bool isAddUser = false;
  bool isPreferances = false;

  User(
      {this.name,
      this.email,
      this.mobile,
      this.imageProfile,
      this.pass ,
      this.isAddUser});

  setIsPreferances(bool pref){
    this.isPreferances = pref;
  }

  User.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    email = json['email'];
    mobile = json['mobile'];
    imageProfile = json['image_profile'];
    type = json['type'];
    access_token = json['access_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['mobile'] = this.mobile;
    if(isAddUser != null){
      if(isAddUser){
        data['image_profile'] = this.imageProfile;
        data['password'] = this.pass;
      }
    }
    if(this.isPreferances){
      data['image_profile'] = this.imageProfile;
      data['access_token'] = this.access_token;
      data['type'] = this.type;
      data['id'] = this.id;
    }
    return data;
  }
}