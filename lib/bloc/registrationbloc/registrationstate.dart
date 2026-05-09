
class RegistrationState {
  final bool isValidRegistration;
  final String errormessage;
  final String successmessage;

  RegistrationState({
    this.isValidRegistration = false,
    this.errormessage = "",
    this.successmessage = "",
  });

  RegistrationState copyWith({
    bool? isValidRegistration,
    String? errormessage,
    String? successmessage,
  }) {
    return RegistrationState(
      isValidRegistration: isValidRegistration ?? this.isValidRegistration,
      errormessage: errormessage ?? this.errormessage,
      successmessage: successmessage ?? this.successmessage,
    );
  }
}
