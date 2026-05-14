import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginbloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationbloc.dart';
import 'package:travelsbookingapp/bloc/splashbloc/splashbloc.dart';
import 'package:travelsbookingapp/bloc/travelsbloc/travelsapibloc.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: Splash(),
      ),
    );
  }
}