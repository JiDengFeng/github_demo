class UserModel {
  late String name;
  late String avatar;

  UserModel.fromJson(Map<String, dynamic> json) {
    name = json['login'];
    avatar = json['avatar_url'];
  }
}
