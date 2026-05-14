// loginstate.dart

import 'package:travelsbookingapp/model/loginmodel.dart';

class LoginState {
  final bool isValidLogin;
  final String errormessage;
  final String successmessage;
  final LoginModel? logindata;

  LoginState({
    this.isValidLogin = false,

    this.errormessage = "",

    this.successmessage = "",

    this.logindata,
  });

  LoginState copyWith({
    bool? isValidLogin,

    String? errormessage,

    String? successmessage,

    LoginModel? logindata,
  }) {
    return LoginState(
      isValidLogin: isValidLogin ?? this.isValidLogin,

      errormessage: errormessage ?? this.errormessage,

      successmessage: successmessage ?? this.successmessage,

      logindata: logindata ?? this.logindata,
    );
  }
}
