import 'package:travelsbookingapp/model/travelsmodel.dart';

class TravelsapiState {

  final bool isValidTravelsApi;
  final String errormessage;
  final String successmessage;
  final List<TravelsData> travelsdata;

  TravelsapiState({
    this.isValidTravelsApi = false,
    this.errormessage = "",
    this.successmessage = "",
    this.travelsdata = const [],
  });

  TravelsapiState copyWith({
    bool? isValidTravelsApi,
    String? errormessage,
    String? successmessage,
    List<TravelsData>? travelsdata,
  }) {

    return TravelsapiState(

      isValidTravelsApi:
      isValidTravelsApi ?? this.isValidTravelsApi,

      errormessage:
      errormessage ?? this.errormessage,

      successmessage:
      successmessage ?? this.successmessage,

      travelsdata:
      travelsdata ?? this.travelsdata,
    );
  }
}