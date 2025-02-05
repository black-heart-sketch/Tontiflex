import 'package:auto_route/annotations.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tontiflex/routes/app_router.dart';

import '../../../constants.dart';
import '../../database/user_db/user_service.dart';

@RoutePage(name: 'SignUpScreenRoute')
class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController(),
      passwordController = TextEditingController(),
      usernameController = TextEditingController(),
      nameController = TextEditingController();
  bool value = false;

  void setValue() {
    setState(() {
      value = !value;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF4e54c8), Color(0xFF8f94fb)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                SvgPicture.asset(
                  "assets/icons/currency.svg",
                  height: 100,
                ),
                const SizedBox(height: 30),
                Text(
                  "Let's get started!",
                  style: TextStyle(
                    fontSize: 28,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Please enter your valid data in order to create an account.",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      buildTextField(
                        controller: nameController,
                        hintText: "Firstname",
                        icon: "assets/icons/FaceId.svg",
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: usernameController,
                        hintText: "Lastname",
                        icon: "assets/icons/FaceId.svg",
                        keyboardType: TextInputType.name,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: emailController,
                        hintText: "Email Address",
                        icon: "assets/icons/Message.svg",
                        validator: emaildValidator,
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      buildTextField(
                        controller: passwordController,
                        hintText: "Password",
                        icon: "assets/icons/Lock.svg",
                        validator: passwordValidator,
                        obscureText: true,
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Checkbox(
                            onChanged: (value) {
                              setValue();
                            },
                            value: value,
                          ),
                          Expanded(
                            child: Text.rich(
                              TextSpan(
                                text: "I agree with the",
                                children: [
                                  TextSpan(
                                    recognizer: TapGestureRecognizer()
                                      ..onTap = () {
                                        /*Navigator.pushNamed(
                                            context, termsOfServicesScreenRoute);*/
                                      },
                                    text: " Terms of service ",
                                    style: const TextStyle(
                                      color: primaryColor,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const TextSpan(
                                    text: "& privacy policy.",
                                  ),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 30),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            submit(
                              name: nameController.text.trim(),
                              email: emailController.text.trim(),
                              password: passwordController.text.trim(),
                              username: usernameController.text.trim(),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Please correct the errors in the form."),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 80, vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          "Continue",
                          style: TextStyle(
                            color: Color(0xFF4e54c8),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Do you have an account? ",
                            style: TextStyle(color: Colors.white70),
                          ),
                          TextButton(
                            onPressed: () {
                              AutoRouter.of(context).push(LoginScreenRoute());
                            },
                            child: const Text(
                              "Log in",
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          )
                        ],
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

  Widget buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String icon,
    FormFieldValidator<String>? validator,
    bool obscureText = false,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(color: Colors.white70),
        filled: true,
        fillColor: Colors.white.withOpacity(0.2),
        prefixIcon: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SvgPicture.asset(
            icon,
            height: 20,
            width: 20,
            colorFilter: const ColorFilter.mode(Colors.white70, BlendMode.srcIn),
          ),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  void submit({
    required String name,
    required String email,
    required String password,
    required String username,
  }) async {
    UserServices userDatabase = UserServices();
    var auth = await userDatabase.createUser(
      name: name,
      email: email,
      password: password,
      username: username,
    );
    print(auth);
    if (auth) {
      AutoRouter.of(context).replace(LoginScreenRoute());
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Account created successfully!')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Failed to create account."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
