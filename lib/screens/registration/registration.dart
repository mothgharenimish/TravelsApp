import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationbloc.dart';
import 'package:travelsbookingapp/bloc/registrationbloc/registrationstate.dart';
import 'package:travelsbookingapp/screens/login/login.dart';

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

  final formKey = GlobalKey<FormState>();
  
  bool isValidEmail(String email) {
    String pattern =
        r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$';

    RegExp regex = RegExp(pattern);

    return regex.hasMatch(email);
  }

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
                "password": widget.passwordController.text,
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
          child: Form(
            key: formKey,
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
                  "SignUp to Continue",
                  style: TextStyle(
                    fontSize: 27,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
            
                Padding(
                  padding: const EdgeInsets.only(top: 25, left: 20, right: 20),
                  child: TextField(
                    controller: widget.nameController,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: TextFormField(
                    controller: widget.emailController,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: "Email Address",
                      border: OutlineInputBorder(),
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty) {
                       print("Email is required");
                      }
                      if (!isValidEmail(value!)) {
                        return "Enter valid email";
                      }

                      return null;
                    }
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: TextField(
                    controller: widget.mobilenumberController,
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
                    controller: widget.ageController,
                    onChanged: (value) {},
                    decoration: const InputDecoration(
                      labelText: "Age",
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15, left: 20, right: 20),
                  child: TextFormField(
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
                        if (
                        widget.nameController.text.isNotEmpty &&
                            widget.emailController.text.isNotEmpty &&
                            widget.mobilenumberController.text.isNotEmpty &&
                            widget.ageController.text.isNotEmpty &&
                            widget.passwordController.text.isNotEmpty
                        ) {

                          context.read<Registrationbloc>().Registrationapi();

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
                        "SignUp",
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
                        "Already have an account?",
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
            
                      SizedBox(width: 2),
            
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Login()),
                          );
                        },
                        child: Text(
                          "Login",
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
      ),
    );
  }
}
