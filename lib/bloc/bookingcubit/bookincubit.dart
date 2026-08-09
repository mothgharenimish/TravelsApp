import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class BookingCubit extends Cubit<bool?> {
  BookingCubit() : super(null);

  Dio dio = Dio();

  String bookingapiurl = "http://192.168.1.10:9999/booking-travels";

  String errormessage = "";
  Map<String, dynamic>? bookingdetails;

  Future<void> BookingApi({
    required String travelsid,
    required String userid,
    required String emailid,
    required String mobilenumber,
    required String boardingcity,
    required String droppingcity,
    required String boardingpoint,
    required String droppingpoint,
    required int price,
    required List<Map<String, String>> passengers,
  }) async {
    try {
      Response response = await dio.post(
        bookingapiurl,
        data: {
          "travelsid": travelsid,
          "userid": userid,
          "emailid": emailid,
          "mobilenumber": mobilenumber,
          "boardingcity": boardingcity,
          "droppingcity": droppingcity,
          "boardingpoint": boardingpoint,
          "droppingpoint": droppingpoint,
          "price": price,
          "passengers": passengers,
        },
      );

      if (response.data["status"] == 1) {
        bookingdetails = response.data["bookingdetails"];
        emit(true);
      } else {
        errormessage = response.data["message"] ?? "Booking failed";
        emit(false);
      }
    } catch (e) {
      errormessage = e.toString();
      emit(false);
    }
  }
}