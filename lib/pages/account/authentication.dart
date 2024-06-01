// ignore_for_file: unused_import, unused_local_variable, unnecessary_import, deprecated_member_use, library_private_types_in_public_api, avoid_unnecessary_containers, use_build_context_synchronously, avoid_print

import 'package:aap_dev_project/bloc/user/user_block.dart';
import 'package:aap_dev_project/bloc/user/user_event.dart';
import 'package:aap_dev_project/core/repository/user_repo.dart';
import 'package:aap_dev_project/pages/account/authtry,dart';
import 'package:aap_dev_project/pages/reminder/medicine.dart';
import 'package:aap_dev_project/pages/account/forgotPassword.dart';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import 'package:aap_dev_project/pages/account/register.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../home/dashboard.dart';
import 'package:aap_dev_project/models/user.dart';

class Authentication extends StatelessWidget {
  const Authentication({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset('assets/MEDQR.jpg'),
          const SizedBox(height: 60),
          SizedBox(
            width: 300, // Ensures both buttons have the same width
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => RegistrationScreen()),
                );
              },
              label: const Text(
                'Register',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                ),
              ),
              backgroundColor: Colors.green,
              icon: const Icon(Icons.app_registration),
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: 300, // Ensures both buttons have the same width
            child: FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const LoginScreen()),
                );
              },
              label: const Text(
                'Login',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                ),
              ),
              backgroundColor: Colors.blue,
              icon: const Icon(Icons.login_outlined),
            ),
          ),
        ],
      ),
    );
  }
}

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final UserRepository userRepository = UserRepository();


  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool _isHidden = true;
  String signInStatus = '';

  @override
  void initState() {
    super.initState();
  }

  void _toggleVisibility() {
    setState(() {
      _isHidden = !_isHidden;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.white, // Set the app bar background color to white
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const Authentication()),
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Container(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Welcome Back',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Urbanist',
                  ),
                ),
                const SizedBox(height: 48),
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Enter your email',
                    hintStyle: const TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isHidden,
                  decoration: InputDecoration(
                    hintText: 'Enter your password',
                    hintStyle: const TextStyle(
                      fontFamily: 'Urbanist',
                    ),
                    suffixIcon: IconButton(
                      onPressed: _toggleVisibility,
                      icon: _isHidden
                          ? const Icon(Icons.visibility_off)
                          : const Icon(Icons.visibility),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const ForgotPasswordScreen()),
                    );
                  },
                  child: const Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Forgot Password?',
                      style: TextStyle(
                        color: Color(0xFF6A707C),
                        fontFamily: 'Urbanist',
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    signInStatus,
                    style: const TextStyle(
                      color: Colors.red, // Color for the status message
                      fontFamily: 'Urbanist',
                    ),
                  ),
                ),
                FloatingActionButton.extended(
                  onPressed: () async {
                    try {
                      bool loginSuccess = await userRepository.LoginUser_repo(
                        user_email: emailController.text,
                        user_pass: passwordController.text,
                      );

                      if (loginSuccess) {
                        // Navigate to DashboardApp if login is successful
                         Navigator.pushReplacement(  // Using pushReplacement to avoid back navigation to login
                          context,
                          MaterialPageRoute(builder: (context) =>  const AuthenticatedWrapper()),
                        );
                      } else {
                        // Show error dialog if login failed
                        showLoginErrorDialog(context);
                      }
                    } catch (e) {
                      // Handle any unexpected errors
                      print('Error: $e');
                      showLoginErrorDialog(context);
                    }
                  },
                  icon: const Icon(Icons.login),
                  label: const Text(
                    'Login',
                    style: TextStyle(
                      fontFamily: 'Urbanist',
                      color: Colors.white,
                    ),
                  ),
                  backgroundColor: const Color(0xFF01888B),
                ),
                 const SizedBox(height: 30),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const SizedBox(width: 10), // Add this
                //     Expanded(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           border: Border.all(color: Colors.grey, width: 0.2),
                //           borderRadius: BorderRadius.circular(10),
                //         ),
                //         child: TextButton.icon(
                //           icon: const FaIcon(FontAwesomeIcons.google),
                //           label: const Text('Sign in with Google'),
                //           onPressed: () async {
                //             try {
                //                 print('Successfully signed in with Google');
                                
                //             } catch (e) {
                //               // Handle error here
                //               print('Error signing in with Google: $e');
                //             }
                //           },
                //         ),
                //       ),
                //     ),
                //     const SizedBox(width: 10), // Add this
                //   ],
                // ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () {},
                  child: Text.rich(
                    TextSpan(
                      text: 'Don’t have an account? ',
                      style: const TextStyle(
                        fontFamily: 'Urbanist',
                      ),
                      children: [
                        TextSpan(
                          text: 'Register Now',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.teal,
                            fontFamily: 'Urbanist',
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => RegistrationScreen()),
                              );
                            },
                        ),
                      ],
                    ),
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
void showLoginErrorDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Login Failed'),
        content: Text('Invalid email or password. Please try again.'),
        actions: [
          TextButton(
            child: Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
class AuthenticatedWrapper extends StatelessWidget {
  const AuthenticatedWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserBloc>(
      create: (context) => UserBloc(userRepository: UserRepository()),
      child: const DashboardApp(),  // Or your main authenticated view
    );
  }
}