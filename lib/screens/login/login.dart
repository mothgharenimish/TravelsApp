import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginbloc.dart';
import 'package:travelsbookingapp/bloc/loginbloc/loginstate.dart';
import 'package:travelsbookingapp/model/currentuser.dart';
import 'package:travelsbookingapp/screens/Home/home.dart';
import 'package:travelsbookingapp/screens/bottomnavigation/mainNavigation.dart';
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
  static const Color bgColor = Color(0xFF0E1116);
  static const Color cardColor = Color(0xFF1C2028);
  static const Color borderColor = Color(0xFF262B35);
  static const Color amber = Color(0xFFE8B84B);
  static const Color muted = Color(0xFF9AA0AA);

  bool obscurePassword = true;
  bool isSubmitting = false;
  String? errorText;

  @override
  void initState() {
    super.initState();
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
      contentPadding: const EdgeInsets.symmetric(vertical: 14, horizontal: 4),
    );
  }

  void _submit(BuildContext context) {
    FocusScope.of(context).unfocus();

    if (widget.emailController.text.isEmpty ||
        widget.passwordController.text.isEmpty ||
        widget.mobilenoController.text.isEmpty) {
      setState(() => errorText = "All fields are required");
      return;
    }

    setState(() {
      errorText = null;
      isSubmitting = true;
    });

    context.read<LoginCubit>().LoginApi(
      email: widget.emailController.text,
      password: widget.passwordController.text,
      mobile: widget.mobilenoController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginCubit, LoginState>(
      listener: (BuildContext context, LoginState state) async {
        setState(() => isSubmitting = false);

        if (state.isValidLogin == true && state.logindata != null) {
          CurrentUser.setUser(
            userid: state.logindata!.userid,
            name: state.logindata!.name,
            emailid: state.logindata!.emailid,
            mobilenumber: state.logindata!.mobilenumber,
          );
          Navigator.push(context, MaterialPageRoute(builder: (_) => MainNavigation()));
        }
        if (state.errormessage.isNotEmpty) {
          setState(() => errorText = state.errormessage);
        }
      },
      child: Scaffold(
        backgroundColor: bgColor,
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 36),

                        /// LOGO BADGE
                        Center(
                          child: Container(
                            height: 68,
                            width: 68,
                            decoration: BoxDecoration(
                              color: cardColor,
                              shape: BoxShape.circle,
                              border: Border.all(color: borderColor, width: 1),
                            ),
                            child: const Icon(
                              Icons.directions_bus_filled_rounded,
                              color: amber,
                              size: 32,
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        const Text(
                          "Welcome back",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          "Log in to book your next journey",
                          textAlign: TextAlign.center,
                          style: TextStyle(fontSize: 13, color: muted),
                        ),

                        const SizedBox(height: 32),

                        TextField(
                          controller: widget.emailController,
                          keyboardType: TextInputType.emailAddress,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: _decoration("Email", Icons.mail_outline_rounded),
                        ),

                        const SizedBox(height: 14),

                        TextField(
                          controller: widget.mobilenoController,
                          keyboardType: TextInputType.phone,
                          style: const TextStyle(color: Colors.white, fontSize: 14),
                          decoration: _decoration("Mobile number", Icons.phone_outlined),
                        ),

                        const SizedBox(height: 14),

                        TextField(
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
                        ),

                        if (errorText != null) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              const Icon(Icons.error_outline_rounded,
                                  color: Color(0xFFE8746B), size: 15),
                              const SizedBox(width: 6),
                              Expanded(
                                child: Text(
                                  errorText!,
                                  style: const TextStyle(
                                    color: Color(0xFFE8746B),
                                    fontSize: 12.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],

                        const SizedBox(height: 26),

                        SizedBox(
                          height: 50,
                          child: ElevatedButton(
                            onPressed: isSubmitting ? null : () => _submit(context),
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
                              "Log in",
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF2A1E00),
                              ),
                            ),
                          ),
                        ),

                        const Spacer(),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 20, top: 20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Don't have an account?",
                                style: TextStyle(fontSize: 13.5, color: muted),
                              ),
                              const SizedBox(width: 5),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => Registration()),
                                  );
                                },
                                child: const Text(
                                  "Sign up",
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
              );
            },
          ),
        ),
      ),
    );
  }
}