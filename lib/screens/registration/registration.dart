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
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);
  static const Color errorColor = Color(0xFFE8746B);

  final formKey = GlobalKey<FormState>();

  bool obscurePassword = true;
  bool isSubmitting = false;
  String? apiError;

  bool isValidEmail(String email) {
    String pattern = r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]+$';
    RegExp regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  InputDecoration _decoration(String label, IconData icon, {Widget? suffix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: muted, fontSize: 14),
      prefixIcon: Icon(icon, color: amber, size: 20),
      suffixIcon: suffix,
      filled: true,
      fillColor: cardColor,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: borderColor, width: 1),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: amber, width: 1.4),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: errorColor, width: 1.4),
      ),
      errorStyle: const TextStyle(color: errorColor, fontSize: 11.5),
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    );
  }

  Future<void> _register(BuildContext context) async {
    FocusScope.of(context).unfocus();

    if (!(formKey.currentState?.validate() ?? false)) return;

    setState(() {
      apiError = null;
      isSubmitting = true;
    });

    context.read<Registrationbloc>().Registrationapi();
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
            setState(() => isSubmitting = false);
            print(response.data);
            if (context.mounted) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => Login()),
              );
            }
          } catch (e) {
            setState(() {
              isSubmitting = false;
              apiError = "Something went wrong. Please try again.";
            });
            print(e);
          }
        } else {
          setState(() => isSubmitting = false);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Form(
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 28),

                  /// LOGO BADGE
                  Center(
                    child: Container(
                      height: 64,
                      width: 64,
                      decoration: BoxDecoration(
                        color: cardColor,
                        shape: BoxShape.circle,
                        border: Border.all(color: borderColor, width: 1),
                      ),
                      child: const Icon(
                        Icons.directions_bus_filled_rounded,
                        color: amber,
                        size: 30,
                      ),
                    ),
                  ),

                  const SizedBox(height: 18),

                  const Text(
                    "Create your account",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    "Sign up to start booking your trips",
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 13, color: muted),
                  ),

                  const SizedBox(height: 28),

                  TextFormField(
                    controller: widget.nameController,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _decoration("Full name", Icons.person_outline_rounded),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Full name is required";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: widget.emailController,
                    keyboardType: TextInputType.emailAddress,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _decoration("Email address", Icons.mail_outline_rounded),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Email is required";
                      }
                      if (!isValidEmail(value)) {
                        return "Enter a valid email";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: widget.mobilenumberController,
                    keyboardType: TextInputType.phone,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _decoration("Mobile number", Icons.phone_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Mobile number is required";
                      }
                      if (value.trim().length < 10) {
                        return "Enter a valid mobile number";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: widget.ageController,
                    keyboardType: TextInputType.number,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _decoration("Age", Icons.cake_outlined),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return "Age is required";
                      }
                      final age = int.tryParse(value.trim());
                      if (age == null || age <= 0 || age > 120) {
                        return "Enter a valid age";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 14),

                  TextFormField(
                    controller: widget.passwordController,
                    obscureText: obscurePassword,
                    style: const TextStyle(color: Colors.white, fontSize: 14),
                    decoration: _decoration(
                      "Password",
                      Icons.lock_outline_rounded,
                      suffix: IconButton(
                        onPressed: () =>
                            setState(() => obscurePassword = !obscurePassword),
                        icon: Icon(
                          obscurePassword
                              ? Icons.visibility_off_outlined
                              : Icons.visibility_outlined,
                          color: muted,
                          size: 19,
                        ),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Password is required";
                      }
                      if (value.length < 6) {
                        return "Password must be at least 6 characters";
                      }
                      return null;
                    },
                  ),

                  if (apiError != null) ...[
                    const SizedBox(height: 14),
                    Row(
                      children: [
                        const Icon(Icons.error_outline_rounded, color: errorColor, size: 15),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            apiError!,
                            style: const TextStyle(color: errorColor, fontSize: 12.5),
                          ),
                        ),
                      ],
                    ),
                  ],

                  const SizedBox(height: 24),

                  SizedBox(
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isSubmitting ? null : () => _register(context),
                      style: ElevatedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: amber,
                        disabledBackgroundColor: amber.withOpacity(0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: isSubmitting
                          ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2.4,
                          color: Color(0xFF2A1E00),
                        ),
                      )
                          : const Text(
                        "Sign up",
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF2A1E00),
                        ),
                      ),
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.only(top: 20, bottom: 24),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Already have an account?",
                          style: TextStyle(fontSize: 13.5, color: muted),
                        ),
                        const SizedBox(width: 5),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => Login()),
                            );
                          },
                          child: const Text(
                            "Log in",
                            style: TextStyle(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: amber,
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
      ),
    );
  }
}