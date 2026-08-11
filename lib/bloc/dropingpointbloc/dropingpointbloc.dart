import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/model/dropingpointmodel.dart';

class DroppingCubit extends Cubit<List<DroppingData>> {
  DroppingCubit() : super([]);

  Dio dio = Dio();

  String droppingapiurl = "http://192.168.1.2:9999/dropping-points-read";

  Future<void> DroppingGetAPI() async {
    try {
      Response response = await dio.get(droppingapiurl);

      List<DroppingData> parsedData = List<DroppingData>.from(
        response.data.map((x) => DroppingData.fromJson(x)),
      );

      emit(parsedData);
    } catch (e) {
      print(e);
    }
  }
}