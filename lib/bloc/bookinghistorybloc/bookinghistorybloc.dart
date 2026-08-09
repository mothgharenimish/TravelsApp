import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/model/bookinghistorymodel.dart';

class Bookinghistorybloc extends Cubit<List<BookingHistoryData>> {
  Bookinghistorybloc() : super([]);

  Dio dio = Dio();

  String bookinghistoryurl = "http://192.168.1.10:9999/booking-travels-read";

  Future<void> BookingHistoryGetAPI() async {
    try {

      Response response = await dio.get(bookinghistoryurl);
      print(response);
      List<BookingHistoryData> parsedData = List<BookingHistoryData>.from(
        response.data.map((x) => BookingHistoryData.fromJson(x)),
      );
      print(parsedData);
      emit(parsedData);
    } catch(e) {
      print(e);
    }
  }
}