import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationbloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationstate.dart';

class Registration extends StatefulWidget {
  Registration({super.key});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final mobilenumberController = TextEditingController();
  final ageController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  State<Registration> createState() => _RegistrationState();
}

class _RegistrationState extends State<Registration> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<Registrationbloc, RegistrationState>(
      listener: (BuildContext context, RegistrationState state) async {
        if (state.isValidRegistration == true) {
          Dio dio = Dio();
          String url = context.read<Registrationbloc>().registrationUrl;

          try {
            Response response = await dio.post(
              url,
              data: {
                "name": widget.nameController.text,
                "emailid": widget.emailController.text,
                "mobilenumber": widget.mobilenumberController.text,
                "age": widget.ageController.text,
                "password" : widget.passwordController.text
              },
            );

            print(response.data);
          } catch (e) {
            print(e);
          }
        }
      },
      child: Scaffold(
        body: Column(
          children: [

          ],
        ),
      ),
    );
  }
}
