
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/splashbloc/splashstate.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashState());

  void splashStart() {
    Timer(const Duration(seconds: 10), () {

      emit(
        state.copyWith(
          isValidSplash: true,
          successmessage: "From the Splash Screen navigate to next screen"
        )
      );

    });
  }

}