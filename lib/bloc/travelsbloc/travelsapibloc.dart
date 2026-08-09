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
      Response response = await dio.get(travelsapiurl);
      List<TravelsData> parsedData = List<TravelsData>.from(
        response.data.map((x) => TravelsData.fromJson(x)),
      );

      for (var travel in parsedData) {
        travel.timeDifference =
            calculateTimeDifference(travel.boardingtime, travel.droppingtime);
        print(
          "The time difference is ${formatDuration(travel.timeDifference!)}",
        );
      }

      emit(state.copyWith(isValidTravelsApi: true, travelsdata: parsedData));

      print(parsedData);
    } catch (e) {
      emit(state.copyWith(errormessage: e.toString()));

      print(e);
    }
  }

  /// Parses a time string like "9:30 AM", "09:30 PM", or 24-hour "21:30"
  /// into a fixed reference DateTime so only the time-of-day is meaningful.
  DateTime _parseTime(String time) {
    final trimmed = time.trim().toUpperCase();
    final isPM = trimmed.contains("PM");
    final isAM = trimmed.contains("AM");

    final cleaned = trimmed.replaceAll("AM", "").replaceAll("PM", "").trim();
    final parts = cleaned.split(":");

    int hour = int.parse(parts[0].trim());
    int minute = parts.length > 1 ? int.parse(parts[1].trim()) : 0;

    if (isPM && hour != 12) {
      hour += 12;
    }
    if (isAM && hour == 12) {
      hour = 0;
    }

    return DateTime(2000, 1, 1, hour, minute);
  }

  /// Returns the trip duration in hours (as a decimal, e.g. 8.5 = 8h 30m).
  /// Correctly wraps past midnight for overnight trips.
  double calculateTimeDifference(String boardingtime, String droppingtime) {
    try {
      DateTime board = _parseTime(boardingtime);
      DateTime drop = _parseTime(droppingtime);

      Duration difference = drop.difference(board);

      // Overnight trip: dropping time is earlier in the clock than
      // boarding time, so it actually falls on the next day.
      if (!difference.isNegative && difference.inMinutes == 0) {
        // Same time given for boarding and dropping — treat as a full
        // 24-hour round trip rather than a zero-length one.
        difference += const Duration(days: 1);
      } else if (difference.isNegative) {
        difference += const Duration(days: 1);
      }

      return difference.inMinutes / 60.0;
    } catch (e) {
      print("Error calculating time difference: $e");
      return 0.0;
    }
  }

  String formatDuration(double hours) {
    final totalMinutes = (hours * 60).round();
    final h = totalMinutes ~/ 60;
    final m = totalMinutes % 60;

    if (h == 0) return "${m}m";
    if (m == 0) return "${h}h";
    return "${h}h ${m}m";
  }
}