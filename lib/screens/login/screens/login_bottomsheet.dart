import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce/screens/login/screens/profile_page.dart';
import 'package:ecommerce/screens/login/services/phone_auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

final _phoneAuthService = PhoneAuthService();

class LoginBottomSheet extends StatefulWidget {
  const LoginBottomSheet({super.key});

  @override
  State<LoginBottomSheet> createState() => _LoginBottomSheetState();
}

class _LoginBottomSheetState extends State<LoginBottomSheet> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();
  bool otpSent = false;
  String? _verificationId;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _phoneController.addListener(_onPhoneChanged);
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _onPhoneChanged() {
    setState(() {}); // Triggers rebuild to update Get OTP button state
  }

  void _sendOtp() {
    setState(() {
      _isLoading = true;
    });
    try {
      _phoneAuthService.verifyPhoneNumber(
          phoneNumber: _phoneController.text,
          onCodeSent: (verificationId, resendToken) {
            setState(() {
              _verificationId = verificationId;
              otpSent = true;
              _isLoading = false;
            });

            // Wait for the OTP field to appear, then focus it
            WidgetsBinding.instance.addPostFrameCallback((_) {
              FocusScope.of(context)
                  .nextFocus(); // Moves focus to the next input (OTP field)
            });

            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("OTP sent to your mobile number")),
            );
          },
          onVerificationCompleted: (credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            Navigator.pop(context);
            ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Logged in automatically")));
          },
          onVerificationFailed: (e) {
            setState(() {
              _isLoading = false;
            });
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text("Failed: ${e.message}")));
          },
          onCodeAutoRetrievalTimeout: () {
            setState(() {
              _isLoading = false;
            });
          });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
      log(e.toString());
    }
  }

  void _verifyOtp() async {
    final smsCode = _otpController.text.trim();

    if (_verificationId != null && smsCode.length == 6) {
      setState(() {
        _isLoading = true;
      });
      try {
          final userCredential = await _phoneAuthService.signInWithOtp(
              verificationId: _verificationId!,
              smsCode: smsCode
            );

          final user = userCredential.user;
          if(user != null) {
            // User is signed in
            final uid = user.uid;

            final docSnapshot = await FirebaseFirestore.instance
                .collection('users')
                .doc(uid)
                .get();
            
            if (docSnapshot.exists) {
              // ✅ Existing user: go to payment screen (or home)
              // Navigator.pushReplacement(
              //   context,
              //   MaterialPageRoute(builder: (_) => CartScreen()), // you can change destination
              // );
              Navigator.pop(context); // Close the bottom sheet
            } else{
              // 🆕 New user: redirect to profile page to fill name, address etc.
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ProfilePage(
                    phoneNumber: user.phoneNumber ?? '', // Pass phone number
                    uid: uid,
                  ),
                ),
              );
            }

          } 
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("OTP Verification Failed: $e")),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Enter valid OTP")),
      );
    }
  }

  bool get isPhoneValid => _phoneController.text.length == 10;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 20,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),

            // Optional: Replace with your asset if needed
            Image.asset(
              'assets/icons/jeelani-logo-full.png', // Add your logo in assets
              height: 30,
            ),

            const SizedBox(height: 16),
            const Text(
              "Login or Sign Up",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            // Phone Number Input with +91 Prefix
            TextField(
              controller: _phoneController,
              keyboardType: TextInputType.number,
              maxLength: 10,
              inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              decoration: InputDecoration(
                counterText: "",
                prefix: const Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Text("+91 |"),
                ),
                hintText: "Enter 10-digit mobile number",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Get OTP Button or OTP Entry
            if (!otpSent)
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: isPhoneValid && !_isLoading ? _sendOtp : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    disabledBackgroundColor: Colors.grey.shade400,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Get OTP"),
                ),
              )
            else ...[
              TextField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                onChanged: (value) {
                  if (value.length == 6) {
                    _verifyOtp();
                  }
                },
                decoration: InputDecoration(
                  hintText: "Enter OTP",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _verifyOtp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orangeAccent,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text("Verify and continue"),
                ),
              ),
            ],
            const SizedBox(height: 16),

            // Terms & Privacy Text
            Text.rich(
              TextSpan(
                text: 'By continuing, I agree to Jeelani Collection’s ',
                style: const TextStyle(fontSize: 12, color: Colors.black54),
                children: [
                  TextSpan(
                    text: 'T&C',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
