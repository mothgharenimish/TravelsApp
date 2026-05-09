
class LoginState {
  final bool isValidLogin;
  final String errormessage;
  final String successmessage;

  LoginState({
    this.isValidLogin = false,
    this.errormessage = "",
    this.successmessage = "",
  });

  LoginState copyWith({
    bool? isValidLogin,
    String? errormessage,
    String? successmessage,
  }) {
    return LoginState(
      isValidLogin: isValidLogin ?? this.isValidLogin,
      errormessage: errormessage ?? this.errormessage,
      successmessage: successmessage ?? this.successmessage,
    );
  }
}
