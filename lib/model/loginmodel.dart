class LoginModel {

  int status;
  String message;
  String userid;
  String name;
  String emailid;
  String mobilenumber;

  LoginModel({
    required this.status,
    required this.message,
    required this.userid,
    required this.name,
    required this.emailid,
    required this.mobilenumber

  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {

    return LoginModel(

      status: json["status"],
      message: json["message"],
      userid: json["userid"],
      name: json["name"],
      emailid: json['emailid'],
      mobilenumber: json['mobilenumber']

    );
  }

  Map<String, dynamic> toJson() {

    return {

      "status": status,
      "message": message,
      "userid": userid,
      "name": name,
      "emailid": emailid,
      "mobilenumber": mobilenumber

    };
  }
}