import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationstate.dart';

class Registrationbloc extends Cubit<RegistrationState> {
  Registrationbloc() : super(RegistrationState());

  Dio dio = Dio();

  String registrationUrl = "http://192.168.1.4:9999/user-registration";

  Future<void> Registrationapi() async {
    emit(state.copyWith(isValidRegistration: true));
  }
}