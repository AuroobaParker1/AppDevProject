import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VerifyOTPScreen extends StatefulWidget {
  final String email;

  const VerifyOTPScreen({required this.email, Key? key}) : super(key: key);

  @override
  _VerifyOTPScreenState createState() => _VerifyOTPScreenState();
}

class _VerifyOTPScreenState extends State<VerifyOTPScreen> {
  final TextEditingController _otpController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  Future<void> verifyOTPAndChangePassword() async {
    final url = 'https://medqr-blockchain.onrender.com/api/patients/verify-otp';
    final response = await http.post(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': widget.email,
        'otp': _otpController.text,
        'newPassword': _newPasswordController.text,
      }),
    );

    if (response.statusCode == 200) {
      // Password reset successful
      Navigator.pop(context);
    } else {
      // Handle error
      print('Failed to reset password');
    }
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
              'Verify OTP',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10.0),
            const Text(
              "Enter the OTP sent to your email and your new password.",
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _otpController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter OTP',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20.0),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter new password',
              ),
              obscureText: true,
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                verifyOTPAndChangePassword();
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
          ],
        ),
      ),
    );
  }
}