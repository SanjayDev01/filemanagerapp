class UserModel {
  String? email;
  String? uid;
  String? username;
  DateTime? timestamp;

  UserModel({this.email, this.uid, this.username, this.timestamp});

  Map toMap(UserModel user) {
    var data = <String, dynamic>{};

    data["uid"] = user.uid;
    data["username"] = user.username;
    data["email"] = user.email;
    data["timestamp"] = user.timestamp;

    return data;
  }

  UserModel.fromMap(Map<String, dynamic> mapData) {
    uid = mapData["uid"];
    username = mapData["username"];
    email = mapData["email"];
  }
}
