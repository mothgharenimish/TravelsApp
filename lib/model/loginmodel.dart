class LoginModel {

  int status;
  String message;
  String userid;
  String name;

  LoginModel({
    required this.status,
    required this.message,
    required this.userid,
    required this.name,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {

    return LoginModel(

      status: json["status"],
      message: json["message"],
      userid: json["userid"],
      name: json["name"],

    );
  }

  Map<String, dynamic> toJson() {

    return {

      "status": status,
      "message": message,
      "userid": userid,
      "name": name,

    };
  }
}