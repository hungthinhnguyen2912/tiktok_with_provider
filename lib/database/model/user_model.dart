class UserModel {
  String gender;
  String fullname;
  String email;
  String age;
  String phone;
  List<String>? following;
  List<String>? follower;
  String avatarURL;

  UserModel(
      {required this.gender,
        required this.email,
        required this.phone,
        required this.age,
        required this.avatarURL,
        required this.fullname,
        this.follower,
        this.following});
}