// // ignore_for_file: unused_import, unused_catch_clause, library_private_types_in_public_api, sort_child_properties_last

// import 'package:aap_dev_project/pages/account/authentication.dart';
// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_core/firebase_core.dart';

// class ForgotPasswordScreen extends StatefulWidget {
//   const ForgotPasswordScreen({super.key});

//   @override
//   _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
// }

// class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
//     with RouteAware {
//   final TextEditingController _emailController = TextEditingController();

//   final FirebaseAuth _auth = FirebaseAuth.instance;

//   Future<void> resetPassword(String email) async {
//     await _auth.sendPasswordResetEmail(email: email);
//   }

//   @override
//   void didPopNext() {
//     setState(() {});
//     super.didPopNext();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: const BackButton(color: Colors.black), // Back button
//         backgroundColor: Colors.white,
//         elevation: 0,
//       ),
//       backgroundColor: Colors.white,
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.start,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: <Widget>[
//             const Text(
//               'Forgot Password?',
//               style: TextStyle(
//                 fontSize: 24.0,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(height: 10.0),
//             const Text(
//               "Enter your email and we'll send you a link to reset your password.",
//               style: TextStyle(
//                 fontSize: 16.0,
//                 color: Colors.grey,
//               ),
//             ),
//             const SizedBox(height: 20.0),
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(
//                 border: OutlineInputBorder(),
//                 labelText: 'Enter your email',
//               ),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             const SizedBox(height: 20.0),
//             FloatingActionButton(
//               onPressed: () {
//                 resetPassword(_emailController.text);
//               },
//               backgroundColor: const Color(0xFF01888B),
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Text(
//                 'Reset Password',
//                 style: TextStyle(
//                   fontFamily: 'Urbanist',
//                   color: Colors.white,
//                 ),
//               ),
//             ),
//             Stack(
//               children: <Widget>[
//                 const Column(
//                   mainAxisAlignment: MainAxisAlignment.start,
//                   crossAxisAlignment: CrossAxisAlignment.stretch,
//                   children: <Widget>[],
//                 ),
//                 Align(
//                   alignment: Alignment.bottomCenter,
//                   child: TextButton(
//                     child: const Text(
//                       'Remember Password? Login',
//                       style: TextStyle(color: Colors.teal),
//                     ),
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                             builder: (context) => const LoginScreen()),
//                       );
//                     },
//                   ),
//                 ),
//               ],
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:aap_dev_project/pages/account/verifyOTP.dart' ;
class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with RouteAware {
  final TextEditingController _emailController = TextEditingController();

  Future<void> resetPassword(String email) async {
    final url = 'https://medqr-blockchain.onrender.com/api/patients/forgot-password';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{'email': email}),
    );

    if (response.statusCode == 200) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => VerifyOTPScreen(email: email)),
      );
    } else {
      // Handle error
      print('Failed to send OTP');
    }
  }

  @override
  void didPopNext() {
    setState(() {});
    super.didPopNext();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const BackButton(color: Colors.black), // Back button
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Forgot Password?',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Enter your email and we'll send you a link to reset your password.",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your email',
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                resetPassword(_emailController.text);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF01888B),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text(
                'Reset Password',
                style: TextStyle(
                  fontFamily: 'Urbanist',
                  color: Colors.white,
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: TextButton(
                child: const Text(
                  'Remember Password? Login',
                  style: TextStyle(color: Colors.teal),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}