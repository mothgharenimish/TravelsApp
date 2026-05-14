import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginstate.dart';
import 'package:travelsbookingapp/model/loginmodel.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginState());

  Dio dio = Dio();

  String loginurl = "http://192.168.1.10:9999/user-login";

  Future<void> LoginApi({
    required String email,

    required String password,

    required String mobile,
  }) async {
    try {
      Response response = await dio.post(
        loginurl,

        data: {"emailid": email, "password": password, "mobilenumber": mobile},
      );

      print(response.data);

      LoginModel model = LoginModel.fromJson(response.data);

      savedata(model.userid);
      emit(
        state.copyWith(
          isValidLogin: true,

          successmessage: model.message,

          logindata: model,
        ),
      );
    } catch (e) {
      emit(state.copyWith(errormessage: e.toString()));

      print(e);
    }
  }

  Future<void> savedata(String userid) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userid", userid);

    await prefs.setBool("isLogin", true);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool("isLogin") ?? false;

    return isLogin;
  }
}
