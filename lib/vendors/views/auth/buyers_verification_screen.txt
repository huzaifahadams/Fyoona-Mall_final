import 'package:flutter/material.dart';
import 'services/auth_services.dart';

class BuyersVerificationScreen extends StatefulWidget {
  final String email;

  const BuyersVerificationScreen({Key? key, required this.email})
      : super(key: key);

  @override
  BuyersVerificationScreenState createState() =>
      BuyersVerificationScreenState();
}

class BuyersVerificationScreenState extends State<BuyersVerificationScreen> {
  final AuthService authService = AuthService();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.yellow.shade900,
        title: const Text('Verification'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Enter the 6-digit code sent to ${widget.email}',
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _verificationCodeController,
              keyboardType: TextInputType.number,
              maxLength: 6,
              decoration: const InputDecoration(
                labelText: 'Verification Code',
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add code to verify the entered code
                // Call a function in AuthService to handle verification
                authService.verifyCode(
                  context: context,
                  email: widget.email,
                  code: _verificationCodeController.text,
                );
              },
              child: const Text('Verify'),
            ),
            const SizedBox(height: 20),
            TextButton(
              onPressed: () {
                // Add code to resend the verification email
                // Call a function in AuthService to handle resend
                authService.resendVerificationEmail(context, widget.email);
              },
              child: const Text('Resend Code'),
            ),
          ],
        ),
      ),
    );
  }
}
