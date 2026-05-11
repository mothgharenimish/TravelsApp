import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginbloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginstate.dart';
import 'package:travelsbookingapp/screens/registration/registration.dart';

class Login extends StatefulWidget {
  Login({super.key});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final mobilenoController = TextEditingController();

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) async {
        if (state.isValidLogin == true) {
          Dio dio = Dio();
          String url = context.read<LoginCubit>().loginurl;

          try {
            Response response = await dio.post(
              url,
              data: {
                "emailid": widget.emailController.text,
                "password": widget.passwordController.text,
                "mobilenumber": widget.mobilenoController.text,
              },
            );
            print(response.data);
          } catch (e) {
            print(e);
          }
        }
      },
      child: Scaffold(
        body: Center(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50),
                child: Image.asset(
                  "assets/images/org.png",
                  height: 250,
                  width: 250,
                  fit: BoxFit.fill,
                ),
              ),

              Text(
                "Login to Continue",
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                child: TextField(
                  controller: widget.emailController,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: "Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextField(
                  controller: widget.mobilenoController,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: "Mobile Number",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                child: TextField(
                  controller: widget.passwordController,
                  obscureText: true,
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),

              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SizedBox(
                  height: 50,
                  width: double.infinity,

                  child: ElevatedButton(
                    onPressed: () async {
                      if (widget.emailController.text.isNotEmpty &&
                          widget.passwordController.text.isNotEmpty &&
                          widget.mobilenoController.text.isNotEmpty) {
                        context.read<LoginCubit>().LoginApi();
                      } else {
                        print("All fields are required");
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),

                      backgroundColor: const Color(0xFFC57846),
                    ),

                    child: const Text(
                      "Login",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                        color: Colors.black,
                      ),
                    ),

                    SizedBox(width: 2),

                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (_) => Registration()),
                        );
                      },
                      child: Text(
                        "SignUp",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFFC57846),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
