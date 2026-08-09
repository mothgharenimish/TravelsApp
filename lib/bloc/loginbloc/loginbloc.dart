import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginstate.dart';
import 'package:travelsbookingapp/model/loginmodel.dart';
import 'package:travelsbookingapp/model/currentuser.dart';

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

      if (response.data["status"] == 1) {
        LoginModel model = LoginModel.fromJson(response.data);
        await savedata(model);

        emit(
          state.copyWith(
            isValidLogin: true,
            successmessage: model.message,
            logindata: model,
          ),
        );
      } else {
        emit(state.copyWith(errormessage: response.data["message"] ?? "Login failed"));
      }
    } catch (e) {
      emit(state.copyWith(errormessage: e.toString()));
      print(e);
    }
  }

  Future<void> savedata(LoginModel model) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("userid", model.userid);
    await prefs.setString("name", model.name);
    await prefs.setString("emailid", model.emailid);
    await prefs.setString("mobilenumber", model.mobilenumber);
    await prefs.setBool("isLogin", true);
  }

  Future<bool> checkLogin() async {
    final prefs = await SharedPreferences.getInstance();

    bool isLogin = prefs.getBool("isLogin") ?? false;

    if (isLogin) {
      CurrentUser.setUser(
        userid: prefs.getString("userid") ?? "",
        name: prefs.getString("name") ?? "",
        emailid: prefs.getString("emailid") ?? "",
        mobilenumber: prefs.getString("mobilenumber") ?? "",
      );
    }

    return isLogin;
  }
}