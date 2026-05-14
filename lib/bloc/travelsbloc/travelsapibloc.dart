import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapistate.dart';
import 'package:travelsbookingapp/model/travelsmodel.dart';

class TravelsCubit extends Cubit<TravelsapiState> {
  TravelsCubit() : super(TravelsapiState());

  Dio dio = Dio();

  String travelsapiurl = "http://192.168.1.10:9999/travels-read";

  Future<void> TravelGetAPI() async {

    try {

      Response response =
      await dio.get(travelsapiurl);

      List<TravelsData> parsedData =
      List<TravelsData>.from(
        response.data.map(
              (x) => TravelsData.fromJson(x),
        ),
      );

      emit(
        state.copyWith(
          isValidTravelsApi: true,
          travelsdata: parsedData,
        ),
      );

      print(parsedData);

    } catch (e) {

      emit(
        state.copyWith(
          errormessage: e.toString(),
        ),
      );

      print(e);

    }
  }
}