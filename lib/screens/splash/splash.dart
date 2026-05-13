import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/splashbloc/splashbloc.dart';
import 'package:travelsbookingapp/bloc/splashbloc/splashstate.dart';
import 'package:travelsbookingapp/screens/login/login.dart';

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    context.read<SplashCubit>().splashStart();

  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SplashCubit, SplashState>(
      listener: (BuildContext context, SplashState state) {
        if (state.isValidSplash == true) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) =>  Login()),
          );
        }
      },
      child: Scaffold(
        body: Center(
          child: Container(
            child: Image.asset("assets/images/redbus.png",
              height: 200,
              width: 200,

            ),
          ),
        ),
      ),
    );
  }
}
