class TravelsapiState {
  final bool isValidTravelsApi;
  final String errormessage;
  final String successmessage;

  TravelsapiState({
    this.isValidTravelsApi = false,
    this.errormessage = "",
    this.successmessage = "",
  });

  TravelsapiState copyWith({
    bool? isValidTravelsApi,
    String? errormessage,
    String? successmessage,
  }) {
    return TravelsapiState(
      isValidTravelsApi: isValidTravelsApi ?? this.isValidTravelsApi,
      errormessage: errormessage ?? this.errormessage,
      successmessage: successmessage ?? this.successmessage,
    );
  }
}
