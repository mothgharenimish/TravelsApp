import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/model/boardingpointmodel.dart';

class BoardingCubit extends Cubit<List<BoardingData>> {
  BoardingCubit() : super([]);

  Dio dio = Dio();

  String boardingapiurl = "http://192.168.1.2:9999/boarding-points-read";

  Future<void> BoardingGetAPI() async {
    try {
      Response response = await dio.get(boardingapiurl);
      print(response);
      List<BoardingData> parsedData = List<BoardingData>.from(
        response.data.map((x) => BoardingData.fromJson(x)),
      );
      print(parsedData);
      emit(parsedData);
    } catch(e){
       print(e);
    }
  }
}