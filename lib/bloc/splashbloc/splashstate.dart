class SplashState {
  final bool isValidSplash;
  final String errormessage;
  final String successmessage;

  SplashState({
    this.isValidSplash = false,
    this.errormessage = "",
    this.successmessage = "",
  });

  SplashState copyWith({
    bool? isValidSplash,
    String? errormessage,
    String? successmessage,
  }) {
    return SplashState(
      isValidSplash: isValidSplash ?? this.isValidSplash,
      errormessage: errormessage ?? this.errormessage,
      successmessage: successmessage ?? this.successmessage,
    );
  }
}
