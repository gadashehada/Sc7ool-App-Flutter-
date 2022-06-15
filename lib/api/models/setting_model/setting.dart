class AppSettings {
  int id;
  String url;
  String logo;
  String appStoreUrl;
  String playStoreUrl;
  String infoEmail;
  String mobile;
  String phone;
  String facebook;
  String twitter;
  String linkedIn;
  String instagram;
  String googlePlus;
  String descrip;
  String address;

  AppSettings(
      {this.id,
      this.url,
      this.logo,
      this.appStoreUrl,
      this.playStoreUrl,
      this.infoEmail,
      this.mobile,
      this.phone,
      this.facebook,
      this.twitter,
      this.linkedIn,
      this.instagram,
      this.googlePlus,
      this.address});

  AppSettings.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    url = json['url'];
    logo = json['logo'];
    appStoreUrl = json['app_store_url'];
    playStoreUrl = json['play_store_url'];
    infoEmail = json['info_email'];
    mobile = json['mobile'];
    phone = json['phone'];
    facebook = json['facebook'];
    twitter = json['twitter'];
    linkedIn = json['linked_in'];
    instagram = json['instagram'];
    googlePlus = json['google_plus'];
    descrip = json['descrip'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['url'] = this.url;
    data['logo'] = this.logo;
    data['app_store_url'] = this.appStoreUrl;
    data['play_store_url'] = this.playStoreUrl;
    data['info_email'] = this.infoEmail;
    data['mobile'] = this.mobile;
    data['phone'] = this.phone;
    data['facebook'] = this.facebook;
    data['twitter'] = this.twitter;
    data['linked_in'] = this.linkedIn;
    data['instagram'] = this.instagram;
    data['google_plus'] = this.googlePlus;
    data['descrip'] = this.descrip;
    data['address'] = this.address;
    return data;
  }
}
