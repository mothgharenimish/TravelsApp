
import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginstate.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Dio dio = Dio();

  String loginurl = "http://192.168.1.3:9999/user-login";

  Future<void> LoginApi() async {
    emit(
      state.copyWith(
        isValidLogin: true
      )
    );
  }


}