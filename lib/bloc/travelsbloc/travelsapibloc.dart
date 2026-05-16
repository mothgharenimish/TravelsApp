import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapistate.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';

class TravelsCubit extends Cubit<TravelsapiState> {
  TravelsCubit() : super(TravelsapiState());

  Dio dio = Dio();
  // DateTime today = DateTime.now();
  // DateTime futureDate = DateTime.now().add(Duration(days: 20));
  // late String todaydate  = "${today.day}-${today.month}-${today.year}";
  // late String futuredate = "${futureDate.day}-${futureDate.month}-${futureDate.year}";

  String travelsapiurl = "http://192.168.1.9:9999/travels-read";

  Future<void> TravelGetAPI() async {
    try {
      Response response = await dio.get(travelsapiurl);
      List<TravelsData> parsedData = List<TravelsData>.from(
        response.data.map((x) => TravelsData.fromJson(x)),
      );

      for (var travel in parsedData) {
        travel.timeDifference = calculateTimeDifference(travel.boardingtime, travel.droppingtime);
        print( travel.timeDifference);
      }

      emit(state.copyWith(isValidTravelsApi: true, travelsdata: parsedData));

      print(parsedData);
    } catch (e) {
      emit(state.copyWith(errormessage: e.toString()));

      print(e);
    }
  }

  double calculateTimeDifference(String boardingtime, String droppingtime) {
    try {
      String boardtime = boardingtime
          .replaceAll(" AM", "")
          .replaceAll(" PM", "");
      String droptime = droppingtime
          .replaceAll(" AM", "")
          .replaceAll(" PM", "");

      String formattedboardTime = boardtime.replaceAll(":", ".");
      String formatteddropTime = droptime.replaceAll(":", ".");

      double boardingdouble = double.parse(formattedboardTime);
      double dropingdouble = double.parse(formatteddropTime);

      double difference = (boardingdouble - dropingdouble).abs();

      return difference;
    } catch (e) {
      print("Error calculating time difference: $e");
      return 0.0;
    }
  }
}
