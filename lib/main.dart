import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/LocationBloc/locationbloc.dart';
import 'package:travelsbookingapp/bloc/boardingpointbloc/boardingpointbloc.dart';
import 'package:travelsbookingapp/bloc/bookinghistorybloc/bookinghistorybloc.dart';
import 'package:travelsbookingapp/bloc/dropingpointbloc/dropingpointbloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginbloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationbloc.dart';
import 'package:travelsbookingapp/bloc/splashbloc/splashbloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapibloc.dart';
import 'package:travelsbookingapp/screens/setting/settingscreen.dart';
import 'package:travelsbookingapp/screens/splash/splash.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<SplashCubit>(
          create: (context) => SplashCubit(),
        ),

        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),

        BlocProvider<Registrationbloc>(
          create: (context) => Registrationbloc(),
        ),

        BlocProvider<TravelsCubit>(
          create: (context) => TravelsCubit(),
        ),

        BlocProvider<BoardingCubit>(
          create: (context) => BoardingCubit(),
        ),

        BlocProvider<DroppingCubit>(
          create: (context) => DroppingCubit(),
        ),

        BlocProvider<Bookinghistorybloc>(
          create: (context) => Bookinghistorybloc(),
        ),

        BlocProvider(
          create: (_) => LocationCubit()..loadSavedState(),
          child: SettingsScreen(),
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}